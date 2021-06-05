import 'package:backend/connector/connector.dart';

import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart';
import 'package:backend/query/query.dart';

import 'collection_repository.dart';


class RemoteRepository implements CollectionRepository {
  RemoteRepository._(SQLConnector iSQLConnector, ImageConnector iImageConnector) {
    _iSQLConnector = iSQLConnector;
    _iImageConnector = iImageConnector;
  }

  late SQLConnector _iSQLConnector;
  late ImageConnector _iImageConnector;

  factory RemoteRepository(SQLConnector iSQLConnector, ImageConnector iImageConnector) {
    return RemoteRepository._(
      iSQLConnector,
      iImageConnector,
    );
  }

  @override
  Future<dynamic> open() {

    return _iSQLConnector.open();

  }

  @override
  Future<dynamic> close() {

    return _iSQLConnector.close();

  }

  @override
  bool isOpen() {

    return _iSQLConnector.isOpen();

  }

  @override
  bool isClosed() {

    return _iSQLConnector.isClosed();

  }

  @override
  void reconnect() {

    _iSQLConnector.reconnect();

  }

  //#region CREATE
  //#region Game
  @override
  Future<Game?> createGame(Game game) {

    return _createCollectionItem<Game>(
      tableName: GameEntityData.table,
      newItem: game,
      idField: GameEntityData.idField,
      findItemById: findGameById,
    );

  }

  @override
  Future<dynamic> relateGamePlatform(int gameId, int platformId) {

    return _iSQLConnector.create(
      tableName: GamePlatformRelationData.table,
      insertFieldsAndValues: GamePlatformRelationData.getCreateDynamicMap(gameId, platformId),
    );

  }

  @override
  Future<dynamic> relateGamePurchase(int gameId, int purchaseId) {

     return _iSQLConnector.create(
      tableName: GamePurchaseRelationData.table,
      insertFieldsAndValues: GamePurchaseRelationData.getCreateDynamicMap(gameId, purchaseId),
    );

  }

  @override
  Future<dynamic> relateGameDLC(int gameId, int dlcId) {

    return _iSQLConnector.update(
      tableName: DLCEntityData.table,
      setFieldsAndValues: <String, dynamic> {
        DLCEntityData.baseGameField : gameId,
      },
      whereQuery: DLCEntityData.getIdQuery(dlcId),
    );

  }

  @override
  Future<dynamic> relateGameTag(int gameId, int tagId) {

    return _iSQLConnector.create(
      tableName: GameTagRelationData.table,
      insertFieldsAndValues: GameTagRelationData.getCreateDynamicMap(gameId, tagId),
    );

  }

  @override
  Future<dynamic> createGameFinish(int gameId, GameFinish finish) {

    return _iSQLConnector.create(
      tableName: GameFinishEntityData.table,
      insertFieldsAndValues: finish.toEntity().getCreateDynamicMap(gameId),
    );

  }

  @override
  Future<dynamic> createGameTimeLog(int gameId, GameTimeLog timeLog) {

    return _iSQLConnector.create(
      tableName: GameTimeLogEntityData.table,
      insertFieldsAndValues: timeLog.toEntity().getCreateDynamicMap(gameId),
    );

  }
  //#endregion Game

  //#region DLC
  @override
  Future<DLC?> createDLC(DLC dlc) {

    return _createCollectionItem<DLC>(
      tableName: DLCEntityData.table,
      newItem: dlc,
      idField: DLCEntityData.idField,
      findItemById: findDLCById,
    );

  }

  @override
  Future<dynamic> relateDLCPurchase(int dlcId, int purchaseId) {

    return _iSQLConnector.create(
      tableName: DLCPurchaseRelationData.table,
      insertFieldsAndValues: DLCPurchaseRelationData.getCreateDynamicMap(dlcId, purchaseId),
    );

  }

  @override
  Future<dynamic> createDLCFinish(int dlcId, DLCFinish finish) {

    return _iSQLConnector.create(
      tableName: DLCFinishEntityData.table,
      insertFieldsAndValues: finish.toEntity().getCreateDynamicMap(dlcId),
    );

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<Platform?> createPlatform(Platform platform) {

    return _createCollectionItem<Platform>(
      tableName: PlatformEntityData.table,
      newItem: platform,
      idField: PlatformEntityData.idField,
      findItemById: findPlatformById,
    );

  }

  @override
  Future<dynamic> relatePlatformSystem(int platformId, int systemId) {

    return _iSQLConnector.create(
      tableName: PlatformSystemRelationData.table,
      insertFieldsAndValues: PlatformSystemRelationData.getCreateDynamicMap(platformId, systemId),
    );

  }
  //#endregion Platform

  //#region Purchase
  @override
  Future<Purchase?> createPurchase(Purchase purchase) {

    return _createCollectionItem<Purchase>(
      tableName: PurchaseEntityData.table,
      newItem: purchase,
      idField: PurchaseEntityData.idField,
      findItemById: findPurchaseById,
    );

  }

  @override
  Future<dynamic> relatePurchaseType(int purchaseId, int typeId) {

    return _iSQLConnector.create(
      tableName: PurchaseTypeRelationData.table,
      insertFieldsAndValues: PurchaseTypeRelationData.getCreateDynamicMap(purchaseId, typeId),
    );

  }
  //#endregion Purchase

  //#region Store
  @override
  Future<Store?> createStore(Store store) {

    return _createCollectionItem<Store>(
      tableName: StoreEntityData.table,
      newItem: store,
      idField: StoreEntityData.idField,
      findItemById: findStoreById,
    );

  }

  @override
  Future<dynamic> relateStorePurchase(int storeId, int purchaseId) {

    return _iSQLConnector.update(
      tableName: PurchaseEntityData.table,
      setFieldsAndValues: <String, dynamic> {
        PurchaseEntityData.storeField : storeId,
      },
      whereQuery: PurchaseEntityData.getIdQuery(purchaseId),
    );

  }
  //#endregion Store

  //#region System
  @override
  Future<System?> createSystem(System system) {

    return _createCollectionItem<System>(
      tableName: SystemEntityData.table,
      newItem: system,
      idField: StoreEntityData.idField,
      findItemById: findSystemById,
    );

  }
  //#endregion System

  //#region Tag
  @override
  Future<Tag?> createGameTag(Tag tag) {

    return _createCollectionItem<Tag>(
      tableName: GameTagEntityData.table,
      newItem: tag,
      idField: GameTagEntityData.idField,
      findItemById: findGameTagById,
    );

  }
  //#endregion Tag

  //#region Type
  @override
  Future<PurchaseType?> createPurchaseType(PurchaseType type) {

    return _createCollectionItem<PurchaseType>(
      tableName: PurchaseTypeEntityData.table,
      newItem: type,
      idField: PurchaseTypeEntityData.idField,
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

    return _iSQLConnector.read(
      tableName: allViewToTable[gameView]!,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllGamesWithYearView(GameView gameView, int year, [int? limit]) {

    // TODO read sql function
    return _iSQLConnector.read(
      tableName: allViewToTable[gameView]!,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllOwnedGamesWithView(GameView gameView, [int? limit]) {

    return _iSQLConnector.read(
      tableName: ownedViewToTable[gameView]!,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllOwnedGamesWithYearView(GameView gameView, int year, [int? limit]) {

    // TODO read sql function
    return _iSQLConnector.read(
      tableName: ownedViewToTable[gameView]!,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllRomGamesWithView(GameView gameView, [int? limit]) {

    return _iSQLConnector.read(
      tableName: romViewToTable[gameView]!,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllRomGamesWithYearView(GameView gameView, int year, [int? limit]) {

    // TODO read sql function
    return _iSQLConnector.read(
      tableName: romViewToTable[gameView]!,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<Game?> findGameById(int id) {

    return _iSQLConnector.read(
      tableName: GameEntityData.readTable,
      selectFieldsAndTypes: GameEntityData.fields,
      whereQuery: GameEntityData.getIdQuery(id),
    ).asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<Platform>> findAllPlatformsFromGame(int id) {

    return _iSQLConnector.readRelation(
      tableName: PlatformEntityData.table,
      relationTable: GamePlatformRelationData.table,
      idField: PlatformEntityData.idField,
      joinField: PlatformEntityData.relationField,
      selectFieldsAndTypes: PlatformEntityData.fields,
      whereQuery: Query()
        ..addAnd(GameEntityData.relationField, id),
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesFromGame(int id) {

    return _iSQLConnector.readRelation(
      tableName: PurchaseEntityData.table,
      relationTable: GamePurchaseRelationData.table,
      idField: PurchaseEntityData.idField,
      joinField: PurchaseEntityData.relationField,
      selectFieldsAndTypes: PurchaseEntityData.fields,
      whereQuery: Query()
        ..addAnd(GameEntityData.relationField, id),
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<DLC>> findAllDLCsFromGame(int id) {

    return _iSQLConnector.readWeakRelation(
      primaryTable: GameEntityData.table,
      subordinateTable: DLCEntityData.table,
      idField: GameEntityData.idField,
      joinField: DLCEntityData.baseGameField,
      selectFieldsAndTypes: DLCEntityData.fields,
      whereQuery: Query()
        ..addAnd(DLCEntityData.baseGameField, id),
      primaryResults: false,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<Tag>> findAllGameTagsFromGame(int id) {

    return _iSQLConnector.readRelation(
      tableName: GameTagEntityData.table,
      relationTable: GameTagRelationData.table,
      idField: GameTagEntityData.idField,
      joinField: GameTagEntityData.relationField,
      selectFieldsAndTypes: GameTagEntityData.fields,
      whereQuery: Query()
        ..addAnd(GameEntityData.relationField, id),
    ).asStream().map( _dynamicToListGameTag );

  }

  @override
  Stream<List<GameFinish>> findAllGameFinishFromGame(int id) {

    return _iSQLConnector.read(
      tableName: GameFinishEntityData.readTable,
      selectFieldsAndTypes: GameFinishEntityData.fields,
      whereQuery: Query()
        ..addAnd(GameEntityData.relationField, id),
    ).asStream().map( _dynamicToListGameFinish );

  }

  @override
  Stream<List<GameTimeLog>> findAllGameTimeLogsFromGame(int id) {

    return _iSQLConnector.read(
      tableName: GameTimeLogEntityData.readTable,
      selectFieldsAndTypes: GameTimeLogEntityData.fields,
      whereQuery: Query()
        ..addAnd(GameEntityData.relationField, id),
    ).asStream().map( _dynamicToListTimeLog );

  }
  //#endregion Game

  //#region DLC
  @override
  Stream<List<DLC>> findAllDLCs() {

    return findAllDLCsWithView(DLCView.Main);

  }

  @override
  Stream<List<DLC>> findAllDLCsWithView(DLCView dlcView, [int? limit]) {

    return _iSQLConnector.read(
      tableName: dlcViewToTable[dlcView]!,
      selectFieldsAndTypes: DLCEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<DLC?> findDLCById(int id) {

    return _iSQLConnector.read(
      tableName: DLCEntityData.readTable,
      selectFieldsAndTypes: DLCEntityData.fields,
      whereQuery: DLCEntityData.getIdQuery(id),
    ).asStream().map( _dynamicToSingleDLC );

  }

  @override
  Stream<Game?> findBaseGameFromDLC(int dlcId) {

    return _iSQLConnector.readWeakRelation(
      primaryTable: GameEntityData.table,
      subordinateTable: DLCEntityData.table,
      idField: GameEntityData.idField,
      joinField: DLCEntityData.baseGameField,
      selectFieldsAndTypes: GameEntityData.fields,
      whereQuery: DLCEntityData.getIdQuery(dlcId),
      primaryResults: true,
    ).asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesFromDLC(int id) {

    return _iSQLConnector.readRelation(
      tableName: PurchaseEntityData.table,
      relationTable: DLCPurchaseRelationData.table,
      idField: PurchaseEntityData.idField,
      joinField: PurchaseEntityData.relationField,
      selectFieldsAndTypes: PurchaseEntityData.fields,
      whereQuery: Query()
        ..addAnd(DLCEntityData.relationField, id),
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<DLCFinish>> findAllDLCFinishFromDLC(int id) {

    return _iSQLConnector.read(
      tableName: DLCFinishEntityData.readTable,
      selectFieldsAndTypes: DLCFinishEntityData.fields,
      whereQuery: Query()
        ..addAnd(DLCEntityData.relationField, id),
    ).asStream().map( _dynamicToListDLCFinish );

  }
  //#endregion DLC

  //#region Platform
  @override
  Stream<List<Platform>> findAllPlatforms() {

    return findAllPlatformsWithView(PlatformView.Main);

  }

  @override
  Stream<List<Platform>> findAllPlatformsWithView(PlatformView platformView, [int? limit]) {

    return _iSQLConnector.read(
      tableName: platformViewToTable[platformView]!,
      selectFieldsAndTypes: PlatformEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<Platform?> findPlatformById(int id) {

    return _iSQLConnector.read(
      tableName: PlatformEntityData.table,
      selectFieldsAndTypes: PlatformEntityData.fields,
      whereQuery: PlatformEntityData.getIdQuery(id),
    ).asStream().map( _dynamicToSinglePlatform );

  }

  @override
  Stream<List<Game>> findAllGamesFromPlatform(int id) {

    return _iSQLConnector.readRelation(
      tableName: GameEntityData.table,
      relationTable: GamePlatformRelationData.table,
      idField: GameEntityData.idField,
      joinField: GameEntityData.relationField,
      selectFieldsAndTypes: GameEntityData.fields,
      whereQuery: Query()
        ..addAnd(PlatformEntityData.relationField, id),
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<System>> findAllSystemsFromPlatform(int id) {

    return _iSQLConnector.readRelation(
      tableName: SystemEntityData.table,
      relationTable: PlatformSystemRelationData.table,
      idField: SystemEntityData.idField,
      joinField: SystemEntityData.relationField,
      selectFieldsAndTypes: SystemEntityData.fields,
      whereQuery: Query()
        ..addAnd(PlatformEntityData.relationField, id),
    ).asStream().map( _dynamicToListSystem );

  }
  //#endregion Platform

  //#region Purchase
  @override
  Stream<List<Purchase>> findAllPurchases() {

    return findAllPurchasesWithView(PurchaseView.Main);

  }

  @override
  Stream<List<Purchase>> findAllPurchasesWithView(PurchaseView purchaseView, [int? limit]) {

    return _iSQLConnector.read(
      tableName: purchaseViewToTable[purchaseView]!,
      selectFieldsAndTypes: PurchaseEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesWithYearView(PurchaseView purchaseView, int year, [int? limit]) {

    // TODO read sql function
    return _iSQLConnector.read(
      tableName: purchaseViewToTable[purchaseView]!,
      selectFieldsAndTypes: PurchaseEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<Purchase?> findPurchaseById(int id) {

    return _iSQLConnector.read(
      tableName: PurchaseEntityData.table,
      selectFieldsAndTypes: PurchaseEntityData.fields,
      whereQuery: PurchaseEntityData.getIdQuery(id),
    ).asStream().map( _dynamicToSinglePurchase );

  }

  @override
  Stream<Store?> findStoreFromPurchase(int id) {

    return _iSQLConnector.readWeakRelation(
      primaryTable: StoreEntityData.table,
      subordinateTable: PurchaseEntityData.table,
      idField: StoreEntityData.idField,
      joinField: PurchaseEntityData.storeField,
      selectFieldsAndTypes: StoreEntityData.fields,
      whereQuery: PurchaseEntityData.getIdQuery(id),
      primaryResults: true,
    ).asStream().map( _dynamicToSingleStore );

  }

  @override
  Stream<List<Game>> findAllGamesFromPurchase(int id) {

    return _iSQLConnector.readRelation(
      tableName: GameEntityData.table,
      relationTable: GamePurchaseRelationData.table,
      idField: GameEntityData.idField,
      joinField: GameEntityData.relationField,
      selectFieldsAndTypes: GameEntityData.fields,
      whereQuery: Query()
        ..addAnd(PurchaseEntityData.relationField, id),
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<DLC>> findAllDLCsFromPurchase(int id) {

    return _iSQLConnector.readRelation(
      tableName: DLCEntityData.table,
      relationTable: DLCPurchaseRelationData.table,
      idField: DLCEntityData.idField,
      joinField: DLCEntityData.relationField,
      selectFieldsAndTypes: DLCEntityData.fields,
      whereQuery: Query()
        ..addAnd(PurchaseEntityData.relationField, id),
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<PurchaseType>> findAllPurchaseTypesFromPurchase(int id) {

    return _iSQLConnector.readRelation(
      tableName: PurchaseTypeEntityData.table,
      relationTable: PurchaseTypeRelationData.table,
      idField: PurchaseTypeEntityData.idField,
      joinField: PurchaseTypeEntityData.relationField,
      selectFieldsAndTypes: PurchaseTypeEntityData.fields,
      whereQuery: Query()
        ..addAnd(PurchaseEntityData.relationField, id),
    ).asStream().map( _dynamicToListPurchaseType );

  }
  //#endregion Purchase

  //#region Store
  @override
  Stream<List<Store>> findAllStores() {

    return findAllStoresWithView(StoreView.Main);

  }

  @override
  Stream<List<Store>> findAllStoresWithView(StoreView storeView, [int? limit]) {

    return _iSQLConnector.read(
      tableName: storeViewToTable[storeView]!,
      selectFieldsAndTypes: StoreEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListStore );
  }

  @override
  Stream<Store?> findStoreById(int id) {

    return _iSQLConnector.read(
      tableName: StoreEntityData.table,
      selectFieldsAndTypes: StoreEntityData.fields,
      whereQuery: StoreEntityData.getIdQuery(id),
    ).asStream().map( _dynamicToSingleStore );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesFromStore(int storeId) {

    return _iSQLConnector.readWeakRelation(
      primaryTable: StoreEntityData.table,
      subordinateTable: PurchaseEntityData.table,
      idField: StoreEntityData.idField,
      joinField: PurchaseEntityData.storeField,
      selectFieldsAndTypes: PurchaseEntityData.fields,
      whereQuery: Query()
        ..addAnd(PurchaseEntityData.storeField, storeId),
      primaryResults: false,
    ).asStream().map( _dynamicToListPurchase );

  }
  //#endregion Store

  //#region System
  @override
  Stream<List<System>> findAllSystems() {

    return findAllSystemsWithView(SystemView.Main);

  }

  @override
  Stream<List<System>> findAllSystemsWithView(SystemView systemView, [int? limit]) {

    return _iSQLConnector.read(
      tableName: systemViewToTable[systemView]!,
      selectFieldsAndTypes: SystemEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListSystem );
  }

  @override
  Stream<System?> findSystemById(int id) {

    return _iSQLConnector.read(
      tableName: SystemEntityData.table,
      selectFieldsAndTypes: SystemEntityData.fields,
      whereQuery: SystemEntityData.getIdQuery(id),
    ).asStream().map( _dynamicToSingleSystem );

  }

  @override
  Stream<List<Platform>> findAllPlatformsFromSystem(int id) {

    return _iSQLConnector.readRelation(
      tableName: PlatformEntityData.table,
      relationTable: PlatformSystemRelationData.table,
      idField: PlatformEntityData.idField,
      joinField: PlatformEntityData.relationField,
      selectFieldsAndTypes: PlatformEntityData.fields,
      whereQuery: Query()
        ..addAnd(SystemEntityData.relationField, id),
    ).asStream().map( _dynamicToListPlatform );

  }
  //#endregion System

  //#region GameTag
  @override
  Stream<List<Tag>> findAllGameTags() {

    return findAllGameTagsWithView(TagView.Main);

  }

  @override
  Stream<List<Tag>> findAllGameTagsWithView(TagView tagView, [int? limit]) {

    return _iSQLConnector.read(
      tableName: tagViewToTable[tagView]!,
      selectFieldsAndTypes: GameTagEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGameTag );

  }

  @override
  Stream<Tag?> findGameTagById(int id) {

    return _iSQLConnector.read(
      tableName: GameTagEntityData.table,
      selectFieldsAndTypes: GameTagEntityData.fields,
      whereQuery: GameTagEntityData.getIdQuery(id),
    ).asStream().map( _dynamicToSingleGameTag );

  }

  @override
  Stream<List<Game>> findAllGamesFromGameTag(int id) {

    return _iSQLConnector.readRelation(
      tableName: GameEntityData.table,
      relationTable: GameTagRelationData.table,
      idField: GameEntityData.idField,
      joinField: GameEntityData.relationField,
      selectFieldsAndTypes: GameEntityData.fields,
      whereQuery: Query()
        ..addAnd(GameTagEntityData.relationField, id),
    ).asStream().map( _dynamicToListGame );
  }
  //#endregion GameTag

  //#region PurchaseType
  @override
  Stream<List<PurchaseType>> findAllPurchaseTypes() {

    return findAllPurchaseTypesWithView(TypeView.Main);

  }

  @override
  Stream<List<PurchaseType>> findAllPurchaseTypesWithView(TypeView typeView, [int? limit]) {

    return _iSQLConnector.read(
      tableName: typeViewToTable[typeView]!,
      selectFieldsAndTypes: PurchaseTypeEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListPurchaseType );

  }

  @override
  Stream<PurchaseType?> findPurchaseTypeById(int id) {

    return _iSQLConnector.read(
      tableName: PurchaseTypeEntityData.table,
      selectFieldsAndTypes: PurchaseTypeEntityData.fields,
      whereQuery: PurchaseTypeEntityData.getIdQuery(id),
    ).asStream().map( _dynamicToSinglePurchaseType );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesFromPurchaseType(int id) {

    return _iSQLConnector.readRelation(
      tableName: PurchaseEntityData.table,
      relationTable: PurchaseTypeRelationData.table,
      idField: PurchaseEntityData.idField,
      joinField: PurchaseEntityData.relationField,
      selectFieldsAndTypes: PurchaseEntityData.fields,
      whereQuery: Query()
        ..addAnd(PurchaseTypeEntityData.relationField, id),
    ).asStream().map( _dynamicToListPurchase );

  }
  //#endregion PurchaseType
  //#endregion READ


  //#region UPDATE
    //Game
  @override
  Future<Game?> updateGame<T>(Game game, Game updatedGame, GameUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = game.toEntity().getUpdateDynamicMap(updatedGame.toEntity(), updateProperties);

    return _updateCollectionItem<Game>(
      tableName: GameEntityData.table,
      fieldsAndValues: fieldsAndValues,
      idField: GameEntityData.idField,
      id: game.id,
      findItemById: findGameById,
    );

  }

    //DLC
  @override
  Future<DLC?> updateDLC(DLC dlc, DLC updatedDlc, DLCUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = dlc.toEntity().getUpdateDynamicMap(updatedDlc.toEntity(), updateProperties);

    return _updateCollectionItem<DLC>(
      tableName: DLCEntityData.table,
      fieldsAndValues: fieldsAndValues,
      idField: DLCEntityData.idField,
      id: dlc.id,
      findItemById: findDLCById,
    );

  }

    //Platform
  @override
  Future<Platform?> updatePlatform(Platform platform, Platform updatedPlatform, PlatformUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = platform.toEntity().getUpdateDynamicMap(updatedPlatform.toEntity(), updateProperties);

    return _updateCollectionItem<Platform>(
      tableName: PlatformEntityData.table,
      fieldsAndValues: fieldsAndValues,
      idField: PlatformEntityData.idField,
      id: platform.id,
      findItemById: findPlatformById,
    );

  }

    //Purchase
  @override
  Future<Purchase?> updatePurchase(Purchase purchase, Purchase updatedPurchase, PurchaseUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = purchase.toEntity().getUpdateDynamicMap(updatedPurchase.toEntity(), updateProperties);

    return _updateCollectionItem<Purchase>(
      tableName: PurchaseEntityData.table,
      fieldsAndValues: fieldsAndValues,
      idField: PurchaseEntityData.idField,
      id: purchase.id,
      findItemById: findPurchaseById,
    );

  }

    //Store
  @override
  Future<Store?> updateStore(Store store, Store updatedStore, StoreUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = store.toEntity().getUpdateDynamicMap(updatedStore.toEntity(), updateProperties);

    return _updateCollectionItem<Store>(
      tableName: StoreEntityData.table,
      fieldsAndValues: fieldsAndValues,
      idField: StoreEntityData.idField,
      id: store.id,
      findItemById: findStoreById,
    );

  }

    //System
  @override
  Future<System?> updateSystem(System system, System updatedSystem, SystemUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = system.toEntity().getUpdateDynamicMap(updatedSystem.toEntity(), updateProperties);

    return _updateCollectionItem<System>(
      tableName: SystemEntityData.table,
      fieldsAndValues: fieldsAndValues,
      idField: SystemEntityData.idField,
      id: system.id,
      findItemById: findSystemById,
    );

  }

    //Tag
  @override
  Future<Tag?> updateGameTag(Tag tag, Tag updatedTag, GameTagUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = tag.toEntity().getUpdateDynamicMap(updatedTag.toEntity(), updateProperties);

    return _updateCollectionItem<Tag>(
      tableName: GameTagEntityData.table,
      fieldsAndValues: fieldsAndValues,
      idField: GameTagEntityData.idField,
      id: tag.id,
      findItemById: findGameTagById,
    );

  }

    //Type
  @override
  Future<PurchaseType?> updatePurchaseType(PurchaseType type, PurchaseType updatedType, PurchaseTypeUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = type.toEntity().getUpdateDynamicMap(updatedType.toEntity(), updateProperties);

    return _updateCollectionItem<PurchaseType>(
      tableName: PurchaseTypeEntityData.table,
      fieldsAndValues: fieldsAndValues,
      idField: PurchaseTypeEntityData.idField,
      id: type.id,
      findItemById: findPurchaseTypeById,
    );

  }
  //#endregion UPDATE


  //#region DELETE
  //#region Game
  @override
  Future<dynamic> deleteGameById(int id) {

    return _iSQLConnector.delete(
      tableName: GameEntityData.table,
      whereQuery: GameEntityData.getIdQuery(id),
    );

  }

  @override
  Future<dynamic> unrelateGamePlatform(int gameId, int platformId) {

    return _iSQLConnector.delete(
      tableName: GamePlatformRelationData.table,
      whereQuery: GamePlatformRelationData.getIdQuery(gameId, platformId),
    );

  }

  @override
  Future<dynamic> unrelateGamePurchase(int gameId, int purchaseId) {

    return _iSQLConnector.delete(
      tableName: GamePurchaseRelationData.table,
      whereQuery: GamePurchaseRelationData.getIdQuery(gameId, purchaseId),
    );

  }

  @override
  Future<dynamic> unrelateGameDLC(int dlcId) {

    return _iSQLConnector.update(
      tableName: DLCEntityData.table,
      whereQuery: DLCEntityData.getIdQuery(dlcId),
      setFieldsAndValues: <String, dynamic> {
        DLCEntityData.baseGameField : null,
      },
    );

  }

  @override
  Future<dynamic> unrelateGameTag(int gameId, int tagId) {

    return _iSQLConnector.delete(
      tableName: GameTagRelationData.table,
      whereQuery: GameTagRelationData.getIdQuery(gameId, tagId),
    );

  }

  @override
  Future<dynamic> deleteGameFinishById(int gameId, DateTime date) {

    return _iSQLConnector.delete(
      tableName: GameFinishEntityData.table,
      whereQuery: GameFinishEntityData.getIdQuery(gameId, date),
    );

  }

  @override
  Future<dynamic> deleteGameTimeLogById(int gameId, DateTime dateTime) {

    return _iSQLConnector.delete(
      tableName: GameTimeLogEntityData.table,
      whereQuery: GameTimeLogEntityData.getIdQuery(gameId, dateTime),
    );

  }
  //#endregion Game

  //#region DLC
  @override
  Future<dynamic> deleteDLCById(int id) {

    return _iSQLConnector.delete(
      tableName: DLCEntityData.table,
      whereQuery: DLCEntityData.getIdQuery(id),
    );

  }

  @override
  Future<dynamic> unrelateDLCPurchase(int dlcId, int purchaseId) {

    return _iSQLConnector.delete(
      tableName: DLCPurchaseRelationData.table,
      whereQuery: DLCPurchaseRelationData.getIdQuery(dlcId, purchaseId),
    );

  }

  @override
  Future<dynamic> deleteDLCFinishById(int dlcId, DateTime date) {

    return _iSQLConnector.delete(
      tableName: DLCFinishEntityData.table,
      whereQuery: DLCFinishEntityData.getIdQuery(dlcId, date),
    );

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<dynamic> deletePlatformById(int id) {

    return _iSQLConnector.delete(
      tableName: PlatformEntityData.table,
      whereQuery: PlatformEntityData.getIdQuery(id),
    );

  }

  @override
  Future<dynamic> unrelatePlatformSystem(int platformId, int systemId) {

    return _iSQLConnector.delete(
      tableName: PlatformSystemRelationData.table,
      whereQuery: PlatformSystemRelationData.getIdQuery(platformId, systemId),
    );
  }
  //#endregion Platform

  //#region Purchase
  @override
  Future<dynamic> deletePurchaseById(int id) {

    return _iSQLConnector.delete(
      tableName: PurchaseEntityData.table,
      whereQuery: PurchaseEntityData.getIdQuery(id),
    );

  }

  @override
  Future<dynamic> unrelatePurchaseType(int purchaseId, int typeId) {

    return _iSQLConnector.delete(
      tableName: PurchaseTypeRelationData.table,
      whereQuery: PurchaseTypeRelationData.getIdQuery(purchaseId, typeId),
    );

  }
  //#endregion Purchase

  //#region Store
  @override
  Future<dynamic> deleteStoreById(int id) {

    return _iSQLConnector.delete(
      tableName: StoreEntityData.table,
      whereQuery: StoreEntityData.getIdQuery(id),
    );

  }

  @override
  Future<dynamic> unrelateStorePurchase(int purchaseId) {

    return _iSQLConnector.update(
      tableName: PurchaseEntityData.table,
      whereQuery: PurchaseEntityData.getIdQuery(purchaseId),
      setFieldsAndValues: <String, dynamic> {
        PurchaseEntityData.storeField : null,
      },
    );

  }
  //#endregion Store

  //#region System
  @override
  Future<dynamic> deleteSystemById(int id) {

    return _iSQLConnector.delete(
      tableName: SystemEntityData.table,
      whereQuery: SystemEntityData.getIdQuery(id),
    );

  }
  //#endregion System

  //#region Tag
  @override
  Future<dynamic> deleteGameTagById(int id) {

    return _iSQLConnector.delete(
      tableName: GameTagEntityData.table,
      whereQuery: GameTagEntityData.getIdQuery(id),
    );

  }
  //#endregion Tag

  //#region Type
  @override
  Future<dynamic> deletePurchaseTypeById(int id) {

    return _iSQLConnector.delete(
      tableName: PurchaseTypeEntityData.table,
      whereQuery: PurchaseTypeEntityData.getIdQuery(id),
    );

  }
  //#endregion Type
  //#endregion DELETE


  //#region SEARCH
  @override
  Stream<List<Game>> findAllGamesByName(String name, int maxResults) {

    return _iSQLConnector.read(
      tableName: GameEntityData.table,
      selectFieldsAndTypes: GameEntityData.fields,
      whereQuery: Query()
        ..addAnd(GameEntityData.nameField, name, QueryComparator.LIKE),
      limit: maxResults,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<DLC>> findAllDLCsByName(String name, int maxResults) {

    return _iSQLConnector.read(
      tableName: DLCEntityData.table,
      selectFieldsAndTypes: DLCEntityData.fields,
      whereQuery: Query()
        ..addAnd(DLCEntityData.nameField, name, QueryComparator.LIKE),
      limit: maxResults,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<Platform>> findAllPlatformsByName(String name, int maxResults) {

    return _iSQLConnector.read(
      tableName: PlatformEntityData.table,
      selectFieldsAndTypes: PlatformEntityData.fields,
      whereQuery: Query()
        ..addAnd(PlatformEntityData.nameField, name, QueryComparator.LIKE),
      limit: maxResults,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesByDescription(String description, int maxResults) {

    return _iSQLConnector.read(
      tableName: PurchaseEntityData.table,
      selectFieldsAndTypes: PurchaseEntityData.fields,
      whereQuery: Query()
        ..addAnd(PurchaseEntityData.descriptionField, description, QueryComparator.LIKE),
      limit: maxResults,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<Store>> findAllStoresByName(String name, int maxResults) {

    return _iSQLConnector.read(
      tableName: StoreEntityData.table,
      selectFieldsAndTypes: StoreEntityData.fields,
      whereQuery: Query()
        ..addAnd(StoreEntityData.nameField, name, QueryComparator.LIKE),
      limit: maxResults,
    ).asStream().map( _dynamicToListStore );

  }

  @override
  Stream<List<System>> findAllSystemsByName(String name, int maxResults) {

    return _iSQLConnector.read(
      tableName: SystemEntityData.table,
      selectFieldsAndTypes: SystemEntityData.fields,
      whereQuery: Query()
        ..addAnd(SystemEntityData.nameField, name, QueryComparator.LIKE),
      limit: maxResults,
    ).asStream().map( _dynamicToListSystem );

  }

  @override
  Stream<List<Tag>> findAllGameTagsByName(String name, int maxResults) {

    return _iSQLConnector.read(
      tableName: GameTagEntityData.table,
      selectFieldsAndTypes: GameTagEntityData.fields,
      whereQuery: Query()
        ..addAnd(GameTagEntityData.nameField, name, QueryComparator.LIKE),
      limit: maxResults,
    ).asStream().map( _dynamicToListGameTag );

  }

  @override
  Stream<List<PurchaseType>> findAllPurchaseTypesByName(String name, int maxResults) {

    return _iSQLConnector.read(
      tableName: PurchaseTypeEntityData.table,
      selectFieldsAndTypes: PurchaseTypeEntityData.fields,
      whereQuery: Query()
        ..addAnd(PurchaseTypeEntityData.nameField, name, QueryComparator.LIKE),
      limit: maxResults,
    ).asStream().map( _dynamicToListPurchaseType );
  }
  //#endregion SEARCH

  @override
  Stream<List<GameWithLogs>> findAllGamesWithTimeLogsByYear(int year) {

    return _iSQLConnector.readJoin(
      leftTable: GameTimeLogEntityData.table,
      rightTable: GameEntityData.table,
      leftTableIdField: GameEntityData.relationField,
      rightTableIdField: GameEntityData.idField,
      leftSelectFields: GameTimeLogEntityData.fields,
      rightSelectFields: GameEntityData.fields,
      whereQuery: Query()
        ..addAndRaw("date_part(\'year\', \"DateTime\") = $year"),
      orderFields: <String>[
        GameEntityData.relationField,
      ],
    ).asStream().map( _dynamicToListGamesWithLogs );

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
      imageField: GameEntityData.imageField,
      idField: GameEntityData.idField,
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
      imageField: GameEntityData.imageField,
      idField: GameEntityData.idField,
      id: id,
      findItemById: findGameById,
    );

  }

  @override
  Future<Game?> deleteGameCover(int id, String imageName) {

    return _deleteCollectionItemImage<Game>(
      tableName: GameEntityData.table,
      imageName: imageName,
      imageField: GameEntityData.imageField,
      idField: GameEntityData.idField,
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
      imageField: DLCEntityData.imageField,
      idField: DLCEntityData.idField,
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
      imageField: DLCEntityData.imageField,
      idField: DLCEntityData.idField,
      id: id,
      findItemById: findDLCById,
    );

  }

  @override
  Future<DLC?> deleteDLCCover(int id, String imageName) {

    return _deleteCollectionItemImage<DLC>(
      tableName: DLCEntityData.table,
      imageName: imageName,
      imageField: DLCEntityData.imageField,
      idField: DLCEntityData.idField,
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
      imageField: PlatformEntityData.imageField,
      idField: PlatformEntityData.idField,
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
      imageField: PlatformEntityData.imageField,
      idField: PlatformEntityData.idField,
      id: id,
      findItemById: findPlatformById,
    );

  }


  @override
  Future<Platform?> deletePlatformIcon(int id, String imageName) {

    return _deleteCollectionItemImage<Platform>(
      tableName: PlatformEntityData.table,
      imageName: imageName,
      imageField: PlatformEntityData.imageField,
      idField: PlatformEntityData.idField,
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
      imageField: StoreEntityData.imageField,
      id: id,
      idField: StoreEntityData.idField,
      findItemById: findStoreById,
    );

  }

  @override
  Future<Store?> renameStoreIcon(int id, String imageName, String newImageName) {

    return _renameCollectionItemImage<Store>(
      tableName: StoreEntityData.table,
      oldImageName: imageName,
      newImageName: newImageName,
      imageField: StoreEntityData.imageField,
      idField: StoreEntityData.idField,
      id: id,
      findItemById: findStoreById,
    );

  }

  @override
  Future<Store?> deleteStoreIcon(int id, String imageName) {

    return _deleteCollectionItemImage<Store>(
      tableName: StoreEntityData.table,
      imageName: imageName,
      imageField: StoreEntityData.imageField,
      idField: StoreEntityData.idField,
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
      imageField: SystemEntityData.imageField,
      idField: SystemEntityData.idField,
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
      imageField: SystemEntityData.imageField,
      idField: SystemEntityData.idField,
      id: id,
      findItemById: findSystemById,
    );

  }

  @override
  Future<System?> deleteSystemIcon(int id, String imageName) {

    return _deleteCollectionItemImage<System>(
      tableName: SystemEntityData.table,
      imageName: imageName,
      imageField: SystemEntityData.imageField,
      idField: SystemEntityData.idField,
      id: id,
      findItemById: findSystemById,
    );

  }
  //#endregion System
  //#endregion IMAGE

  //#region DOWNLOAD
  String? _getGameCoverURL(String? gameCoverName) {

    return gameCoverName != null?
        _iImageConnector.getURI(
          tableName: GameEntityData.table,
          imageFilename: gameCoverName,
        )
        : null;

  }

  String? _getDLCCoverURL(String? dlcCoverName) {

    return dlcCoverName != null?
        _iImageConnector.getURI(
          tableName: DLCEntityData.table,
          imageFilename: dlcCoverName,
        )
        : null;

  }

  String? _getPlatformIconURL(String? platformIconName) {

    return platformIconName != null?
        _iImageConnector.getURI(
          tableName: PlatformEntityData.table,
          imageFilename: platformIconName,
        )
        : null;

  }

  String? _getStoreIconURL(String? storeIconName) {

    return storeIconName != null?
        _iImageConnector.getURI(
          tableName: StoreEntityData.table,
          imageFilename: storeIconName,
        )
        : null;

  }

  String? _getSystemIconURL(String? systemIconName) {

    return systemIconName != null?
        _iImageConnector.getURI(
          tableName: SystemEntityData.table,
          imageFilename: systemIconName,
        )
        : null;

  }
  //#endregion DOWNLOAD

  //#region Dynamic Map to List
  // TODO move to mapper class
  List<Game> _dynamicToListGame(List<Map<String, Map<String, dynamic>>> results) {

    return GameEntity.fromDynamicMapList(results).map( (GameEntity gameEntity) {
      return Game.fromEntity(gameEntity, _getGameCoverURL(gameEntity.coverFilename));
    }).toList(growable: false);

  }

  List<GameFinish> _dynamicToListGameFinish(List<Map<String, Map<String, dynamic>>> results) {

    return GameFinishEntity.fromDynamicMapList(results).map( GameFinish.fromEntity ).toList(growable: false);

  }

  List<GameTimeLog> _dynamicToListTimeLog(List<Map<String, Map<String, dynamic>>> results) {

    return GameTimeLogEntity.fromDynamicMapList(results).map( GameTimeLog.fromEntity ).toList(growable: false);

  }

  List<GameWithLogs> _dynamicToListGamesWithLogs(List<Map<String, Map<String, dynamic>>> results) {

    return GameWithLogsEntity.fromDynamicMapList(results).map( (GameWithLogsEntity gameWithLogsEntity) {
      return GameWithLogs.fromEntity(gameWithLogsEntity, _getGameCoverURL(gameWithLogsEntity.game.coverFilename));
    }).toList(growable: false);

  }

  List<DLC> _dynamicToListDLC(List<Map<String, Map<String, dynamic>>> results) {

    return DLCEntity.fromDynamicMapList(results).map( (DLCEntity dlcEntity) {
      return DLC.fromEntity(dlcEntity, _getDLCCoverURL(dlcEntity.coverFilename));
    }).toList(growable: false);

  }

  List<DLCFinish> _dynamicToListDLCFinish(List<Map<String, Map<String, dynamic>>> results) {

    return DLCFinishEntity.fromDynamicMapList(results).map( DLCFinish.fromEntity ).toList(growable: false);

  }

  List<Platform> _dynamicToListPlatform(List<Map<String, Map<String, dynamic>>> results) {

    return PlatformEntity.fromDynamicMapList(results).map( (PlatformEntity platformEntity) {
      return Platform.fromEntity(platformEntity, _getPlatformIconURL(platformEntity.iconFilename));
    }).toList(growable: false);

  }

  List<Purchase> _dynamicToListPurchase(List<Map<String, Map<String, dynamic>>> results) {

    return PurchaseEntity.fromDynamicMapList(results).map( Purchase.fromEntity ).toList(growable: false);

  }

  List<Store> _dynamicToListStore(List<Map<String, Map<String, dynamic>>> results) {

    return StoreEntity.fromDynamicMapList(results).map( (StoreEntity storeEntity) {
      return Store.fromEntity(storeEntity, _getStoreIconURL(storeEntity.iconFilename));
    }).toList(growable: false);

  }

  List<System> _dynamicToListSystem(List<Map<String, Map<String, dynamic>>> results) {

    return SystemEntity.fromDynamicMapList(results).map( (SystemEntity systemEntity) {
      return System.fromEntity(systemEntity, _getSystemIconURL(systemEntity.iconFilename));
    }).toList(growable: false);

  }

  List<Tag> _dynamicToListGameTag(List<Map<String, Map<String, dynamic>>> results) {

    return GameTagEntity.fromDynamicMapList(results).map( Tag.fromEntity ).toList(growable: false);

  }

  List<PurchaseType> _dynamicToListPurchaseType(List<Map<String, Map<String, dynamic>>> results) {

    return PurchaseTypeEntity.fromDynamicMapList(results).map( PurchaseType.fromEntity ).toList(growable: false);

  }

  Game? _dynamicToSingleGame(List<Map<String, Map<String, dynamic>>> results) {

    Game? singleGame;

    if(results.isNotEmpty) {
      singleGame = _dynamicToListGame(results).first;
    }

    return singleGame;

  }

  DLC? _dynamicToSingleDLC(List<Map<String, Map<String, dynamic>>> results) {

    DLC? singleDLC;

    if(results.isNotEmpty) {
      singleDLC = _dynamicToListDLC(results).first;
    }

    return singleDLC;

  }

  Platform? _dynamicToSinglePlatform(List<Map<String, Map<String, dynamic>>> results) {

    Platform? singlePlatform;

    if(results.isNotEmpty) {
      singlePlatform = _dynamicToListPlatform(results).first;
    }

    return singlePlatform;

  }

  Purchase? _dynamicToSinglePurchase(List<Map<String, Map<String, dynamic>>> results) {

    Purchase? singlePurchase;

    if(results.isNotEmpty) {
      singlePurchase = _dynamicToListPurchase(results).first;
    }

    return singlePurchase;

  }

  Store? _dynamicToSingleStore(List<Map<String, Map<String, dynamic>>> results) {

    Store? singleStore;

    if(results.isNotEmpty) {
      singleStore = _dynamicToListStore(results).first;
    }

    return singleStore;

  }

  System? _dynamicToSingleSystem(List<Map<String, Map<String, dynamic>>> results) {

    System? singleSystem;

    if(results.isNotEmpty) {
      singleSystem = _dynamicToListSystem(results).first;
    }

    return singleSystem;

  }

  Tag? _dynamicToSingleGameTag(List<Map<String, Map<String, dynamic>>> results) {

    Tag? singleTag;

    if(results.isNotEmpty) {
      singleTag = _dynamicToListGameTag(results).first;
    }

    return singleTag;

  }

  PurchaseType? _dynamicToSinglePurchaseType(List<Map<String, Map<String, dynamic>>> results) {

    PurchaseType? singleType;

    if(results.isNotEmpty) {
      singleType = _dynamicToListPurchaseType(results).first;
    }

    return singleType;

  }
  //#endregion Dynamic Map to List

  //#region Utils
  Future<T?> _createCollectionItem<T extends CollectionItem>({required String tableName, required T newItem, required String idField, required Stream<T?> Function(int) findItemById}) async {

    final CollectionItemEntity itemEntity = newItem.toEntity();

    final int? id = await _iSQLConnector.create(
      tableName: tableName,
      insertFieldsAndValues: itemEntity.getCreateDynamicMap(),
      returningField: idField,
    ).asStream().map( (List<Map<String, Map<String, dynamic>>> results) => _dynamicToId(results, tableName, idField) ).first;

    if(id != null) {
      return findItemById(id).first;
    } else {
      return Future<T?>.value(null);
    }

  }

  Future<T?> _updateCollectionItem<T extends CollectionItem>({required String tableName, required Map<String, dynamic> fieldsAndValues, required String idField, required int id, required Stream<T?> Function(int) findItemById}) async {

    await _iSQLConnector.update(
      tableName: tableName,
      whereQuery: Query()
        ..addAnd(idField, id),
      setFieldsAndValues: fieldsAndValues,
    );

    return findItemById(id).first;

  }

  Future<T?> _uploadCollectionItemImage<T extends CollectionItem>({required String tableName, required String uploadImagePath, required String initialImageName, required String? oldImageName, required String imageField, required String idField, required int id, required Stream<T?> Function(int) findItemById}) async {

    if(oldImageName != null) {
      await _iImageConnector.delete(
        tableName: tableName,
        imageName: oldImageName,
      );
    }

    final String imageName = await _iImageConnector.set(
      imagePath: uploadImagePath,
      tableName: tableName,
      imageName: _getImageName(id, initialImageName),
    );

    return _updateCollectionItem<T>(
      tableName: tableName,
      fieldsAndValues: <String, dynamic> {
        imageField : imageName,
      },
      idField: idField,
      id: id,
      findItemById: findItemById,
    );

  }

  Future<T?> _renameCollectionItemImage<T extends CollectionItem>({required String tableName, required String oldImageName, required String newImageName, required String imageField, required String idField, required int id, required Stream<T?> Function(int) findItemById}) async {

    final String imageName = await _iImageConnector.rename(
      tableName: tableName,
      oldImageName: oldImageName,
      newImageName: _getImageName(id, newImageName),
    );

    return _updateCollectionItem<T>(
      tableName: tableName,
      fieldsAndValues: <String, dynamic> {
        imageField : imageName,
      },
      idField: idField,
      id: id,
      findItemById: findItemById,
    );

  }

  Future<T?> _deleteCollectionItemImage<T extends CollectionItem>({required String tableName, required String imageName, required String imageField, required String idField, required int id, required Stream<T?> Function(int) findItemById}) async {

    await _iImageConnector.delete(
      tableName: tableName,
      imageName: imageName,
    );

    return _updateCollectionItem<T>(
      tableName: tableName,
      fieldsAndValues: <String, dynamic> {
        imageField : null,
      },
      idField: idField,
      id: id,
      findItemById: findItemById,
    );

  }

  int? _dynamicToId(List<Map<String, Map<String, dynamic>>> results, String tableName, String idField) {
    int? id;

    if(results.isNotEmpty) {
      final Map<String, dynamic> map = CollectionItemEntity.combineMaps(results.first, tableName);
      id = map[idField] as int;
    }

    return id;
  }
  //#endregion Utils

  // TODO move somewhere else
  String _getImageName(int id, String imageName) {

    return id.toString() + '-' + imageName;

  }
}

// TODO move to mapper
const Map<GameView, String> allViewToTable = <GameView, String>{
  GameView.Main : 'All-Main',
  GameView.LastCreated : 'All-Last Created',
  GameView.Playing : 'All-Playing',
  GameView.NextUp : 'All-Next Up',
  GameView.LastPlayed : 'All-Last Played',
  GameView.LastFinished : 'All-Last Finished',
  GameView.Review : 'All-Year In Review',
};

const Map<GameView, String> ownedViewToTable = <GameView, String>{
  GameView.Main : 'Owned-Main',
  GameView.LastCreated : 'Owned-Last Created',
  GameView.Playing : 'Owned-Playing',
  GameView.NextUp : 'Owned-Next Up',
  GameView.LastPlayed : 'Owned-Last Played',
  GameView.LastFinished : 'Owned-Last Finished',
  GameView.Review : 'Owned-Year In Review',
};

const Map<GameView, String> romViewToTable = <GameView, String>{
  GameView.Main : 'Rom-Main',
  GameView.LastCreated : 'Rom-Last Created',
  GameView.Playing : 'Rom-Playing',
  GameView.NextUp : 'Rom-Next Up',
  GameView.LastPlayed : 'Rom-Last Played',
  GameView.LastFinished : 'Rom-Last Finished',
  GameView.Review : 'Rom-Year In Review',
};

const Map<DLCView, String> dlcViewToTable = <DLCView, String>{
  DLCView.Main : 'DLC-Main',
  DLCView.LastCreated : 'DLC-Last Created',
};

const Map<PlatformView, String> platformViewToTable = <PlatformView, String>{
  PlatformView.Main : 'Platform-Main',
  PlatformView.LastCreated : 'Platform-Last Created',
};

const Map<PurchaseView, String> purchaseViewToTable = <PurchaseView, String>{
  PurchaseView.Main : 'Purchase-Main',
  PurchaseView.LastCreated : 'Purchase-Last Created',
  PurchaseView.Pending : 'Purchase-Pending',
  PurchaseView.LastPurchased : 'Purchase-Last Purchased',
  PurchaseView.Review : 'Purchase-Year In Review',
};

const Map<StoreView, String> storeViewToTable = <StoreView, String>{
  StoreView.Main : 'Store-Main',
  StoreView.LastCreated : 'Store-Last Created',
};

const Map<SystemView, String> systemViewToTable = <SystemView, String>{
  SystemView.Main : 'System-Main',
  SystemView.LastCreated : 'System-Last Created',
};

const Map<TagView, String> tagViewToTable = <TagView, String>{
  TagView.Main : 'Tag-Main',
  TagView.LastCreated : 'Tag-Last Created',
};

const Map<TypeView, String> typeViewToTable = <TypeView, String>{
  TypeView.Main : 'Type-Main',
  TypeView.LastCreated : 'Type-Last Created',
};