import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/entity/entity.dart' show GameFinishEntity;
import 'package:backend/model/model.dart' show GameFinish;

import './query/query.dart' show GameFinishQuery;
import 'item_repository.dart';


class GameFinishRepository extends ItemRepository {
  GameFinishRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  //#region CREATE
  Future<dynamic> createGameFinish(int gameId, GameFinish finish) {

    final GameFinishEntity entity = GameMapper.finishModelToEntity(finish);
    final Query query = GameFinishQuery.create(entity, gameId);

    return itemConnector.execute(query);

  }
  //#endregion CREATE

  //#region READ
  Stream<List<GameFinish>> findAllGameFinishFromGame(int id) {

    final Query query = GameFinishQuery.selectAllByGame(id);
    return itemConnector.execute(query)
      .asStream().map( _dynamicToListGameFinish );

  }
  //#endregion READ

  //#region DELETE
  Future<dynamic> deleteGameFinishById(int gameId, DateTime date) {

    final Query query = GameFinishQuery.deleteById(gameId, date);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  List<GameFinish> _dynamicToListGameFinish(List<Map<String, Map<String, dynamic>>> results) {

    return GameFinishEntity.fromDynamicMapList(results).map( GameMapper.finishEntityToModel ).toList(growable: false);

  }
}