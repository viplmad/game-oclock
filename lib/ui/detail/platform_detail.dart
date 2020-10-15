import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../theme/theme.dart';
import '../relation/relation.dart';
import 'item_detail.dart';


class PlatformDetail extends ItemDetail<Platform, PlatformDetailBloc, PlatformDetailManagerBloc> {
  const PlatformDetail({
    Key key,
    @required Platform item,
    void Function(Platform item) onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  PlatformDetailBloc detailBlocBuilder(PlatformDetailManagerBloc managerBloc) {

    return PlatformDetailBloc(
      itemID: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
      managerBloc: managerBloc,
    );

  }

  @override
  PlatformDetailManagerBloc managerBlocBuilder() {

    return PlatformDetailManagerBloc(
      itemID: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  List<BlocProvider> relationBlocsBuilder() {

    PlatformRelationManagerBloc<Game> _gameRelationManagerBloc = PlatformRelationManagerBloc<Game>(
      itemID: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

    PlatformRelationManagerBloc<System> _systemRelationManagerBloc = PlatformRelationManagerBloc<System>(
      itemID: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

    return [
      blocProviderRelationBuilder<Game>(_gameRelationManagerBloc),
      blocProviderRelationBuilder<System>(_systemRelationManagerBloc),

      BlocProvider<PlatformRelationManagerBloc<Game>>(
        create: (BuildContext context) {
          return _gameRelationManagerBloc;
        },
      ),
      BlocProvider<PlatformRelationManagerBloc<System>>(
        create: (BuildContext context) {
          return _systemRelationManagerBloc;
        },
      ),
    ];

  }

  @override
  ThemeData themeData(BuildContext context) => PlatformTheme.themeData(context);

  @override
  _PlatformDetailBody detailBodyBuilder() {

    return _PlatformDetailBody(
      onUpdate: onUpdate,
    );

  }

  BlocProvider<PlatformRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>(PlatformRelationManagerBloc<W> managerBloc) {

    return BlocProvider<PlatformRelationBloc<W>>(
      create: (BuildContext context) {
        return PlatformRelationBloc<W>(
          itemID: item.id,
          iCollectionRepository: ICollectionRepository.iCollectionRepository,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );

  }

}

class _PlatformDetailBody extends ItemDetailBody<Platform, PlatformDetailBloc, PlatformDetailManagerBloc> {
  _PlatformDetailBody({
    Key key,
    void Function(Platform item) onUpdate,
  }) : super(key: key, onUpdate: onUpdate);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, Platform platform) {

    return [
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        field: plat_nameField,
        value: platform.name,
      ),
      itemChipField(
        context,
        fieldName: GameCollectionLocalisations.of(context).platformTypeFieldString,
        field: plat_typeField,
        value: platform.type,
        possibleValues: [
          GameCollectionLocalisations.of(context).physicalString,
          GameCollectionLocalisations.of(context).digitalString,
        ],
        possibleValuesColours: PlatformTheme.typeColours,
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {

    return [
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

}