import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/entity/entity.dart' show GameEntity, GameEntityData;
import 'package:backend/model/model.dart' show Game, GameID, GameView;

import './query/query.dart' show GameQuery, DLCQuery, GamePlatformRelationQuery, GamePurchaseRelationQuery, GameTagRelationQuery;
import 'item_repository.dart';


class GameRepository extends ItemRepository<Game, GameID> {
  const GameRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  static const String _imagePrefix = 'header';

  //#region CREATE
  @override
  Future<Game?> create(Game item) async {

    final GameEntity entity = GameMapper.modelToEntity(item);
    final Query query = GameQuery.create(entity);

    return createCollectionItem(
      query: query,
      dynamicToId: GameEntity.idFromDynamicMap,
    );

  }

  Future<dynamic> relateGamePlatform(int gameId, int platformId) {

    final Query query = GamePlatformRelationQuery.create(gameId, platformId);
    return itemConnector.execute(query);

  }

  Future<dynamic> relateGamePurchase(int gameId, int purchaseId) {

    final Query query = GamePurchaseRelationQuery.create(gameId, purchaseId);
    return itemConnector.execute(query);

  }

  Future<dynamic> relateGameDLC(int gameId, int dlcId) {

    final Query query = DLCQuery.updateBaseGameById(dlcId, gameId);
    return itemConnector.execute(query);

  }
  Future<dynamic> relateGameTag(int gameId, int tagId) {

    final Query query = GameTagRelationQuery.create(gameId, tagId);
    return itemConnector.execute(query);

  }
  //#endregion CREATE

  //#region READ
  @override
  Stream<Game?> findById(int id) {

    final Query query = GameQuery.selectById(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToSingle );

  }

  @override
  Stream<List<Game>> findAll() {

    return findAllGamesWithView(GameView.Main);

  }

  Stream<List<Game>> findAllOwnedGames() {

    return findAllOwnedGamesWithView(GameView.Main);

  }

  Stream<List<Game>> findAllRomGames() {

    return findAllRomGamesWithView(GameView.Main);

  }

  Stream<List<Game>> findAllGamesWithView(GameView gameView, [int? limit]) {

    final Query query = GameQuery.selectAllInView(gameView, limit);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Game>> findAllGamesWithYearView(GameView gameView, int year, [int? limit]) {

    final Query query = GameQuery.selectAllInView(gameView, limit, year);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Game>> findAllOwnedGamesWithView(GameView gameView, [int? limit]) {

    final Query query = GameQuery.selectAllInViewAndOwned(gameView, limit, null);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Game>> findAllOwnedGamesWithYearView(GameView gameView, int year, [int? limit]) {

    final Query query = GameQuery.selectAllInViewAndOwned(gameView, limit, year);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Game>> findAllRomGamesWithView(GameView gameView, [int? limit]) {

    final Query query = GameQuery.selectAllInViewAndRom(gameView, limit, null);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Game>> findAllRomGamesWithYearView(GameView gameView, int year, [int? limit]) {

    final Query query = GameQuery.selectAllInViewAndRom(gameView, limit, year);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<Game?> findBaseGameFromDLC(int dlcId) {

    final Query query = DLCQuery.selectGameByDLC(dlcId);
    return itemConnector.execute(query)
      .asStream().map( dynamicToSingle );

  }

  Stream<List<Game>> findAllGamesFromPlatform(int id) {

    final Query query = GamePlatformRelationQuery.selectAllGamesByPlatformId(id);

    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Game>> findAllGamesFromPurchase(int id) {

    final Query query = GamePurchaseRelationQuery.selectAllGamesByPurchaseId(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Game>> findAllGamesFromGameTag(int id) {

    final Query query = GameTagRelationQuery.selectAllGamesByTagId(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion CREATE

  //#region UPDATE
  @override
  Future<Game?> update(Game item, Game updatedItem) {

    final GameEntity entity = GameMapper.modelToEntity(item);
    final GameEntity updatedEntity = GameMapper.modelToEntity(updatedItem);
    final Query query = GameQuery.updateById(item.id, entity, updatedEntity);

    return updateCollectionItem(
      query: query,
      id: item.id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteById(int id) {

    final Query query = GameQuery.deleteById(id);
    return itemConnector.execute(query);

  }

  Future<dynamic> unrelateGamePlatform(int gameId, int platformId) {

    final Query query = GamePlatformRelationQuery.deleteById(gameId, platformId);
    return itemConnector.execute(query);

  }

  Future<dynamic> unrelateGamePurchase(int gameId, int purchaseId) {

    final Query query = GamePurchaseRelationQuery.deleteById(gameId, purchaseId);
    return itemConnector.execute(query);

  }

  Future<dynamic> unrelateGameDLC(int dlcId) {

    final Query query = DLCQuery.updateBaseGameById(dlcId, null);
    return itemConnector.execute(query);

  }

  Future<dynamic> unrelateGameTag(int gameId, int tagId) {

    final Query query = GameTagRelationQuery.deleteById(gameId, tagId);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Stream<List<Game>> findAllGamesByName(String name, int limit) {

    final Query query = GameQuery.selectAllByNameLike(name, limit);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion SEARCH

  //#region IMAGE
  Future<Game?> uploadGameCover(int id, String uploadImagePath, [String? oldImageName]) async {

    return uploadCollectionItemImage(
      tableName: GameEntityData.table,
      uploadImagePath: uploadImagePath,
      initialImageName: _imagePrefix,
      oldImageName: oldImageName,
      queryBuilder: GameQuery.updateCoverById,
      id: id,
    );

  }

  Future<Game?> renameGameCover(int id, String imageName, String newImageName) {

    return renameCollectionItemImage(
      tableName: GameEntityData.table,
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: GameQuery.updateCoverById,
      id: id,
    );

  }

  Future<Game?> deleteGameCover(int id, String imageName) {

    return deleteCollectionItemImage(
      tableName: GameEntityData.table,
      imageName: imageName,
      queryBuilder: GameQuery.updateCoverById,
      id: id,
    );

  }
  //#endregion IMAGE

  //#region DOWNLOAD
  String? _getGameCoverURL(String? gameCoverName) {

    return gameCoverName != null?
        imageConnector.getURI(
          tableName: GameEntityData.table,
          imageFilename: gameCoverName,
        )
        : null;

  }
  //#endregion DOWNLOAD

  @override
  List<Game> dynamicToList(List<Map<String, Map<String, dynamic>>> results) {

    return GameEntity.fromDynamicMapList(results).map( (GameEntity gameEntity) {
      return GameMapper.entityToModel(gameEntity, _getGameCoverURL(gameEntity.coverFilename));
    }).toList(growable: false);

  }
}