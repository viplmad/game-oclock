import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart'
    show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart'
    show
        GameEntity,
        GameEntityData,
        GameID,
        GameTimeLogEntity,
        GameTimeLogEntityData,
        GameTimeLogID,
        GameWithLogsEntity;

import './query/query.dart' show GameTimeLogQuery;
import 'item_repository.dart';
import 'repository_utils.dart';

class GameTimeLogRepository
    extends ItemRepository<GameTimeLogEntity, GameTimeLogID> {
  const GameTimeLogRepository(
    ItemConnector itemConnector,
    ImageConnector? imageConnector,
  ) : super(
          itemConnector,
          imageConnector,
          recordName: GameTimeLogEntityData.table,
        );

  @override
  GameTimeLogEntity entityFromMap(Map<String, Object?> map) =>
      GameTimeLogEntity.fromMap(map);
  @override
  GameTimeLogID idFromMap(Map<String, Object?> map) =>
      GameTimeLogEntity.idFromMap(map);

  //#region CREATE
  @override
  Future<GameTimeLogEntity> create(GameTimeLogEntity entity) {
    final Query query = GameTimeLogQuery.create(entity);
    return createItem(
      query: query,
    );
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<GameTimeLogEntity> findById(GameTimeLogID id) {
    final Query query = GameTimeLogQuery.selectById(id);
    return readItem(
      query: query,
    );
  }

  @override
  Future<List<GameTimeLogEntity>> findAll() {
    final Query query = GameTimeLogQuery.selectAll();
    return readItemList(
      query: query,
    );
  }

  Future<List<GameTimeLogEntity>> findAllFromGame(GameID id) {
    final Query query = GameTimeLogQuery.selectAllByGame(id);
    return readItemList(
      query: query,
    );
  }

  Future<List<GameWithLogsEntity>> findAllWithGameByYear(int year) {
    final Query query = GameTimeLogQuery.selectAllWithGameByYear(year);
    return itemConnector
        .execute(query)
        .asStream()
        .map(_listMapToListGamesWithLogs)
        .first;
  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<GameTimeLogEntity> update(
    GameTimeLogEntity entity,
    GameTimeLogEntity updatedEntity,
  ) {
    final GameTimeLogID id = entity.createId();
    final Query query = GameTimeLogQuery.updateById(id, entity, updatedEntity);
    return updateItem(
      query: query,
      id: id,
    );
  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<Object?> deleteById(GameTimeLogID id) {
    final Query query = GameTimeLogQuery.deleteById(id);
    return itemConnector.execute(query);
  }
  //#endregion DELETE

  List<GameWithLogsEntity> _listMapToListGamesWithLogs(
    List<Map<String, Map<String, Object?>>> results,
  ) {
    final List<GameWithLogsEntity> entities = <GameWithLogsEntity>[];

    for (final Map<String, Map<String, Object?>> manyMap in results) {
      final Map<String, Object?> gameMap = manyMap[GameEntityData.table]!;
      final GameEntity gameEntity = GameEntity.fromMap(gameMap);

      final Map<String, Object?> timeLogMap =
          RepositoryUtils.combineMaps(manyMap, GameTimeLogEntityData.table);
      final GameTimeLogEntity timeLogEntity =
          GameTimeLogEntity.fromMap(timeLogMap);

      GameWithLogsEntity entity;
      try {
        entity = entities.singleWhere(
          (GameWithLogsEntity tempGameWithLogs) =>
              tempGameWithLogs.game == gameEntity,
        );
      } catch (iterableElementError) {
        entity = GameWithLogsEntity(game: gameEntity);
        entities.add(entity);
      }

      entity.addTimeLog(timeLogEntity);
    }

    return entities;
  }
}
