import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import '../theme/theme.dart';
import '../relation/relation.dart';
import 'item_detail.dart';


class PlatformDetail extends ItemDetail<Platform, PlatformDetailBloc, PlatformDetailManagerBloc> {
  const PlatformDetail({Key key, @required Platform item}) : super(item: item, key: key);

  @override
  PlatformDetailBloc detailBlocBuilder(PlatformDetailManagerBloc managerBloc) {

    return PlatformDetailBloc(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
      managerBloc: managerBloc,
    );

  }

  @override
  PlatformDetailManagerBloc managerBlocBuilder() {

    return PlatformDetailManagerBloc(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
    );

  }

  @override
  List<BlocProvider> relationBlocsBuilder() {

    PlatformRelationManagerBloc<Game> _gameRelationManagerBloc = PlatformRelationManagerBloc<Game>(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
    );

    PlatformRelationManagerBloc<System> _systemRelationManagerBloc = PlatformRelationManagerBloc<System>(
      itemID: item.ID,
      iCollectionRepository: CollectionRepository(),
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
  ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData platformTheme = contextTheme.copyWith(
      primaryColor: platformColour,
      accentColor: platformAccentColour,
    );

    return platformTheme;

  }

  @override
  _PlatformDetailBody detailBodyBuilder() {

    return _PlatformDetailBody();

  }

  BlocProvider<PlatformRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>(PlatformRelationManagerBloc<W> managerBloc) {

    return BlocProvider<PlatformRelationBloc<W>>(
      create: (BuildContext context) {
        return PlatformRelationBloc<W>(
          itemID: item.ID,
          iCollectionRepository: CollectionRepository(),
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );

  }

}

class _PlatformDetailBody extends ItemDetailBody<Platform, PlatformDetailBloc, PlatformDetailManagerBloc> {

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, Platform platform) {

    return [
      itemTextField(
        context,
        fieldName: plat_nameField,
        value: platform.name,
      ),
      itemChipField(
        context,
        fieldName: plat_typeField,
        value: platform.type,
        possibleValues: types,
        possibleValuesColours: typeColours,
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder() {

    return [
      PlatformGameRelationList(),
      PlatformSystemRelationList(),
    ];

  }

}