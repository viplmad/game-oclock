import 'package:query/query.dart';

import 'package:backend/connector/connector.dart';
import 'package:backend/entity/entity.dart';
import 'repository.dart';
import 'package:backend/mapper/mapper.dart';
import 'package:backend/model/model.dart';

import 'collection_repository.dart';


class RemoteRepository implements CollectionRepository {
  RemoteRepository._(ItemConnector itemConnector, ImageConnector imageConnector) {
    _itemConnector = itemConnector;
    _imageConnector = imageConnector;
  }

  late ItemConnector _itemConnector;
  late ImageConnector _imageConnector;

  factory RemoteRepository(ItemConnector itemConnector, ImageConnector imageConnector) {
    return RemoteRepository._(
      itemConnector,
      imageConnector,
    );
  }

  @override
  Future<dynamic> open() {

    return _itemConnector.open();

  }

  @override
  Future<dynamic> close() {

    return _itemConnector.close();

  }

  @override
  bool isOpen() {

    return _itemConnector.isOpen();

  }

  @override
  bool isClosed() {

    return _itemConnector.isClosed();

  }

  @override
  void reconnect() {

    _itemConnector.reconnect();

  }

  //#region CREATE
  //#region Game
  @override
  Future<Game?> createGame(Game game) async {

    final GameEntity entity = GameMapper.modelToEntity(game);
    final Query query = GameRepository.create(entity);

    return _createCollectionItem<Game>(
      query: query,
      dynamicToId: GameEntity.idFromDynamicMap,
      findItemById: findGameById,
    );

  }

  @override
  Future<dynamic> relateGamePlatform(int gameId, int platformId) {

    final Query query = GamePlatformRelationRepository.create(gameId, platformId);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> relateGamePurchase(int gameId, int purchaseId) {

    final Query query = GamePurchaseRelationRepository.create(gameId, purchaseId);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> relateGameDLC(int gameId, int dlcId) {

    final Query query = DLCRepository.updateBaseGameById(dlcId, gameId);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> relateGameTag(int gameId, int tagId) {

    final Query query = GameTagRelationRepository.create(gameId, tagId);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> createGameFinish(int gameId, GameFinish finish) {

    final GameFinishEntity entity = GameMapper.finishModelToEntity(finish);
    final Query query = GameFinishRepository.create(entity, gameId);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> createGameTimeLog(int gameId, GameTimeLog timeLog) {

    final GameTimeLogEntity entity = GameMapper.logModelToEntity(timeLog);
    final Query query = GameTimeLogRepository.create(entity, gameId);

    return _itemConnector.execute(query);

  }
  //#endregion Game

  //#region DLC
  @override
  Future<DLC?> createDLC(DLC dlc) {

    final DLCEntity entity = DLCMapper.modelToEntity(dlc);
    final Query query = DLCRepository.create(entity);

    return _createCollectionItem<DLC>(
      query: query,
      dynamicToId: DLCEntity.idFromDynamicMap,
      findItemById: findDLCById,
    );

  }

  @override
  Future<dynamic> relateDLCPurchase(int dlcId, int purchaseId) {

    final Query query = DLCPurchaseRelationRepository.create(dlcId, purchaseId);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> createDLCFinish(int dlcId, DLCFinish finish) {

    final DLCFinishEntity entity = DLCMapper.finishModelToEntity(finish);
    final Query query = DLCFinishRepository.create(entity, dlcId);

    return _itemConnector.execute(query);

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<Platform?> createPlatform(Platform platform) {

    final PlatformEntity entity = PlatformMapper.modelToEntity(platform);
    final Query query = PlatformRepository.create(entity);

    return _createCollectionItem<Platform>(
      query: query,
      dynamicToId: PlatformEntity.idFromDynamicMap,
      findItemById: findPlatformById,
    );

  }

  @override
  Future<dynamic> relatePlatformSystem(int platformId, int systemId) {

    final Query query = PlatformSystemRelationRepository.create(platformId, systemId);

    return _itemConnector.execute(query);

  }
  //#endregion Platform

  //#region Purchase
  @override
  Future<Purchase?> createPurchase(Purchase purchase) {

    final PurchaseEntity entity = PurchaseMapper.modelToEntity(purchase);
    final Query query = PurchaseRepository.create(entity);

    return _createCollectionItem<Purchase>(
      query: query,
      dynamicToId: PurchaseEntity.idFromDynamicMap,
      findItemById: findPurchaseById,
    );

  }

  @override
  Future<dynamic> relatePurchaseType(int purchaseId, int typeId) {

    final Query query = PurchaseTypeRelationRepository.create(purchaseId, typeId);

    return _itemConnector.execute(query);

  }
  //#endregion Purchase

  //#region Store
  @override
  Future<Store?> createStore(Store store) {

    final StoreEntity entity = StoreMapper.modelToEntity(store);
    final Query query = StoreRepository.create(entity);

    return _createCollectionItem<Store>(
      query: query,
      dynamicToId: StoreEntity.idFromDynamicMap,
      findItemById: findStoreById,
    );

  }

  @override
  Future<dynamic> relateStorePurchase(int storeId, int purchaseId) {

    final Query query = PurchaseRepository.updateStoreById(purchaseId, storeId);

    return _itemConnector.execute(query);

  }
  //#endregion Store

  //#region System
  @override
  Future<System?> createSystem(System system) {

    final SystemEntity entity = SystemMapper.modelToEntity(system);
    final Query query = SystemRepository.create(entity);

    return _createCollectionItem<System>(
      query: query,
      dynamicToId: SystemEntity.idFromDynamicMap,
      findItemById: findSystemById,
    );

  }
  //#endregion System

  //#region Tag
  @override
  Future<Tag?> createGameTag(Tag tag) {

    final GameTagEntity entity = GameTagMapper.modelToEntity(tag);
    final Query query = GameTagRepository.create(entity);

    return _createCollectionItem<Tag>(
      query: query,
      dynamicToId: GameTagEntity.idFromDynamicMap,
      findItemById: findGameTagById,
    );

  }
  //#endregion Tag

  //#region Type
  @override
  Future<PurchaseType?> createPurchaseType(PurchaseType type) {

    final PurchaseTypeEntity entity = PurchaseTypeMapper.modelToEntity(type);
    final Query query = PurchaseTypeRepository.create(entity);

    return _createCollectionItem<PurchaseType>(
      query: query,
      dynamicToId: PurchaseTypeEntity.idFromDynamicMap,
      findItemById: findPurchaseTypeById,
    );

  }
  //#endregion Type
  //#endregion CREATE


  //#region READ
  //#region Game
  @override
  Stream<List<Game>> findAllGames() {

    return findAllGamesWithView(GameView.Main);

  }

  @override
  Stream<List<Game>> findAllOwnedGames() {

    return findAllOwnedGamesWithView(GameView.Main);

  }
  @override
  Stream<List<Game>> findAllRomGames() {

    return findAllRomGamesWithView(GameView.Main);

  }

  @override
  Stream<List<Game>> findAllGamesWithView(GameView gameView, [int? limit]) {

    final Query query = GameRepository.selectAllInView(gameView, limit);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllGamesWithYearView(GameView gameView, int year, [int? limit]) {

    final Query query = GameRepository.selectAllInView(gameView, limit, year);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllOwnedGamesWithView(GameView gameView, [int? limit]) {

    final Query query = GameRepository.selectAllInViewAndOwned(gameView, limit, null);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllOwnedGamesWithYearView(GameView gameView, int year, [int? limit]) {

    final Query query = GameRepository.selectAllInViewAndOwned(gameView, limit, year);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllRomGamesWithView(GameView gameView, [int? limit]) {

    final Query query = GameRepository.selectAllInViewAndRom(gameView, limit, null);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllRomGamesWithYearView(GameView gameView, int year, [int? limit]) {

    final Query query = GameRepository.selectAllInViewAndRom(gameView, limit, year);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGame );

  }

  @override
  Stream<Game?> findGameById(int id) {

    final Query query = GameRepository.selectById(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<Platform>> findAllPlatformsFromGame(int id) {

    final Query query = GamePlatformRelationRepository.selectAllPlatformsByGameId(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesFromGame(int id) {

    final Query query = GamePurchaseRelationRepository.selectAllPurchasesByGameId(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<DLC>> findAllDLCsFromGame(int id) {

    final Query query = DLCRepository.selectAllByBaseGame(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<Tag>> findAllGameTagsFromGame(int id) {

    final Query query = GameTagRelationRepository.selectAllTagsByGameId(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGameTag );

  }

  @override
  Stream<List<GameFinish>> findAllGameFinishFromGame(int id) {

    final Query query = GameFinishRepository.selectAllByGame(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGameFinish );

  }

  @override
  Stream<List<GameTimeLog>> findAllGameTimeLogsFromGame(int id) {

    final Query query = GameTimeLogRepository.selectAllByGame(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListTimeLog );

  }
  //#endregion Game

  //#region DLC
  @override
  Stream<List<DLC>> findAllDLCs() {

    return findAllDLCsWithView(DLCView.Main);

  }

  @override
  Stream<List<DLC>> findAllDLCsWithView(DLCView dlcView, [int? limit]) {

    final Query query = DLCRepository.selectAllInView(dlcView, limit);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<DLC?> findDLCById(int id) {

    final Query query = DLCRepository.selectById(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToSingleDLC );

  }

  @override
  Stream<Game?> findBaseGameFromDLC(int dlcId) {

    final Query query = DLCRepository.selectGameByDLC(dlcId);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesFromDLC(int id) {

    final Query query = DLCPurchaseRelationRepository.selectAllPurchasesByDLCId(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<DLCFinish>> findAllDLCFinishFromDLC(int id) {

    final Query query = DLCFinishRepository.selectAllByDLC(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListDLCFinish );

  }
  //#endregion DLC

  //#region Platform
  @override
  Stream<List<Platform>> findAllPlatforms() {

    return findAllPlatformsWithView(PlatformView.Main);

  }

  @override
  Stream<List<Platform>> findAllPlatformsWithView(PlatformView platformView, [int? limit]) {

    final Query query = PlatformRepository.selectAllInView(platformView, limit);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<Platform?> findPlatformById(int id) {

    final Query query = PlatformRepository.selectById(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToSinglePlatform );

  }

  @override
  Stream<List<Game>> findAllGamesFromPlatform(int id) {

    final Query query = GamePlatformRelationRepository.selectAllGamesByPlatformId(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<System>> findAllSystemsFromPlatform(int id) {

    final Query query = PlatformSystemRelationRepository.selectAllSystemsByPlatformId(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListSystem );

  }
  //#endregion Platform

  //#region Purchase
  @override
  Stream<List<Purchase>> findAllPurchases() {

    return findAllPurchasesWithView(PurchaseView.Main);

  }

  @override
  Stream<List<Purchase>> findAllPurchasesWithView(PurchaseView purchaseView, [int? limit]) {

    final Query query = PurchaseRepository.selectAllInView(purchaseView, limit);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesWithYearView(PurchaseView purchaseView, int year, [int? limit]) {

    final Query query = PurchaseRepository.selectAllInView(purchaseView, limit, year);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<Purchase?> findPurchaseById(int id) {

    final Query query = PurchaseRepository.selectById(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToSinglePurchase );

  }

  @override
  Stream<Store?> findStoreFromPurchase(int id) {

    final Query query = PurchaseRepository.selectStoreByPurchase(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToSingleStore );

  }

  @override
  Stream<List<Game>> findAllGamesFromPurchase(int id) {

    final Query query = GamePurchaseRelationRepository.selectAllGamesByPurchaseId(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<DLC>> findAllDLCsFromPurchase(int id) {

    final Query query = DLCPurchaseRelationRepository.selectAllDLCsByPurchaseId(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<PurchaseType>> findAllPurchaseTypesFromPurchase(int id) {

    final Query query = PurchaseTypeRelationRepository.selectAllTypesByPurchaseId(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPurchaseType );

  }
  //#endregion Purchase

  //#region Store
  @override
  Stream<List<Store>> findAllStores() {

    return findAllStoresWithView(StoreView.Main);

  }

  @override
  Stream<List<Store>> findAllStoresWithView(StoreView storeView, [int? limit]) {

    final Query query = StoreRepository.selectAllInView(storeView, limit);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListStore );

  }

  @override
  Stream<Store?> findStoreById(int id) {

    final Query query = StoreRepository.selectById(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToSingleStore );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesFromStore(int storeId) {

    final Query query = PurchaseRepository.selectAllByStore(storeId);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPurchase );

  }
  //#endregion Store

  //#region System
  @override
  Stream<List<System>> findAllSystems() {

    return findAllSystemsWithView(SystemView.Main);

  }

  @override
  Stream<List<System>> findAllSystemsWithView(SystemView systemView, [int? limit]) {

    final Query query = SystemRepository.selectAllInView(systemView, limit);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListSystem );
  }

  @override
  Stream<System?> findSystemById(int id) {

    final Query query = SystemRepository.selectById(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToSingleSystem );

  }

  @override
  Stream<List<Platform>> findAllPlatformsFromSystem(int id) {

    final Query query = PlatformSystemRelationRepository.selectAllPlatformsBySystemId(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPlatform );

  }
  //#endregion System

  //#region GameTag
  @override
  Stream<List<Tag>> findAllGameTags() {

    return findAllGameTagsWithView(TagView.Main);

  }

  @override
  Stream<List<Tag>> findAllGameTagsWithView(TagView tagView, [int? limit]) {

    final Query query = GameTagRepository.selectAllInView(tagView, limit);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGameTag );

  }

  @override
  Stream<Tag?> findGameTagById(int id) {

    final Query query = GameTagRepository.selectById(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToSingleGameTag );

  }

  @override
  Stream<List<Game>> findAllGamesFromGameTag(int id) {

    final Query query = GameTagRelationRepository.selectAllGamesByTagId(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGame );

  }
  //#endregion GameTag

  //#region PurchaseType
  @override
  Stream<List<PurchaseType>> findAllPurchaseTypes() {

    return findAllPurchaseTypesWithView(TypeView.Main);

  }

  @override
  Stream<List<PurchaseType>> findAllPurchaseTypesWithView(TypeView typeView, [int? limit]) {

    final Query query = PurchaseTypeRepository.selectAllInView(typeView, limit);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPurchaseType );

  }

  @override
  Stream<PurchaseType?> findPurchaseTypeById(int id) {

    final Query query = PurchaseTypeRepository.selectById(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToSinglePurchaseType );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesFromPurchaseType(int id) {

    final Query query = PurchaseTypeRelationRepository.selectAllPurchasesByTypeId(id);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPurchase );

  }
  //#endregion PurchaseType
  //#endregion READ


  //#region UPDATE
    //Game
  @override
  Future<Game?> updateGame<T>(Game game, Game updatedGame, GameUpdateProperties updateProperties) {

    final GameEntity entity = GameMapper.modelToEntity(game);
    final GameEntity updatedEntity = GameMapper.modelToEntity(updatedGame);
    final Query query = GameRepository.updateById(game.id, entity, updatedEntity, updateProperties);

    return _updateCollectionItem<Game>(
      query: query,
      id: game.id,
      findItemById: findGameById,
    );

  }

    //DLC
  @override
  Future<DLC?> updateDLC(DLC dlc, DLC updatedDlc, DLCUpdateProperties updateProperties) {

    final DLCEntity entity = DLCMapper.modelToEntity(dlc);
    final DLCEntity updatedEntity = DLCMapper.modelToEntity(updatedDlc);
    final Query query = DLCRepository.updateById(dlc.id, entity, updatedEntity, updateProperties);

    return _updateCollectionItem<DLC>(
      query: query,
      id: dlc.id,
      findItemById: findDLCById,
    );

  }

    //Platform
  @override
  Future<Platform?> updatePlatform(Platform platform, Platform updatedPlatform, PlatformUpdateProperties updateProperties) {

    final PlatformEntity entity = PlatformMapper.modelToEntity(platform);
    final PlatformEntity updatedEntity = PlatformMapper.modelToEntity(updatedPlatform);
    final Query query = PlatformRepository.updateById(platform.id, entity, updatedEntity, updateProperties);

    return _updateCollectionItem<Platform>(
      query: query,
      id: platform.id,
      findItemById: findPlatformById,
    );

  }

    //Purchase
  @override
  Future<Purchase?> updatePurchase(Purchase purchase, Purchase updatedPurchase, PurchaseUpdateProperties updateProperties) {

    final PurchaseEntity entity = PurchaseMapper.modelToEntity(purchase);
    final PurchaseEntity updatedEntity = PurchaseMapper.modelToEntity(updatedPurchase);
    final Query query = PurchaseRepository.updateById(purchase.id, entity, updatedEntity, updateProperties);

    return _updateCollectionItem<Purchase>(
      query: query,
      id: purchase.id,
      findItemById: findPurchaseById,
    );

  }

    //Store
  @override
  Future<Store?> updateStore(Store store, Store updatedStore, StoreUpdateProperties updateProperties) {

    final StoreEntity entity = StoreMapper.modelToEntity(store);
    final StoreEntity updatedEntity = StoreMapper.modelToEntity(updatedStore);
    final Query query = StoreRepository.updateById(store.id, entity, updatedEntity, updateProperties);

    return _updateCollectionItem<Store>(
      query: query,
      id: store.id,
      findItemById: findStoreById,
    );

  }

    //System
  @override
  Future<System?> updateSystem(System system, System updatedSystem, SystemUpdateProperties updateProperties) {

    final SystemEntity entity = SystemMapper.modelToEntity(system);
    final SystemEntity updatedEntity = SystemMapper.modelToEntity(updatedSystem);
    final Query query = SystemRepository.updateById(system.id, entity, updatedEntity, updateProperties);

    return _updateCollectionItem<System>(
      query: query,
      id: system.id,
      findItemById: findSystemById,
    );

  }

    //Tag
  @override
  Future<Tag?> updateGameTag(Tag tag, Tag updatedTag, GameTagUpdateProperties updateProperties) {

    final GameTagEntity entity = GameTagMapper.modelToEntity(tag);
    final GameTagEntity updatedEntity = GameTagMapper.modelToEntity(updatedTag);
    final Query query = GameTagRepository.updateById(tag.id, entity, updatedEntity, updateProperties);

    return _updateCollectionItem<Tag>(
      query: query,
      id: tag.id,
      findItemById: findGameTagById,
    );

  }

    //Type
  @override
  Future<PurchaseType?> updatePurchaseType(PurchaseType type, PurchaseType updatedType, PurchaseTypeUpdateProperties updateProperties) {

    final PurchaseTypeEntity entity = PurchaseTypeMapper.modelToEntity(type);
    final PurchaseTypeEntity updatedEntity = PurchaseTypeMapper.modelToEntity(updatedType);
    final Query query = PurchaseTypeRepository.updateById(type.id, entity, updatedEntity, updateProperties);

    return _updateCollectionItem<PurchaseType>(
      query: query,
      id: type.id,
      findItemById: findPurchaseTypeById,
    );

  }
  //#endregion UPDATE


  //#region DELETE
  //#region Game
  @override
  Future<dynamic> deleteGameById(int id) {

    final Query query = GameRepository.deleteById(id);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> unrelateGamePlatform(int gameId, int platformId) {

    final Query query = GamePlatformRelationRepository.deleteById(gameId, platformId);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> unrelateGamePurchase(int gameId, int purchaseId) {

    final Query query = GamePurchaseRelationRepository.deleteById(gameId, purchaseId);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> unrelateGameDLC(int dlcId) {

    final Query query = DLCRepository.updateBaseGameById(dlcId, null);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> unrelateGameTag(int gameId, int tagId) {

    final Query query = GameTagRelationRepository.deleteById(gameId, tagId);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> deleteGameFinishById(int gameId, DateTime date) {

    final Query query = GameFinishRepository.deleteById(gameId, date);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> deleteGameTimeLogById(int gameId, DateTime dateTime) {

    final Query query = GameTimeLogRepository.deleteById(gameId, dateTime);

    return _itemConnector.execute(query);

  }
  //#endregion Game

  //#region DLC
  @override
  Future<dynamic> deleteDLCById(int id) {

    final Query query = DLCRepository.deleteById(id);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> unrelateDLCPurchase(int dlcId, int purchaseId) {

    final Query query = DLCPurchaseRelationRepository.deleteById(dlcId, purchaseId);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> deleteDLCFinishById(int dlcId, DateTime date) {

    final Query query = DLCFinishRepository.deleteById(dlcId, date);

    return _itemConnector.execute(query);

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<dynamic> deletePlatformById(int id) {

    final Query query = PlatformRepository.deleteById(id);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> unrelatePlatformSystem(int platformId, int systemId) {

    final Query query = PlatformSystemRelationRepository.deleteById(platformId, systemId);

    return _itemConnector.execute(query);
  }
  //#endregion Platform

  //#region Purchase
  @override
  Future<dynamic> deletePurchaseById(int id) {

    final Query query = PurchaseRepository.deleteById(id);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> unrelatePurchaseType(int purchaseId, int typeId) {

    final Query query = PurchaseTypeRelationRepository.deleteById(purchaseId, typeId);

    return _itemConnector.execute(query);

  }
  //#endregion Purchase

  //#region Store
  @override
  Future<dynamic> deleteStoreById(int id) {

    final Query query = StoreRepository.deleteById(id);

    return _itemConnector.execute(query);

  }

  @override
  Future<dynamic> unrelateStorePurchase(int purchaseId) {

    final Query query = PurchaseRepository.updateStoreById(purchaseId, null);

    return _itemConnector.execute(query);

  }
  //#endregion Store

  //#region System
  @override
  Future<dynamic> deleteSystemById(int id) {

    final Query query = SystemRepository.deleteById(id);

    return _itemConnector.execute(query);

  }
  //#endregion System

  //#region Tag
  @override
  Future<dynamic> deleteGameTagById(int id) {

    final Query query = GameTagRepository.deleteById(id);

    return _itemConnector.execute(query);

  }
  //#endregion Tag

  //#region Type
  @override
  Future<dynamic> deletePurchaseTypeById(int id) {

    final Query query = PurchaseTypeRepository.deleteById(id);

    return _itemConnector.execute(query);

  }
  //#endregion Type
  //#endregion DELETE


  //#region SEARCH
  @override
  Stream<List<Game>> findAllGamesByName(String name, int maxResults) {

    final Query query = GameRepository.selectAllByNameLike(name, maxResults);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<DLC>> findAllDLCsByName(String name, int maxResults) {

    final Query query = DLCRepository.selectAllByNameLike(name, maxResults);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<Platform>> findAllPlatformsByName(String name, int maxResults) {

    final Query query = PlatformRepository.selectAllByNameLike(name, maxResults);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesByDescription(String description, int maxResults) {

    final Query query = PurchaseRepository.selectAllByDescriptionLike(description, maxResults);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<Store>> findAllStoresByName(String name, int maxResults) {

    final Query query = StoreRepository.selectAllByNameLike(name, maxResults);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListStore );

  }

  @override
  Stream<List<System>> findAllSystemsByName(String name, int maxResults) {

    final Query query = SystemRepository.selectAllByNameLike(name, maxResults);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListSystem );

  }

  @override
  Stream<List<Tag>> findAllGameTagsByName(String name, int maxResults) {

    final Query query = GameTagRepository.selectAllByNameLike(name, maxResults);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGameTag );

  }

  @override
  Stream<List<PurchaseType>> findAllPurchaseTypesByName(String name, int maxResults) {

    final Query query = PurchaseTypeRepository.selectAllByNameLike(name, maxResults);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListPurchaseType );
  }
  //#endregion SEARCH

  @override
  Stream<List<GameWithLogs>> findAllGamesWithTimeLogsByYear(int year) {

    final Query query = GameTimeLogRepository.selectAllWithGameByYear(year);

    return _itemConnector.execute(query)
      .asStream().map( _dynamicToListGamesWithLogs );

  }

  //#region IMAGE
  //#region Game
  @override
  Future<Game?> uploadGameCover(int id, String uploadImagePath, [String? oldImageName]) async {

    return _uploadCollectionItemImage<Game>(
      tableName: GameEntityData.table,
      uploadImagePath: uploadImagePath,
      initialImageName: 'header',
      oldImageName: oldImageName,
      queryBuilder: GameRepository.updateCoverById,
      id: id,
      findItemById: findGameById,
    );

  }

  @override
  Future<Game?> renameGameCover(int id, String imageName, String newImageName) {

    return _renameCollectionItemImage<Game>(
      tableName: GameEntityData.table,
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: GameRepository.updateCoverById,
      id: id,
      findItemById: findGameById,
    );

  }

  @override
  Future<Game?> deleteGameCover(int id, String imageName) {

    return _deleteCollectionItemImage<Game>(
      tableName: GameEntityData.table,
      imageName: imageName,
      queryBuilder: GameRepository.updateCoverById,
      id: id,
      findItemById: findGameById,
    );

  }
  //#endregion Game

  //#region DLC
  @override
  Future<DLC?> uploadDLCCover(int id, String uploadImagePath, [String? oldImageName]) {

    return _uploadCollectionItemImage<DLC>(
      tableName: DLCEntityData.table,
      uploadImagePath: uploadImagePath,
      initialImageName: 'header',
      oldImageName: oldImageName,
      queryBuilder: DLCRepository.updateCoverById,
      id: id,
      findItemById: findDLCById,
    );

  }

  @override
  Future<DLC?> renameDLCCover(int id, String imageName, String newImageName) {

    return _renameCollectionItemImage<DLC>(
      tableName: DLCEntityData.table,
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: DLCRepository.updateCoverById,
      id: id,
      findItemById: findDLCById,
    );

  }

  @override
  Future<DLC?> deleteDLCCover(int id, String imageName) {

    return _deleteCollectionItemImage<DLC>(
      tableName: DLCEntityData.table,
      imageName: imageName,
      queryBuilder: DLCRepository.updateCoverById,
      id: id,
      findItemById: findDLCById,
    );

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<Platform?> uploadPlatformIcon(int id, String uploadImagePath, [String? oldImageName]) {

    return _uploadCollectionItemImage<Platform>(
      tableName: PlatformEntityData.table,
      uploadImagePath: uploadImagePath,
      initialImageName: 'icon',
      oldImageName: oldImageName,
      queryBuilder: PlatformRepository.updateIconById,
      id: id,
      findItemById: findPlatformById,
    );

  }

  @override
  Future<Platform?> renamePlatformIcon(int id, String imageName, String newImageName) {

    return _renameCollectionItemImage<Platform>(
      tableName: PlatformEntityData.table,
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: PlatformRepository.updateIconById,
      id: id,
      findItemById: findPlatformById,
    );

  }


  @override
  Future<Platform?> deletePlatformIcon(int id, String imageName) {

    return _deleteCollectionItemImage<Platform>(
      tableName: PlatformEntityData.table,
      imageName: imageName,
      queryBuilder: PlatformRepository.updateIconById,
      id: id,
      findItemById: findPlatformById,
    );

  }
  //#endregion Platform

  //#region Store
  @override
  Future<Store?> uploadStoreIcon(int id, String uploadImagePath, [String? oldImageName]) {

    return _uploadCollectionItemImage<Store>(
      tableName: StoreEntityData.table,
      uploadImagePath: uploadImagePath,
      initialImageName: 'icon',
      oldImageName: oldImageName,
      queryBuilder: StoreRepository.updateIconById,
      id: id,
      findItemById: findStoreById,
    );

  }

  @override
  Future<Store?> renameStoreIcon(int id, String imageName, String newImageName) {

    return _renameCollectionItemImage<Store>(
      tableName: StoreEntityData.table,
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: StoreRepository.updateIconById,
      id: id,
      findItemById: findStoreById,
    );

  }

  @override
  Future<Store?> deleteStoreIcon(int id, String imageName) {

    return _deleteCollectionItemImage<Store>(
      tableName: StoreEntityData.table,
      imageName: imageName,
      queryBuilder: StoreRepository.updateIconById,
      id: id,
      findItemById: findStoreById,
    );

  }
  //#region Store

  //#region System
  @override
  Future<System?> uploadSystemIcon(int id, String uploadImagePath, [String? oldImageName]) {

    return _uploadCollectionItemImage<System>(
      tableName: SystemEntityData.table,
      uploadImagePath: uploadImagePath,
      initialImageName: 'icon',
      oldImageName: oldImageName,
      queryBuilder: SystemRepository.updateIconById,
      id: id,
      findItemById: findSystemById,
    );

  }

  @override
  Future<System?> renameSystemIcon(int id, String imageName, String newImageName) {

    return _renameCollectionItemImage<System>(
      tableName: SystemEntityData.table,
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: SystemRepository.updateIconById,
      id: id,
      findItemById: findSystemById,
    );

  }

  @override
  Future<System?> deleteSystemIcon(int id, String imageName) {

    return _deleteCollectionItemImage<System>(
      tableName: SystemEntityData.table,
      imageName: imageName,
      queryBuilder: SystemRepository.updateIconById,
      id: id,
      findItemById: findSystemById,
    );

  }
  //#endregion System
  //#endregion IMAGE

  //#region DOWNLOAD
  String? _getGameCoverURL(String? gameCoverName) {

    return gameCoverName != null?
        _imageConnector.getURI(
          tableName: GameEntityData.table,
          imageFilename: gameCoverName,
        )
        : null;

  }

  String? _getDLCCoverURL(String? dlcCoverName) {

    return dlcCoverName != null?
        _imageConnector.getURI(
          tableName: DLCEntityData.table,
          imageFilename: dlcCoverName,
        )
        : null;

  }

  String? _getPlatformIconURL(String? platformIconName) {

    return platformIconName != null?
        _imageConnector.getURI(
          tableName: PlatformEntityData.table,
          imageFilename: platformIconName,
        )
        : null;

  }

  String? _getStoreIconURL(String? storeIconName) {

    return storeIconName != null?
        _imageConnector.getURI(
          tableName: StoreEntityData.table,
          imageFilename: storeIconName,
        )
        : null;

  }

  String? _getSystemIconURL(String? systemIconName) {

    return systemIconName != null?
        _imageConnector.getURI(
          tableName: SystemEntityData.table,
          imageFilename: systemIconName,
        )
        : null;

  }
  //#endregion DOWNLOAD

  //#region Utils
  Future<T?> _createCollectionItem<T extends CollectionItem>({required Query query, required int? Function(List<Map<String, Map<String, dynamic>>>) dynamicToId, required Stream<T?> Function(int) findItemById}) async {

    final int? id = await _itemConnector.execute(query)
      .asStream()
      .map( dynamicToId ).first;

    if(id != null) {
      return findItemById(id).first;
    } else {
      return Future<T?>.value(null);
    }

  }

  Future<T?> _updateCollectionItem<T extends CollectionItem>({required Query query, required int id, required Stream<T?> Function(int) findItemById}) async {

    await _itemConnector.execute(query);

    return findItemById(id).first;

  }

  Future<T?> _uploadCollectionItemImage<T extends CollectionItem>({required String tableName, required String uploadImagePath, required String initialImageName, required String? oldImageName, required Query Function(int, String?) queryBuilder, required int id, required Stream<T?> Function(int) findItemById}) async {

    if(oldImageName != null) {
      await _imageConnector.delete(
        tableName: tableName,
        imageName: oldImageName,
      );
    }

    final String imageName = await _imageConnector.set(
      imagePath: uploadImagePath,
      tableName: tableName,
      imageName: _getImageName(id, initialImageName),
    );

    return _updateCollectionItem<T>(
      query: queryBuilder(id, imageName),
      id: id,
      findItemById: findItemById,
    );

  }

  Future<T?> _renameCollectionItemImage<T extends CollectionItem>({required String tableName, required String oldImageName, required String newImageName, required Query Function(int, String?) queryBuilder, required int id, required Stream<T?> Function(int) findItemById}) async {

    final String imageName = await _imageConnector.rename(
      tableName: tableName,
      oldImageName: oldImageName,
      newImageName: _getImageName(id, newImageName),
    );

    return _updateCollectionItem<T>(
      query: queryBuilder(id, imageName),
      id: id,
      findItemById: findItemById,
    );

  }

  Future<T?> _deleteCollectionItemImage<T extends CollectionItem>({required String tableName, required String imageName, required Query Function(int, String?) queryBuilder, required int id, required Stream<T?> Function(int) findItemById}) async {

    await _imageConnector.delete(
      tableName: tableName,
      imageName: imageName,
    );

    return _updateCollectionItem<T>(
      query: queryBuilder(id, null),
      id: id,
      findItemById: findItemById,
    );

  }

  String _getImageName(int id, String imageName) {

    return id.toString() + '-' + imageName;

  }
  //#endregion Utils

  //#region Dynamic Map to List
  List<Game> _dynamicToListGame(List<Map<String, Map<String, dynamic>>> results) {

    return GameEntity.fromDynamicMapList(results).map( (GameEntity gameEntity) {
      return GameMapper.entityToModel(gameEntity, _getGameCoverURL(gameEntity.coverFilename));
    }).toList(growable: false);

  }

  List<GameFinish> _dynamicToListGameFinish(List<Map<String, Map<String, dynamic>>> results) {

    return GameFinishEntity.fromDynamicMapList(results).map( GameMapper.finishEntityToModel ).toList(growable: false);

  }

  List<GameTimeLog> _dynamicToListTimeLog(List<Map<String, Map<String, dynamic>>> results) {

    return GameTimeLogEntity.fromDynamicMapList(results).map( GameMapper.logEntityToModel ).toList(growable: false);

  }

  List<GameWithLogs> _dynamicToListGamesWithLogs(List<Map<String, Map<String, dynamic>>> results) {

    return GameWithLogsEntity.fromDynamicMapList(results).map( (GameWithLogsEntity gameWithLogsEntity) {
      return GameMapper.gameWithLogEntityToModel(gameWithLogsEntity, _getGameCoverURL(gameWithLogsEntity.game.coverFilename));
    }).toList(growable: false);

  }

  List<DLC> _dynamicToListDLC(List<Map<String, Map<String, dynamic>>> results) {

    return DLCEntity.fromDynamicMapList(results).map( (DLCEntity dlcEntity) {
      return DLCMapper.entityToModel(dlcEntity, _getDLCCoverURL(dlcEntity.coverFilename));
    }).toList(growable: false);

  }

  List<DLCFinish> _dynamicToListDLCFinish(List<Map<String, Map<String, dynamic>>> results) {

    return DLCFinishEntity.fromDynamicMapList(results).map( DLCMapper.finishEntityToModel ).toList(growable: false);

  }

  List<Platform> _dynamicToListPlatform(List<Map<String, Map<String, dynamic>>> results) {

    return PlatformEntity.fromDynamicMapList(results).map( (PlatformEntity platformEntity) {
      return PlatformMapper.entityToModel(platformEntity, _getPlatformIconURL(platformEntity.iconFilename));
    }).toList(growable: false);

  }

  List<Purchase> _dynamicToListPurchase(List<Map<String, Map<String, dynamic>>> results) {

    return PurchaseEntity.fromDynamicMapList(results).map( PurchaseMapper.entityToModel ).toList(growable: false);

  }

  List<Store> _dynamicToListStore(List<Map<String, Map<String, dynamic>>> results) {

    return StoreEntity.fromDynamicMapList(results).map( (StoreEntity storeEntity) {
      return StoreMapper.entityToModel(storeEntity, _getStoreIconURL(storeEntity.iconFilename));
    }).toList(growable: false);

  }

  List<System> _dynamicToListSystem(List<Map<String, Map<String, dynamic>>> results) {

    return SystemEntity.fromDynamicMapList(results).map( (SystemEntity systemEntity) {
      return SystemMapper.entityToModel(systemEntity, _getSystemIconURL(systemEntity.iconFilename));
    }).toList(growable: false);

  }

  List<Tag> _dynamicToListGameTag(List<Map<String, Map<String, dynamic>>> results) {

    return GameTagEntity.fromDynamicMapList(results).map( GameTagMapper.entityToModel ).toList(growable: false);

  }

  List<PurchaseType> _dynamicToListPurchaseType(List<Map<String, Map<String, dynamic>>> results) {

    return PurchaseTypeEntity.fromDynamicMapList(results).map( PurchaseTypeMapper.entityToModel ).toList(growable: false);

  }

  T? _dynamicToSingleCollectionItem<T extends CollectionItem>(List<Map<String, Map<String, dynamic>>> results, List<T> Function(List<Map<String, Map<String, dynamic>>>) dynamicToList) {

    T? singleItem;

    if(results.isNotEmpty) {
      singleItem = dynamicToList(results).first;
    }

    return singleItem;
  }

  Game? _dynamicToSingleGame(List<Map<String, Map<String, dynamic>>> results) {

    return _dynamicToSingleCollectionItem<Game>(results, _dynamicToListGame);

  }

  DLC? _dynamicToSingleDLC(List<Map<String, Map<String, dynamic>>> results) {

    return _dynamicToSingleCollectionItem<DLC>(results, _dynamicToListDLC);

  }

  Platform? _dynamicToSinglePlatform(List<Map<String, Map<String, dynamic>>> results) {

    return _dynamicToSingleCollectionItem<Platform>(results, _dynamicToListPlatform);

  }

  Purchase? _dynamicToSinglePurchase(List<Map<String, Map<String, dynamic>>> results) {

    return _dynamicToSingleCollectionItem<Purchase>(results, _dynamicToListPurchase);

  }

  Store? _dynamicToSingleStore(List<Map<String, Map<String, dynamic>>> results) {

    return _dynamicToSingleCollectionItem<Store>(results, _dynamicToListStore);

  }

  System? _dynamicToSingleSystem(List<Map<String, Map<String, dynamic>>> results) {

    return _dynamicToSingleCollectionItem<System>(results, _dynamicToListSystem);

  }

  Tag? _dynamicToSingleGameTag(List<Map<String, Map<String, dynamic>>> results) {

    return _dynamicToSingleCollectionItem<Tag>(results, _dynamicToListGameTag);

  }

  PurchaseType? _dynamicToSinglePurchaseType(List<Map<String, Map<String, dynamic>>> results) {

    return _dynamicToSingleCollectionItem<PurchaseType>(results, _dynamicToListPurchaseType);

  }
  //#endregion Dynamic Map to List
}
