import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import '../theme/theme.dart';
import '../relation/relation.dart';
import 'item_detail.dart';


class PlatformDetail extends ItemDetail<Platform, PlatformDetailBloc> {
  const PlatformDetail({Key key, @required Platform item}) : super(item: item, key: key);

  @override
  PlatformDetailBloc detailBlocBuilder() {

    return PlatformDetailBloc(
      platformID: item.ID,
      collectionRepository: CollectionRepository(),
    );

  }

  @override
  List<BlocProvider> relationBlocsBuilder() {

    return [
      blocProviderRelationBuilder<Game>(),
      blocProviderRelationBuilder<System>(),
    ];

  }

  @override
  ThemeData getThemeData(BuildContext context) {

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

  BlocProvider<PlatformRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>() {

    return BlocProvider<PlatformRelationBloc<W>>(
      create: (BuildContext context) {
        return PlatformRelationBloc<W>(
          platformID: item.ID,
          collectionRepository: CollectionRepository(),
        )..add(LoadItemRelation());
      },
    );

  }

}

class _PlatformDetailBody extends ItemDetailBody<Platform, PlatformDetailBloc> {

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