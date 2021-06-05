import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart';

import 'package:backend/repository/repository.dart';

import 'package:backend/bloc/item_detail/item_detail.dart';
import 'package:backend/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../relation/relation.dart';
import '../theme/theme.dart';
import 'item_detail.dart';
import 'finish_date_list.dart';


class DLCDetail extends ItemDetail<DLC, DLCUpdateProperties, DLCDetailBloc, DLCDetailManagerBloc> {
  const DLCDetail({
    Key? key,
    required DLC item,
    void Function(DLC? item)? onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  DLCDetailBloc detailBlocBuilder(DLCDetailManagerBloc managerBloc) {

    return DLCDetailBloc(
      itemId: item.id,
      iCollectionRepository: CollectionRepository.iCollectionRepository!,
      managerBloc: managerBloc,
    );

  }

  @override
  DLCDetailManagerBloc managerBlocBuilder() {

    return DLCDetailManagerBloc(
      itemId: item.id,
      iCollectionRepository: CollectionRepository.iCollectionRepository!,
    );

  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder() {

    final DLCRelationManagerBloc<Game> _gameRelationManagerBloc = DLCRelationManagerBloc<Game>(
      itemId: item.id,
      iCollectionRepository: CollectionRepository.iCollectionRepository!,
    );

    final DLCRelationManagerBloc<Purchase> _purchaseRelationManagerBloc = DLCRelationManagerBloc<Purchase>(
      itemId: item.id,
      iCollectionRepository: CollectionRepository.iCollectionRepository!,
    );

    final DLCFinishRelationManagerBloc _finishRelationManagerBloc = DLCFinishRelationManagerBloc(
      itemId: item.id,
      iCollectionRepository: CollectionRepository.iCollectionRepository!,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      blocProviderRelationBuilder<Game>(_gameRelationManagerBloc),
      blocProviderRelationBuilder<Purchase>(_purchaseRelationManagerBloc),

      BlocProvider<DLCRelationManagerBloc<Game>>(
        create: (BuildContext context) {
          return _gameRelationManagerBloc;
        },
      ),
      BlocProvider<DLCRelationManagerBloc<Purchase>>(
        create: (BuildContext context) {
          return _purchaseRelationManagerBloc;
        },
      ),

      BlocProvider<DLCFinishRelationBloc>(
        create: (BuildContext context) {
          return DLCFinishRelationBloc(
            itemId: item.id,
            iCollectionRepository: CollectionRepository.iCollectionRepository!,
            managerBloc: _finishRelationManagerBloc,
          )..add(LoadRelation());
        },
      ),
      BlocProvider<DLCFinishRelationManagerBloc>(
        create: (BuildContext context) {
          return _finishRelationManagerBloc;
        },
      ),
    ];

  }

  @override
  _DLCDetailBody detailBodyBuilder() {

    return _DLCDetailBody(
      onUpdate: onUpdate,
    );

  }

  BlocProvider<DLCRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>(DLCRelationManagerBloc<W> managerBloc) {

    return BlocProvider<DLCRelationBloc<W>>(
      create: (BuildContext context) {
        return DLCRelationBloc<W>(
          itemId: item.id,
          iCollectionRepository: CollectionRepository.iCollectionRepository!,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );

  }
}

// ignore: must_be_immutable
class _DLCDetailBody extends ItemDetailBody<DLC, DLCUpdateProperties, DLCDetailBloc, DLCDetailManagerBloc> {
  _DLCDetailBody({
    Key? key,
    void Function(DLC? item)? onUpdate,
  }) : super(key: key, onUpdate: onUpdate);

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
        updateProperties: const DLCUpdateProperties(),
      ),
      itemYearField(
        context,
        fieldName: GameCollectionLocalisations.of(context).releaseYearFieldString,
        value: dlc.releaseYear,
        item: dlc,
        itemUpdater: (int newValue) => dlc.copyWith(releaseYear: newValue),
        updateProperties: const DLCUpdateProperties(),
      ),
      DLCFinishList(
        fieldName: GameCollectionLocalisations.of(context).finishDatesFieldString,
        value: dlc.finishDate,
        relationTypeName: GameCollectionLocalisations.of(context).finishDateFieldString,
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
        relationName: GameCollectionLocalisations.of(context).baseGameFieldString,
        relationTypeName: GameCollectionLocalisations.of(context).gameString,
      ),
      DLCPurchaseRelationList(
        relationName: GameCollectionLocalisations.of(context).purchasesString,
        relationTypeName: GameCollectionLocalisations.of(context).purchaseString,
      ),
    ];

  }
}

// ignore: must_be_immutable
class DLCFinishList extends FinishList<DLC, DLCFinish, DLCFinishRelationBloc, DLCFinishRelationManagerBloc> {
  DLCFinishList({
    Key? key,
    required String fieldName,
    required DateTime? value,
    required String relationTypeName,
    required void Function() onUpdate,
  }) : super(key: key, fieldName: fieldName, value: value, relationTypeName: relationTypeName, onUpdate: onUpdate);

  @override
  DLCFinish createFinish(DateTime dateTime) => DLCFinish(dateTime: dateTime);
}