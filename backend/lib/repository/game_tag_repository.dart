import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart'
    show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart'
    show GameID, GameTagEntity, GameTagEntityData, GameTagID, GameTagView;

import './query/query.dart' show GameTagQuery, GameTagRelationQuery;
import 'item_repository.dart';

class GameTagRepository extends ItemRepository<GameTagEntity, GameTagID> {
  const GameTagRepository(
    ItemConnector itemConnector,
    ImageConnector? imageConnector,
  ) : super(
          itemConnector,
          imageConnector,
          recordName: GameTagEntityData.table,
        );

  @override
  GameTagEntity entityFromMap(Map<String, Object?> map) =>
      GameTagEntity.fromMap(map);
  @override
  GameTagID idFromMap(Map<String, Object?> map) => GameTagEntity.idFromMap(map);

  //#region CREATE
  @override
  Future<GameTagEntity> create(GameTagEntity entity) {
    final Query query = GameTagQuery.create(entity);
    return createItem(
      query: query,
    );
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<GameTagEntity> findById(GameTagID id) {
    final Query query = GameTagQuery.selectById(id);
    return readItem(
      query: query,
    );
  }

  @override
  Future<List<GameTagEntity>> findAll([int? page]) {
    final Query query = GameTagQuery.selectAll(page);
    return readItemList(
      query: query,
    );
  }

  Future<List<GameTagEntity>> findAllWithView(
    GameTagView tagView, [
    int? page,
  ]) {
    final Query query = GameTagQuery.selectAllInView(tagView, page);
    return readItemList(
      query: query,
    );
  }

  Future<List<GameTagEntity>> findFirstWithView(
    GameTagView tagView,
    int limit,
  ) {
    final Query query = GameTagQuery.selectFirstInView(tagView, limit);
    return readItemList(
      query: query,
    );
  }

  Future<List<GameTagEntity>> findAllFromGame(GameID id) {
    final Query query = GameTagRelationQuery.selectAllTagsByGameId(id);
    return readItemList(
      query: query,
    );
  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<GameTagEntity> update(
    GameTagEntity entity,
    GameTagEntity updatedEntity,
  ) {
    final GameTagID id = entity.createId();
    final Query query = GameTagQuery.updateById(id, entity, updatedEntity);
    return updateItem(
      query: query,
      id: id,
    );
  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<Object?> deleteById(GameTagID id) {
    final Query query = GameTagQuery.deleteById(id);
    return itemConnector.execute(query);
  }
  //#endregion DELETE

  //#region SEARCH
  Future<List<GameTagEntity>> findFirstByName(String name, int limit) {
    final Query query = GameTagQuery.selectFirstByNameLike(name, limit);
    return readItemList(
      query: query,
    );
  }

  Future<List<GameTagEntity>> findFirstWithViewByName(
    GameTagView view,
    String name,
    int limit,
  ) {
    final Query query =
        GameTagQuery.selectFirstInViewByNameLike(view, name, limit);
    return readItemList(
      query: query,
    );
  }
  //#region SEARCH
}
