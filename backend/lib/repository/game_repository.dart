import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart' show DLCID, GameEntity, GameEntityData, GameID, GameTagID, PlatformID, PurchaseID, GameView;

import './query/query.dart' show GameQuery, DLCQuery, GamePlatformRelationQuery, GamePurchaseRelationQuery, GameTagRelationQuery;
import 'item_repository.dart';


class GameRepository extends ItemRepository<GameEntity, GameID> {
  const GameRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector, recordName: GameEntityData.table);

  static const String _imagePrefix = 'header';

  @override
  GameEntity entityFromMap(Map<String, Object?> map) => GameEntity.fromMap(map);
  @override
  GameID idFromMap(Map<String, Object?> map) => GameEntity.idFromMap(map);

  //#region CREATE
  @override
  Future<GameEntity> create(GameEntity entity) {

    final Query query = GameQuery.create(entity);
    return createItem(
      query: query,
    );

  }

  Future<Object?> relateGamePlatform(GameID gameId, PlatformID platformId) {

    final Query query = GamePlatformRelationQuery.create(gameId, platformId);
    return itemConnector.execute(query);

  }

  Future<Object?> relateGamePurchase(GameID gameId, PurchaseID purchaseId) {

    final Query query = GamePurchaseRelationQuery.create(gameId, purchaseId);
    return itemConnector.execute(query);

  }

  Future<Object?> relateGameDLC(GameID gameId, DLCID dlcId) {

    final Query query = DLCQuery.updateBaseGameById(dlcId, gameId);
    return itemConnector.execute(query);

  }
  Future<Object?> relateGameTag(GameID gameId, GameTagID tagId) {

    final Query query = GameTagRelationQuery.create(gameId, tagId);
    return itemConnector.execute(query);

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<GameEntity> findById(GameID id) {

    final Query query = GameQuery.selectById(id);
    return readItem(
      query: query,
    );

  }

  @override
  Future<List<GameEntity>> findAll() {

    final Query query = GameQuery.selectAll();
    return readItemList(
      query: query,
    );

  }

  Future<List<GameEntity>> findAllOwned() {

    return findAllOwnedWithView(GameView.main);

  }

  Future<List<GameEntity>> findAllRom() {

    return findAllRomWithView(GameView.main);

  }

  Future<List<GameEntity>> findAllWithView(GameView gameView, [int? limit]) {

    final Query query = GameQuery.selectAllInView(gameView, limit);
    return readItemList(
      query: query,
    );

  }

  Future<List<GameEntity>> findAllWithYearView(GameView gameView, int year, [int? limit]) {

    final Query query = GameQuery.selectAllInView(gameView, limit, year);
    return readItemList(
      query: query,
    );

  }

  Future<List<GameEntity>> findAllOwnedWithView(GameView gameView, [int? limit]) {

    final Query query = GameQuery.selectAllOwnedInView(gameView, limit, null);
    return readItemList(
      query: query,
    );

  }

  Future<List<GameEntity>> findAllOwnedWithYearView(GameView gameView, int year, [int? limit]) {

    final Query query = GameQuery.selectAllOwnedInView(gameView, limit, year);
    return readItemList(
      query: query,
    );

  }

  Future<List<GameEntity>> findAllRomWithView(GameView gameView, [int? limit]) {

    final Query query = GameQuery.selectAllRomInView(gameView, limit, null);
    return readItemList(
      query: query,
    );

  }

  Future<List<GameEntity>> findAllRomWithYearView(GameView gameView, int year, [int? limit]) {

    final Query query = GameQuery.selectAllRomInView(gameView, limit, year);
    return readItemList(
      query: query,
    );

  }

  Future<GameEntity?> findOneFromDLC(DLCID dlcId) {

    final Query query = DLCQuery.selectGameByDLC(dlcId);
    return readItemNullable(
      query: query,
    );

  }

  Future<List<GameEntity>> findAllFromPlatform(PlatformID id) {

    final Query query = GamePlatformRelationQuery.selectAllGamesByPlatformId(id);
    return readItemList(
      query: query,
    );

  }

  Future<List<GameEntity>> findAllFromPurchase(PurchaseID id) {

    final Query query = GamePurchaseRelationQuery.selectAllGamesByPurchaseId(id);
    return readItemList(
      query: query,
    );

  }

  Future<List<GameEntity>> findAllFromGameTag(GameTagID id) {

    final Query query = GameTagRelationQuery.selectAllGamesByTagId(id);
    return readItemList(
      query: query,
    );

  }
  //#endregion CREATE

  //#region UPDATE
  @override
  Future<GameEntity> update(GameEntity entity, GameEntity updatedEntity) {

    final GameID id = entity.createId();
    final Query query = GameQuery.updateById(id, entity, updatedEntity);
    return updateItem(
      query: query,
      id: id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<Object?> deleteById(GameID id) {

    final Query query = GameQuery.deleteById(id);
    return itemConnector.execute(query);

  }

  Future<Object?> unrelateGamePlatform(GameID gameId, PlatformID platformId) {

    final Query query = GamePlatformRelationQuery.deleteById(gameId, platformId);
    return itemConnector.execute(query);

  }

  Future<Object?> unrelateGamePurchase(GameID gameId, PurchaseID purchaseId) {

    final Query query = GamePurchaseRelationQuery.deleteById(gameId, purchaseId);
    return itemConnector.execute(query);

  }

  Future<Object?> unrelateGameDLC(DLCID dlcId) {

    final Query query = DLCQuery.updateBaseGameById(dlcId, null);
    return itemConnector.execute(query);

  }

  Future<Object?> unrelateGameTag(GameID gameId, GameTagID tagId) {

    final Query query = GameTagRelationQuery.deleteById(gameId, tagId);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Future<List<GameEntity>> findAllByName(String name, int limit) {

    final Query query = GameQuery.selectAllByNameLike(name, limit);
    return readItemList(
      query: query,
    );

  }
  //#endregion SEARCH

  //#region IMAGE
  Future<GameEntity> uploadCover(GameID id, String uploadImagePath, [String? oldImageName]) async {

    return setItemImage(
      uploadImagePath: uploadImagePath,
      initialImageName: _imagePrefix,
      oldImageName: oldImageName,
      queryBuilder: GameQuery.updateCoverById,
      id: id,
    );

  }

  Future<GameEntity> renameCover(GameID id, String imageName, String newImageName) {

    return renameItemImage(
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: GameQuery.updateCoverById,
      id: id,
    );

  }

  Future<GameEntity> deleteCover(GameID id, String imageName) {

    return deleteItemImage(
      imageName: imageName,
      queryBuilder: GameQuery.updateCoverById,
      id: id,
    );

  }
  //#endregion IMAGE
}