import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart'
    show Item, Platform, PlatformType, Game, System;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/item_detail/item_detail.dart';
import 'package:backend/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../relation/relation.dart';
import '../theme/theme.dart' show PlatformTheme;
import 'item_detail.dart';

class PlatformDetail extends ItemDetail<Platform, PlatformDetailBloc,
    PlatformDetailManagerBloc> {
  const PlatformDetail({
    Key? key,
    required super.item,
    super.onUpdate,
  }) : super(key: key);

  @override
  PlatformDetailBloc detailBlocBuilder(
    GameCollectionRepository collectionRepository,
    PlatformDetailManagerBloc managerBloc,
  ) {
    return PlatformDetailBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
      managerBloc: managerBloc,
    );
  }

  @override
  PlatformDetailManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return PlatformDetailManagerBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );
  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    final PlatformRelationManagerBloc<Game> gameRelationManagerBloc =
        PlatformRelationManagerBloc<Game>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final PlatformRelationManagerBloc<System> systemRelationManagerBloc =
        PlatformRelationManagerBloc<System>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      blocProviderRelationBuilder<Game>(
        collectionRepository,
        gameRelationManagerBloc,
      ),
      blocProviderRelationBuilder<System>(
        collectionRepository,
        systemRelationManagerBloc,
      ),
      BlocProvider<PlatformRelationManagerBloc<Game>>(
        create: (BuildContext context) {
          return gameRelationManagerBloc;
        },
      ),
      BlocProvider<PlatformRelationManagerBloc<System>>(
        create: (BuildContext context) {
          return systemRelationManagerBloc;
        },
      ),
    ];
  }

  @override
  // ignore: library_private_types_in_public_api
  _PlatformDetailBody detailBodyBuilder() {
    return _PlatformDetailBody(
      onUpdate: onUpdate,
    );
  }

  BlocProvider<PlatformRelationBloc<W>>
      blocProviderRelationBuilder<W extends Item>(
    GameCollectionRepository collectionRepository,
    PlatformRelationManagerBloc<W> managerBloc,
  ) {
    return BlocProvider<PlatformRelationBloc<W>>(
      create: (BuildContext context) {
        return PlatformRelationBloc<W>(
          itemId: item.id,
          collectionRepository: collectionRepository,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );
  }
}

// ignore: must_be_immutable
class _PlatformDetailBody extends ItemDetailBody<Platform, PlatformDetailBloc,
    PlatformDetailManagerBloc> {
  _PlatformDetailBody({
    Key? key,
    super.onUpdate,
  }) : super(
          key: key,
          hasImage: Platform.hasImage,
        );

  @override
  String itemTitle(Platform item) => PlatformTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, Platform platform) {
    return <Widget>[
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        value: platform.name,
        item: platform,
        itemUpdater: (String newValue) => platform.copyWith(name: newValue),
      ),
      itemChipField(
        context,
        fieldName:
            GameCollectionLocalisations.of(context).platformTypeFieldString,
        value: platform.type?.index,
        possibleValues: <String>[
          GameCollectionLocalisations.of(context).physicalString,
          GameCollectionLocalisations.of(context).digitalString,
        ],
        possibleValuesColours: PlatformTheme.typeColours,
        item: platform,
        itemUpdater: (int newValue) =>
            platform.copyWith(type: PlatformType.values.elementAt(newValue)),
      ),
    ];
  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {
    return <Widget>[
      PlatformGameRelationList(
        relationName: GameCollectionLocalisations.of(context).gamesString,
        relationTypeName: GameCollectionLocalisations.of(context).gameString,
      ),
      PlatformSystemRelationList(
        relationName: GameCollectionLocalisations.of(context).systemsString,
        relationTypeName: GameCollectionLocalisations.of(context).systemString,
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
      itemSkeletonChipField(
        fieldName:
            GameCollectionLocalisations.of(context).platformTypeFieldString,
        order: order++,
      ),
    ];
  }
}
