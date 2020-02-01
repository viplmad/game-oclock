import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/entity.dart';
import 'package:game_collection/model/game.dart';

import 'entity_list.dart';


class GameListBloc extends EntityListBloc {

  GameListBloc({@required ICollectionRepository collectionRepository}) : super(collectionRepository: collectionRepository);

  @override
  Stream<List<Game>> getReadStream() {

    return collectionRepository.getAllGames();

  }

  @override
  Stream<dynamic> getCreateStream(Entity entity) {

    final Game game = (entity as Game);

    return collectionRepository.insertGame('', '').asStream();

  }

  @override
  Stream getDeleteStream(Entity entity) {

    return collectionRepository.deleteGame(entity.ID).asStream();

  }

}