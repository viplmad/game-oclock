import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection_client/api.dart' show DLCDTO, NewDLCDTO;

import 'package:backend/model/model.dart' show ItemImage;
import 'package:backend/service/service.dart' show GameCollectionService;
import 'package:backend/bloc/item_detail/item_detail.dart';
import 'package:backend/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../relation/relation.dart';
import '../theme/theme.dart' show DLCTheme;
import 'item_detail.dart';
import 'finish_date_list.dart';

class DLCDetail
    extends ItemDetail<DLCDTO, NewDLCDTO, DLCDetailBloc, DLCDetailManagerBloc> {
  const DLCDetail({
    Key? key,
    required super.item,
    super.onChange,
  }) : super(key: key);

  @override
  DLCDetailBloc detailBlocBuilder(
    GameCollectionService collectionService,
    DLCDetailManagerBloc managerBloc,
  ) {
    return DLCDetailBloc(
      itemId: item.id,
      collectionService: collectionService,
      managerBloc: managerBloc,
    );
  }

  @override
  DLCDetailManagerBloc managerBlocBuilder(
    GameCollectionService collectionService,
  ) {
    return DLCDetailManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );
  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(
    GameCollectionService collectionService,
  ) {
    final DLCFinishRelationManagerBloc finishRelationManagerBloc =
        DLCFinishRelationManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );

    final DLCGameRelationManagerBloc gameRelationManagerBloc =
        DLCGameRelationManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );

    final DLCPlatformRelationManagerBloc platformRelationManagerBloc =
        DLCPlatformRelationManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      BlocProvider<DLCFinishRelationBloc>(
        create: (BuildContext context) {
          return DLCFinishRelationBloc(
            itemId: item.id,
            collectionService: collectionService,
            managerBloc: finishRelationManagerBloc,
          )..add(LoadItemRelation());
        },
      ),
      BlocProvider<DLCGameRelationBloc>(
        create: (BuildContext context) {
          return DLCGameRelationBloc(
            itemId: item.id,
            collectionService: collectionService,
            managerBloc: gameRelationManagerBloc,
          )..add(LoadItemRelation());
        },
      ),
      BlocProvider<DLCPlatformRelationBloc>(
        create: (BuildContext context) {
          return DLCPlatformRelationBloc(
            itemId: item.id,
            collectionService: collectionService,
            managerBloc: platformRelationManagerBloc,
          )..add(LoadItemRelation());
        },
      ),
      BlocProvider<DLCFinishRelationManagerBloc>(
        create: (BuildContext context) {
          return finishRelationManagerBloc;
        },
      ),
      BlocProvider<DLCGameRelationManagerBloc>(
        create: (BuildContext context) {
          return gameRelationManagerBloc;
        },
      ),
      BlocProvider<DLCPlatformRelationManagerBloc>(
        create: (BuildContext context) {
          return platformRelationManagerBloc;
        },
      ),
    ];
  }

  @override
  // ignore: library_private_types_in_public_api
  _DLCDetailBody detailBodyBuilder() {
    return _DLCDetailBody(
      onChange: onChange,
    );
  }
}

// ignore: must_be_immutable
class _DLCDetailBody extends ItemDetailBody<DLCDTO, NewDLCDTO, DLCDetailBloc,
    DLCDetailManagerBloc> {
  _DLCDetailBody({
    Key? key,
    super.onChange,
  }) : super(
          key: key,
          hasImage: DLCTheme.hasImage,
        );

  @override
  String itemTitle(DLCDTO item) => DLCTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, DLCDTO dlc) {
    return <Widget>[
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        value: dlc.name,
        item: dlc,
        itemUpdater: (String newValue) => dlc.newWith(name: newValue),
      ),
      itemYearField(
        context,
        fieldName:
            GameCollectionLocalisations.of(context).releaseYearFieldString,
        value: dlc.releaseYear,
        item: dlc,
        itemUpdater: (int newValue) => dlc.newWith(releaseYear: newValue),
      ),
      DLCFinishList(
        fieldName:
            GameCollectionLocalisations.of(context).finishDatesFieldString,
        value: dlc.firstFinish,
        relationTypeName:
            GameCollectionLocalisations.of(context).finishDateFieldString,
        onChange: () {
          BlocProvider.of<DLCDetailBloc>(context).add(const ReloadItem(true));
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
      DLCPlatformRelationList(
        relationName: GameCollectionLocalisations.of(context).platformsString,
        relationTypeName:
            GameCollectionLocalisations.of(context).platformString,
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
        onChange: () {
          BlocProvider.of<DLCDetailBloc>(context).add(const ReloadItem());
        },
      ),
    ];
  }

  @override
  ItemImage buildItemImage(DLCDTO item) {
    return ItemImage(item.coverUrl, item.coverFilename);
  }
}

// ignore: must_be_immutable
class DLCFinishList
    extends FinishList<DLCFinishRelationBloc, DLCFinishRelationManagerBloc> {
  DLCFinishList({
    Key? key,
    required super.fieldName,
    required super.value,
    required super.relationTypeName,
    required super.onChange,
  }) : super(key: key);
}

// ignore: must_be_immutable
class SkeletonDLCFinishList extends SkeletonFinishList<DLCFinishRelationBloc,
    DLCFinishRelationManagerBloc> {
  SkeletonDLCFinishList({
    Key? key,
    required super.fieldName,
    required super.relationTypeName,
    required super.order,
    required super.onChange,
  }) : super(key: key);
}
