import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock_client/api.dart'
    show PlatformDTO, NewPlatformDTO, PlatformType;

import 'package:logic/model/model.dart' show ItemImage;
import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/item_detail/item_detail.dart';
import 'package:logic/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:logic/bloc/item_relation/item_relation.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';

import '../relation/relation.dart';
import '../theme/theme.dart' show PlatformTheme;
import 'item_detail.dart';

class PlatformDetail extends ItemDetail<PlatformDTO, NewPlatformDTO,
    PlatformDetailBloc, PlatformDetailManagerBloc> {
  const PlatformDetail({
    super.key,
    required super.item,
    super.onChange,
  });

  @override
  PlatformDetailBloc detailBlocBuilder(
    GameOClockService collectionService,
    PlatformDetailManagerBloc managerBloc,
  ) {
    return PlatformDetailBloc(
      itemId: item.id,
      collectionService: collectionService,
      managerBloc: managerBloc,
    );
  }

  @override
  PlatformDetailManagerBloc managerBlocBuilder(
    GameOClockService collectionService,
  ) {
    return PlatformDetailManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );
  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(
    GameOClockService collectionService,
  ) {
    final PlatformGameRelationManagerBloc gameRelationManagerBloc =
        PlatformGameRelationManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );

    final PlatformDLCRelationManagerBloc dlcRelationManagerBloc =
        PlatformDLCRelationManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      BlocProvider<PlatformGameRelationBloc>(
        create: (BuildContext context) {
          return PlatformGameRelationBloc(
            itemId: item.id,
            collectionService: collectionService,
            managerBloc: gameRelationManagerBloc,
          )..add(LoadItemRelation());
        },
      ),
      BlocProvider<PlatformDLCRelationBloc>(
        create: (BuildContext context) {
          return PlatformDLCRelationBloc(
            itemId: item.id,
            collectionService: collectionService,
            managerBloc: dlcRelationManagerBloc,
          )..add(LoadItemRelation());
        },
      ),
      BlocProvider<PlatformGameRelationManagerBloc>(
        create: (BuildContext context) {
          return gameRelationManagerBloc;
        },
      ),
      BlocProvider<PlatformDLCRelationManagerBloc>(
        create: (BuildContext context) {
          return dlcRelationManagerBloc;
        },
      ),
    ];
  }

  @override
  // ignore: library_private_types_in_public_api
  _PlatformDetailBody detailBodyBuilder() {
    return _PlatformDetailBody(
      onChange: onChange,
    );
  }
}

// ignore: must_be_immutable
class _PlatformDetailBody extends ItemDetailBody<PlatformDTO, NewPlatformDTO,
    PlatformDetailBloc, PlatformDetailManagerBloc> {
  _PlatformDetailBody({
    super.onChange,
  }) : super(
          hasImage: PlatformTheme.hasImage,
        );

  @override
  String itemTitle(PlatformDTO item) => PlatformTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, PlatformDTO platform) {
    return <Widget>[
      itemTextField(
        context,
        fieldName: AppLocalizations.of(context)!.nameFieldString,
        value: platform.name,
        item: platform,
        itemUpdater: (String newValue) => platform.newWith(name: newValue),
      ),
      itemChipField(
        context,
        fieldName: AppLocalizations.of(context)!.platformTypeFieldString,
        value: platform.type != null
            ? PlatformType.values.indexOf(platform.type!)
            : null,
        possibleValues: <String>[
          AppLocalizations.of(context)!.physicalString,
          AppLocalizations.of(context)!.digitalString,
        ],
        possibleValuesColours: PlatformTheme.typeColours,
        item: platform,
        itemUpdater: (int newValue) =>
            platform.newWith(type: PlatformType.values.elementAt(newValue)),
      ),
    ];
  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {
    return <Widget>[
      PlatformGameRelationList(
        relationName: AppLocalizations.of(context)!.gamesString,
        relationTypeName: AppLocalizations.of(context)!.gameString,
      ),
      PlatformDLCRelationList(
        relationName: AppLocalizations.of(context)!.dlcsString,
        relationTypeName: AppLocalizations.of(context)!.dlcString,
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
      itemSkeletonChipField(
        fieldName: AppLocalizations.of(context)!.platformTypeFieldString,
        order: order++,
      ),
    ];
  }

  @override
  ItemImage buildItemImage(PlatformDTO item) {
    return ItemImage(item.iconUrl, item.iconFilename);
  }
}
