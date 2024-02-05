import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock_client/api.dart' show DLCDTO, NewDLCDTO;

import 'package:logic/model/model.dart' show ItemImage;
import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/item_detail/item_detail.dart';
import 'package:logic/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:logic/bloc/item_relation/item_relation.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';

import '../relation/relation.dart';
import '../theme/theme.dart' show DLCTheme;
import 'item_detail.dart';
import 'finish_date_list.dart';

class DLCDetail
    extends ItemDetail<DLCDTO, NewDLCDTO, DLCDetailBloc, DLCDetailManagerBloc> {
  const DLCDetail({
    super.key,
    required super.item,
    super.onChange,
  });

  @override
  DLCDetailBloc detailBlocBuilder(
    GameOClockService collectionService,
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
    GameOClockService collectionService,
  ) {
    return DLCDetailManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );
  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(
    GameOClockService collectionService,
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
    super.onChange,
  }) : super(
          hasImage: DLCTheme.hasImage,
        );

  @override
  String itemTitle(DLCDTO item) => DLCTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, DLCDTO dlc) {
    return <Widget>[
      itemTextField(
        context,
        fieldName: AppLocalizations.of(context)!.nameFieldString,
        value: dlc.name,
        item: dlc,
        itemUpdater: (String newValue) => dlc.newWith(name: newValue),
      ),
      itemYearField(
        context,
        fieldName: AppLocalizations.of(context)!.releaseYearFieldString,
        value: dlc.releaseYear,
        item: dlc,
        itemUpdater: (int? newValue) =>
            dlc.newWith(releaseYear: newValue)..releaseYear = newValue,
      ),
      DLCFinishList(
        fieldName: AppLocalizations.of(context)!.finishDatesFieldString,
        relationTypeName: AppLocalizations.of(context)!.finishDateFieldString,
      ),
    ];
  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {
    return <Widget>[
      DLCGameRelationList(
        relationName: AppLocalizations.of(context)!.baseGameFieldString,
        relationTypeName: AppLocalizations.of(context)!.gameString,
      ),
      DLCPlatformRelationList(
        relationName: AppLocalizations.of(context)!.platformsString,
        relationTypeName: AppLocalizations.of(context)!.platformString,
      ),
    ];
  }

  @override
  List<Widget> itemSkeletonFieldsBuilder(BuildContext context) {
    int order = 0;

    return <Widget>[
      itemSkeletonLongTextField(
        fieldName: AppLocalizations.of(context)!.nameFieldString,
        order: order++,
      ),
      itemSkeletonField(
        fieldName: AppLocalizations.of(context)!.releaseYearFieldString,
        order: order++,
      ),
      DLCFinishList(
        fieldName: AppLocalizations.of(context)!.finishDatesFieldString,
        relationTypeName: AppLocalizations.of(context)!.finishDateFieldString,
        skeletonOrder: order++,
      ),
    ];
  }

  @override
  ItemImage buildItemImage(DLCDTO item) {
    return ItemImage(item.coverUrl, item.coverFilename);
  }

  @override
  void reloadExtraFields(BuildContext context) {
    BlocProvider.of<DLCFinishRelationBloc>(context).add(ReloadItemRelation());
  }
}

class DLCFinishList
    extends FinishList<DLCFinishRelationBloc, DLCFinishRelationManagerBloc> {
  const DLCFinishList({
    super.key,
    required super.fieldName,
    required super.relationTypeName,
    super.skeletonOrder,
  });
}
