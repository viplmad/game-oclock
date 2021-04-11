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

import '../relation/relation.dart';
import '../theme/theme.dart';
import 'item_detail.dart';


class PlatformDetail extends ItemDetail<Platform, PlatformDetailBloc, PlatformDetailManagerBloc> {
  const PlatformDetail({
    Key? key,
    required Platform item,
    void Function(Platform? item)? onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  PlatformDetailBloc detailBlocBuilder(PlatformDetailManagerBloc managerBloc) {

    return PlatformDetailBloc(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
      managerBloc: managerBloc,
    );

  }

  @override
  PlatformDetailManagerBloc managerBlocBuilder() {

    return PlatformDetailManagerBloc(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

  }

  @override
  List<BlocProvider<dynamic>> relationBlocsBuilder() {

    final PlatformRelationManagerBloc<Game> _gameRelationManagerBloc = PlatformRelationManagerBloc<Game>(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    final PlatformRelationManagerBloc<System> _systemRelationManagerBloc = PlatformRelationManagerBloc<System>(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    return <BlocProvider<dynamic>>[
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
  _PlatformDetailBody detailBodyBuilder() {

    return _PlatformDetailBody(
      onUpdate: onUpdate,
    );

  }

  BlocProvider<PlatformRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>(PlatformRelationManagerBloc<W> managerBloc) {

    return BlocProvider<PlatformRelationBloc<W>>(
      create: (BuildContext context) {
        return PlatformRelationBloc<W>(
          itemId: item.id,
          iCollectionRepository: ICollectionRepository.iCollectionRepository!,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );

  }
}

// ignore: must_be_immutable
class _PlatformDetailBody extends ItemDetailBody<Platform, PlatformDetailBloc, PlatformDetailManagerBloc> {
  _PlatformDetailBody({
    Key? key,
    void Function(Platform? item)? onUpdate,
  }) : super(key: key, onUpdate: onUpdate);

  @override
  String itemTitle(Platform item) => PlatformTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, Platform platform) {

    return <Widget>[
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
        possibleValues: <String>[
          GameCollectionLocalisations.of(context).physicalString,
          GameCollectionLocalisations.of(context).digitalString,
        ],
        possibleValuesColours: PlatformTheme.typeColours,
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
}