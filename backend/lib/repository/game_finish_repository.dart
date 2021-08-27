import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart' show GameFinishEntity, GameFinishID, GameID, GameFinishEntityData;

import './query/query.dart' show GameFinishQuery;
import 'item_repository.dart';


class GameFinishRepository extends ItemRepository<GameFinishEntity, GameFinishID> {
  const GameFinishRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector, recordName: GameFinishEntityData.table);

  @override
  GameFinishEntity entityFromMap(Map<String, Object?> map) => GameFinishEntity.fromMap(map);
  @override
  GameFinishID idFromMap(Map<String, Object?> map) => GameFinishEntity.idFromMap(map);

  //#region CREATE
  @override
  Future<GameFinishEntity> create(GameFinishEntity entity) {

    final Query query = GameFinishQuery.create(entity);
    return createItem(
      query: query,
    );

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<GameFinishEntity> findById(GameFinishID id) {

    final Query query = GameFinishQuery.selectById(id);
    return readItem(
      query: query,
    );

  }

  @override
  Future<List<GameFinishEntity>> findAll() {

    final Query query = GameFinishQuery.selectAll();
    return readItemList(
      query: query,
    );

  }

  Future<List<GameFinishEntity>> findAllFromGame(GameID id) {

    final Query query = GameFinishQuery.selectAllByGame(id);
    return readItemList(
      query: query,
    );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<GameFinishEntity> update(GameFinishEntity entity, GameFinishEntity updatedEntity) {

    final GameFinishID id = entity.createId();
    final Query query = GameFinishQuery.updateById(id, entity, updatedEntity);
    return updateItem(
      query: query,
      id: id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<Object?> deleteById(GameFinishID id) {

    final Query query = GameFinishQuery.deleteById(id);
    return itemConnector.execute(query);

  }
  //#endregion DELETE
}