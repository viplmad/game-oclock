import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart' show Item, GameTag, Game;
import 'package:backend/repository/repository.dart' show GameCollectionRepository;

import 'package:backend/bloc/item_detail/item_detail.dart';
import 'package:backend/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../relation/relation.dart';
import '../theme/theme.dart' show GameTagTheme;
import 'item_detail.dart';


class GameTagDetail extends ItemDetail<GameTag, GameTagDetailBloc, GameTagDetailManagerBloc> {
  GameTagDetail({
    Key? key,
    required GameTag item,
    void Function(GameTag? item)? onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  GameTagDetailBloc detailBlocBuilder(GameCollectionRepository collectionRepository, GameTagDetailManagerBloc managerBloc) {

    return GameTagDetailBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
      managerBloc: managerBloc,
    );

  }

  @override
  GameTagDetailManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return GameTagDetailManagerBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(GameCollectionRepository collectionRepository) {

    final GameTagRelationManagerBloc<Game> _gameTagRelationManagerBloc = GameTagRelationManagerBloc<Game>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      blocProviderRelationBuilder<Game>(collectionRepository, _gameTagRelationManagerBloc),

      BlocProvider<GameTagRelationManagerBloc<Game>>(
        create: (BuildContext context) {
          return _gameTagRelationManagerBloc;
        },
      ),
    ];

  }

  @override
  _GameTagDetailBody detailBodyBuilder() {

    return _GameTagDetailBody(
      itemId: item.id,
      onUpdate: onUpdate,
    );

  }

  BlocProvider<GameTagRelationBloc<W>> blocProviderRelationBuilder<W extends Item>(GameCollectionRepository collectionRepository, GameTagRelationManagerBloc<W> managerBloc) {

    return BlocProvider<GameTagRelationBloc<W>>(
      create: (BuildContext context) {
        return GameTagRelationBloc<W>(
          itemId: item.id,
          collectionRepository: collectionRepository,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );

  }
}

// ignore: must_be_immutable
class _GameTagDetailBody extends ItemDetailBody<GameTag, GameTagDetailBloc, GameTagDetailManagerBloc> {
  _GameTagDetailBody({
    Key? key,
    required this.itemId,
    void Function(GameTag? item)? onUpdate,
  }) : super(key: key, onUpdate: onUpdate);

  final int itemId;

  @override
  String itemTitle(GameTag item) => GameTagTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, GameTag gameTag) {

    return <Widget>[
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        value: gameTag.name,
        item: gameTag,
        itemUpdater: (String newValue) => gameTag.copyWith(name: newValue),
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {

    return <Widget>[
      GameTagGameRelationList(
        relationName: GameCollectionLocalisations.of(context).gamesString,
        relationTypeName: GameCollectionLocalisations.of(context).gameString,
      )
    ];

  }
}