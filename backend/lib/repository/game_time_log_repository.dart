import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/entity/entity.dart' show GameTimeLogEntity, GameWithLogsEntity, GameEntityData;
import 'package:backend/model/model.dart' show GameTimeLog, GameWithLogs;

import './query/query.dart' show GameTimeLogQuery;
import 'item_repository.dart';


class GameTimeLogRepository extends ItemRepository {
  GameTimeLogRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  //#region CREATE
  Future<dynamic> createGameTimeLog(int gameId, GameTimeLog timeLog) {

    final GameTimeLogEntity entity = GameMapper.logModelToEntity(timeLog);
    final Query query = GameTimeLogQuery.create(entity, gameId);

    return itemConnector.execute(query);

  }
  //#endregion CREATE

  //#region READ
  Stream<List<GameTimeLog>> findAllGameTimeLogsFromGame(int id) {

    final Query query = GameTimeLogQuery.selectAllByGame(id);
    return itemConnector.execute(query)
      .asStream().map( _dynamicToListTimeLog );

  }

  Stream<List<GameWithLogs>> findAllGamesWithTimeLogsByYear(int year) {

    final Query query = GameTimeLogQuery.selectAllWithGameByYear(year);
    return itemConnector.execute(query)
      .asStream().map( _dynamicToListGamesWithLogs );

  }
  //#endregion READ

  //#region DELETE
  Future<dynamic> deleteGameTimeLogById(int gameId, DateTime dateTime) {

    final Query query = GameTimeLogQuery.deleteById(gameId, dateTime);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region DOWNLOAD
  String? _getGameCoverURL(String? gameCoverName) {

    return gameCoverName != null? // TODO remove, use the one in GameRepository
        imageConnector.getURI(
          tableName: GameEntityData.table,
          imageFilename: gameCoverName,
        )
        : null;

  }
  //#endregion DOWNLOAD

  List<GameTimeLog> _dynamicToListTimeLog(List<Map<String, Map<String, dynamic>>> results) {

    return GameTimeLogEntity.fromDynamicMapList(results).map( GameMapper.logEntityToModel ).toList(growable: false);

  }

  List<GameWithLogs> _dynamicToListGamesWithLogs(List<Map<String, Map<String, dynamic>>> results) {

    return GameWithLogsEntity.fromDynamicMapList(results).map( (GameWithLogsEntity gameWithLogsEntity) {
      return GameMapper.gameWithLogEntityToModel(gameWithLogsEntity, _getGameCoverURL(gameWithLogsEntity.game.coverFilename));
    }).toList(growable: false);

  }
}