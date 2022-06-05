import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart'
    show Item, DLC, DLCFinish, Game, Purchase;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/item_detail/item_detail.dart';
import 'package:backend/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../relation/relation.dart';
import '../theme/theme.dart' show DLCTheme;
import 'item_detail.dart';
import 'finish_date_list.dart';

class DLCDetail extends ItemDetail<DLC, DLCDetailBloc, DLCDetailManagerBloc> {
  const DLCDetail({
    Key? key,
    required DLC item,
    void Function(DLC? item)? onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  DLCDetailBloc detailBlocBuilder(
    GameCollectionRepository collectionRepository,
    DLCDetailManagerBloc managerBloc,
  ) {
    return DLCDetailBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
      managerBloc: managerBloc,
    );
  }

  @override
  DLCDetailManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return DLCDetailManagerBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );
  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    final DLCRelationManagerBloc<Game> gameRelationManagerBloc =
        DLCRelationManagerBloc<Game>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final DLCRelationManagerBloc<Purchase> purchaseRelationManagerBloc =
        DLCRelationManagerBloc<Purchase>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final DLCRelationManagerBloc<DLCFinish> finishRelationManagerBloc =
        DLCRelationManagerBloc<DLCFinish>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      blocProviderRelationBuilder<Game>(
        collectionRepository,
        gameRelationManagerBloc,
      ),
      blocProviderRelationBuilder<Purchase>(
        collectionRepository,
        purchaseRelationManagerBloc,
      ),
      blocProviderRelationBuilder<DLCFinish>(
        collectionRepository,
        finishRelationManagerBloc,
      ),
      BlocProvider<DLCRelationManagerBloc<Game>>(
        create: (BuildContext context) {
          return gameRelationManagerBloc;
        },
      ),
      BlocProvider<DLCRelationManagerBloc<Purchase>>(
        create: (BuildContext context) {
          return purchaseRelationManagerBloc;
        },
      ),
      BlocProvider<DLCRelationManagerBloc<DLCFinish>>(
        create: (BuildContext context) {
          return finishRelationManagerBloc;
        },
      ),
    ];
  }

  @override
  // ignore: library_private_types_in_public_api
  _DLCDetailBody detailBodyBuilder() {
    return _DLCDetailBody(
      onUpdate: onUpdate,
    );
  }

  BlocProvider<DLCRelationBloc<W>> blocProviderRelationBuilder<W extends Item>(
    GameCollectionRepository collectionRepository,
    DLCRelationManagerBloc<W> managerBloc,
  ) {
    return BlocProvider<DLCRelationBloc<W>>(
      create: (BuildContext context) {
        return DLCRelationBloc<W>(
          itemId: item.id,
          collectionRepository: collectionRepository,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );
  }
}

// ignore: must_be_immutable
class _DLCDetailBody
    extends ItemDetailBody<DLC, DLCDetailBloc, DLCDetailManagerBloc> {
  _DLCDetailBody({
    Key? key,
    void Function(DLC? item)? onUpdate,
  }) : super(
          key: key,
          onUpdate: onUpdate,
          hasImage: DLC.hasImage,
        );

  @override
  String itemTitle(DLC item) => DLCTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, DLC dlc) {
    return <Widget>[
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        value: dlc.name,
        item: dlc,
        itemUpdater: (String newValue) => dlc.copyWith(name: newValue),
      ),
      itemYearField(
        context,
        fieldName:
            GameCollectionLocalisations.of(context).releaseYearFieldString,
        value: dlc.releaseYear,
        item: dlc,
        itemUpdater: (int newValue) => dlc.copyWith(releaseYear: newValue),
      ),
      DLCFinishList(
        fieldName:
            GameCollectionLocalisations.of(context).finishDatesFieldString,
        value: dlc.firstFinishDate,
        relationTypeName:
            GameCollectionLocalisations.of(context).finishDateFieldString,
        onUpdate: () {
          BlocProvider.of<DLCDetailBloc>(context).add(ReloadItem());
        },
      ),
    ];
  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {
    return <Widget>[
      DLCGameRelationList(
        relationName:
            GameCollectionLocalisations.of(context).baseGameFieldString,
        relationTypeName: GameCollectionLocalisations.of(context).gameString,
      ),
      DLCPurchaseRelationList(
        relationName: GameCollectionLocalisations.of(context).purchasesString,
        relationTypeName:
            GameCollectionLocalisations.of(context).purchaseString,
      ),
    ];
  }

  @override
  List<Widget> itemSkeletonFieldsBuilder(BuildContext context) {
    int order = 0;

    return <Widget>[
      itemSkeletonField(
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        order: order++,
      ),
      itemSkeletonField(
        fieldName:
            GameCollectionLocalisations.of(context).releaseYearFieldString,
        order: order++,
      ),
      SkeletonDLCFinishList(
        fieldName:
            GameCollectionLocalisations.of(context).finishDatesFieldString,
        relationTypeName:
            GameCollectionLocalisations.of(context).finishDateFieldString,
        order: order++,
        onUpdate: () {
          BlocProvider.of<DLCDetailBloc>(context).add(ReloadItem());
        },
      ),
    ];
  }
}

// ignore: must_be_immutable
class DLCFinishList extends FinishList<DLCFinish, DLCRelationBloc<DLCFinish>,
    DLCRelationManagerBloc<DLCFinish>> {
  DLCFinishList({
    Key? key,
    required super.fieldName,
    required super.value,
    required super.relationTypeName,
    required super.onUpdate,
  }) : super(key: key);

  @override
  DLCFinish createFinish(DateTime dateTime) => DLCFinish(dateTime: dateTime);
}

// ignore: must_be_immutable
class SkeletonDLCFinishList extends SkeletonFinishList<DLCFinish,
    DLCRelationBloc<DLCFinish>, DLCRelationManagerBloc<DLCFinish>> {
  SkeletonDLCFinishList({
    Key? key,
    required super.fieldName,
    required super.relationTypeName,
    required super.order,
    required super.onUpdate,
  }) : super(key: key);

  @override
  DLCFinish createFinish(DateTime dateTime) => DLCFinish(dateTime: dateTime);
}
