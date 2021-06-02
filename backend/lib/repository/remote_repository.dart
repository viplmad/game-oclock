import 'package:backend/connector/connector.dart';

import 'package:backend/entity/entity.dart';

import 'package:backend/model/model.dart';

import 'icollection_repository.dart';


class RemoteRepository implements ICollectionRepository {
  RemoteRepository._(ISQLConnector iSQLConnector, IImageConnector iImageConnector) {
    _iSQLConnector = iSQLConnector;
    _iImageConnector = iImageConnector;
  }

  late ISQLConnector _iSQLConnector;
  late IImageConnector _iImageConnector;

  factory RemoteRepository(ISQLConnector iSQLConnector, IImageConnector iImageConnector) {
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
      newItem: game,
      tableName: GameEntityData.table,
      findItemById: findGameById,
    );

  }

  @override
  Future<dynamic> relateGamePlatform(int gameId, int platformId) {

    return _iSQLConnector.insertRecord(
      tableName: GamePlatformRelationData.table,
      fieldsAndValues: GamePlatformRelationData.getIdMap(gameId, platformId),
    );

  }

  @override
  Future<dynamic> relateGamePurchase(int gameId, int purchaseId) {

     return _iSQLConnector.insertRecord(
      tableName: GamePurchaseRelationData.table,
      fieldsAndValues: GamePurchaseRelationData.getIdMap(gameId, purchaseId),
    );

  }

  @override
  Future<dynamic> relateGameDLC(int gameId, int dlcId) {

    return _iSQLConnector.updateTable(
      tableName: DLCEntityData.table,
      whereFieldsAndValues: DLCEntityData.getIdMap(dlcId),
      setFieldsAndValues: <String, dynamic> {
        DLCEntityData.baseGameField : gameId,
      },
    );

  }

  @override
  Future<dynamic> relateGameTag(int gameId, int tagId) {

    return _iSQLConnector.insertRecord(
      tableName: GameTagRelationData.table,
      fieldsAndValues: GameTagRelationData.getIdMap(gameId, tagId),
    );

  }

  @override
  Future<dynamic> createGameFinish(int gameId, GameFinish finish) {

    return _iSQLConnector.insertRecord(
      tableName: GameFinishEntityData.table,
      fieldsAndValues: finish.toEntity().getCreateDynamicMap(gameId),
    );

  }

  @override
  Future<dynamic> createGameTimeLog(int gameId, GameTimeLog timeLog) {

    return _iSQLConnector.insertRecord(
      tableName: GameTimeLogEntityData.table,
      fieldsAndValues: timeLog.toEntity().getCreateDynamicMap(gameId),
    );

  }
  //#endregion Game

  //#region DLC
  @override
  Future<DLC?> createDLC(DLC dlc) {

    return _createCollectionItem<DLC>(
      newItem: dlc,
      tableName: DLCEntityData.table,
      findItemById: findDLCById,
    );

  }

  @override
  Future<dynamic> relateDLCPurchase(int dlcId, int purchaseId) {

    return _iSQLConnector.insertRecord(
      tableName: DLCPurchaseRelationData.table,
      fieldsAndValues: DLCPurchaseRelationData.getIdMap(dlcId, purchaseId),
    );

  }

  @override
  Future<dynamic> createDLCFinish(int dlcId, DLCFinish finish) {

    return _iSQLConnector.insertRecord(
      tableName: DLCFinishEntityData.table,
      fieldsAndValues: finish.toEntity().getCreateDynamicMap(dlcId),
    );

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<Platform?> createPlatform(Platform platform) {

    return _createCollectionItem<Platform>(
      newItem: platform,
      tableName: PlatformEntityData.table,
      findItemById: findPlatformById,
    );

  }

  @override
  Future<dynamic> relatePlatformSystem(int platformId, int systemId) {

    return _iSQLConnector.insertRecord(
      tableName: PlatformSystemRelationData.table,
      fieldsAndValues: PlatformSystemRelationData.getIdMap(platformId, systemId),
    );

  }
  //#endregion Platform

  //#region Purchase
  @override
  Future<Purchase?> createPurchase(Purchase purchase) {

    return _createCollectionItem<Purchase>(
      newItem: purchase,
      tableName: PurchaseEntityData.table,
      findItemById: findPurchaseById,
    );

  }

  @override
  Future<dynamic> relatePurchaseType(int purchaseId, int typeId) {

    return _iSQLConnector.insertRecord(
      tableName: PurchaseTypeRelationData.table,
      fieldsAndValues: PurchaseTypeRelationData.getIdMap(purchaseId, typeId),
    );

  }
  //#endregion Purchase

  //#region Store
  @override
  Future<Store?> createStore(Store store) {

    return _createCollectionItem<Store>(
      newItem: store,
      tableName: StoreEntityData.table,
      findItemById: findStoreById,
    );

  }

  @override
  Future<dynamic> relateStorePurchase(int storeId, int purchaseId) {

    return _iSQLConnector.updateTable(
      tableName: PurchaseEntityData.table,
      whereFieldsAndValues: PurchaseEntityData.getIdMap(purchaseId),
      setFieldsAndValues: <String, dynamic> {
        PurchaseEntityData.storeField : storeId,
      },
    );

  }
  //#endregion Store

  //#region System
  @override
  Future<System?> createSystem(System system) {

    return _createCollectionItem<System>(
      newItem: system,
      tableName: SystemEntityData.table,
      findItemById: findSystemById,
    );

  }
  //#endregion System

  //#region Tag
  @override
  Future<Tag?> createGameTag(Tag tag) {

    return _createCollectionItem<Tag>(
      newItem: tag,
      tableName: GameTagEntityData.table,
      findItemById: findGameTagById,
    );

  }
  //#endregion Tag

  //#region Type
  @override
  Future<PurchaseType?> createPurchaseType(PurchaseType type) {

    return _createCollectionItem<PurchaseType>(
      newItem: type,
      tableName: PurchaseTypeEntityData.table,
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

    return _iSQLConnector.readTable(
      tableName: allViewToTable[gameView]!,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllGamesWithYearView(GameView gameView, int year, [int? limit]) {

    // TODO read function or migrate sqlfunction to dart
    return _iSQLConnector.readTable(
      tableName: allViewToTable[gameView]!,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllOwnedGamesWithView(GameView gameView, [int? limit]) {

    return _iSQLConnector.readTable(
      tableName: ownedViewToTable[gameView]!,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllOwnedGamesWithYearView(GameView gameView, int year, [int? limit]) {

    // TODO read function or migrate sqlfunction to dart
    return _iSQLConnector.readTable(
      tableName: ownedViewToTable[gameView]!,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllRomGamesWithView(GameView gameView, [int? limit]) {

    return _iSQLConnector.readTable(
      tableName: romViewToTable[gameView]!,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> findAllRomGamesWithYearView(GameView gameView, int year, [int? limit]) {

    // TODO read function or migrate sqlfunction to dart
    return _iSQLConnector.readTable(
      tableName: romViewToTable[gameView]!,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<Game?> findGameById(int id) {

    return _iSQLConnector.readTable(
      tableName: GameEntityData.readTable,
      selectFieldsAndTypes: GameEntityData.fields,
      whereFieldsAndValues: GameEntityData.getIdMap(id),
    ).asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<Platform>> findAllPlatformsFromGame(int id) {

    return _iSQLConnector.readRelation(
      tableName: PlatformEntityData.table,
      relationTable: GamePlatformRelationData.table,
      idField: idField,
      joinField: PlatformEntityData.relationField,
      whereFieldsAndValues: <String, dynamic>{
        GameEntityData.relationField : id,
      },
      selectFieldsAndTypes: PlatformEntityData.fields,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesFromGame(int id) {

    return _iSQLConnector.readRelation(
      tableName: PurchaseEntityData.table,
      relationTable: GamePurchaseRelationData.table,
      idField: idField,
      joinField: PurchaseEntityData.relationField,
      whereFieldsAndValues: <String, dynamic>{
        GameEntityData.relationField : id,
      },
      selectFieldsAndTypes: PurchaseEntityData.fields,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<DLC>> findAllDLCsFromGame(int id) {

    return _iSQLConnector.readWeakRelation(
      primaryTable: GameEntityData.table,
      subordinateTable: DLCEntityData.table,
      idField: idField,
      joinField: DLCEntityData.baseGameField,
      whereFieldsAndValues: <String, dynamic>{
        DLCEntityData.baseGameField : id,
      },
      primaryResults: false,
      selectFieldsAndTypes: DLCEntityData.fields,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<Tag>> findAllGameTagsFromGame(int id) {

    return _iSQLConnector.readRelation(
      tableName: GameTagEntityData.table,
      relationTable: GameTagRelationData.table,
      idField: idField,
      joinField: GameTagEntityData.relationField,
      whereFieldsAndValues: <String, dynamic>{
        GameEntityData.relationField : id,
      },
      selectFieldsAndTypes: GameTagEntityData.fields,
    ).asStream().map( _dynamicToListGameTag );

  }

  @override
  Stream<List<GameFinish>> findAllGameFinishFromGame(int id) {

    return _iSQLConnector.readTable(
      tableName: GameFinishEntityData.readTable,
      selectFieldsAndTypes: GameFinishEntityData.fields,
      whereFieldsAndValues: <String, dynamic>{
        GameEntityData.relationField : id,
      },
    ).asStream().map( _dynamicToListGameFinish );

  }

  @override
  Stream<List<GameTimeLog>> findAllGameTimeLogsFromGame(int id) {

    return _iSQLConnector.readTable(
      tableName: GameTimeLogEntityData.readTable,
      selectFieldsAndTypes: GameTimeLogEntityData.fields,
      whereFieldsAndValues: <String, dynamic>{
        GameEntityData.relationField : id,
      },
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

    return _iSQLConnector.readTable(
      selectFieldsAndTypes: DLCEntityData.fields,
      tableName: dlcViewToTable[dlcView]!,
      limit: limit,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<DLC?> findDLCById(int id) {

    return _iSQLConnector.readTable(
      selectFieldsAndTypes: DLCEntityData.fields,
      tableName: DLCEntityData.readTable,
      whereFieldsAndValues: DLCEntityData.getIdMap(id),
    ).asStream().map( _dynamicToSingleDLC );

  }

  @override
  Stream<Game?> findBaseGameFromDLC(int dlcId) {

    return _iSQLConnector.readWeakRelation(
      primaryTable: GameEntityData.table,
      subordinateTable: DLCEntityData.table,
      idField: idField,
      joinField: DLCEntityData.baseGameField,
      whereFieldsAndValues: <String, dynamic>{
        idField : dlcId,
      },
      primaryResults: true,
      selectFieldsAndTypes: GameEntityData.fields,
    ).asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesFromDLC(int id) {

    return _iSQLConnector.readRelation(
      tableName: PurchaseEntityData.table,
      relationTable: DLCPurchaseRelationData.table,
      idField: idField,
      joinField: PurchaseEntityData.relationField,
      whereFieldsAndValues: <String, dynamic>{
        DLCEntityData.relationField : id,
      },
      selectFieldsAndTypes: PurchaseEntityData.fields,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<DLCFinish>> findAllDLCFinishFromDLC(int id) {

    return _iSQLConnector.readTable(
      tableName: DLCFinishEntityData.readTable,
      selectFieldsAndTypes: DLCFinishEntityData.fields,
      whereFieldsAndValues: <String, dynamic>{
        DLCEntityData.relationField : id,
      },
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

    return _iSQLConnector.readTable(
      selectFieldsAndTypes: PlatformEntityData.fields,
      tableName: platformViewToTable[platformView]!,
      limit: limit,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<Platform?> findPlatformById(int id) {

    return _iSQLConnector.readTable(
      selectFieldsAndTypes: PlatformEntityData.fields,
      tableName: PlatformEntityData.table,
      whereFieldsAndValues: <String, int>{
        idField : id,
      },
    ).asStream().map( _dynamicToSinglePlatform );

  }

  @override
  Stream<List<Game>> findAllGamesFromPlatform(int id) {

    return _iSQLConnector.readRelation(
      tableName: GameEntityData.table,
      relationTable: GamePlatformRelationData.table,
      idField: idField,
      joinField: GameEntityData.relationField,
      whereFieldsAndValues: <String, dynamic>{
        PlatformEntityData.relationField : id,
      },
      selectFieldsAndTypes: GameEntityData.fields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<System>> findAllSystemsFromPlatform(int id) {

    return _iSQLConnector.readRelation(
      tableName: SystemEntityData.table,
      relationTable: PlatformSystemRelationData.table,
      idField: idField,
      joinField: SystemEntityData.relationField,
      whereFieldsAndValues: <String, dynamic>{
        PlatformEntityData.relationField : id,
      },
      selectFieldsAndTypes: SystemEntityData.fields,
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

    return _iSQLConnector.readTable(
      tableName: purchaseViewToTable[purchaseView]!,
      selectFieldsAndTypes: PurchaseEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesWithYearView(PurchaseView purchaseView, int year, [int? limit]) {

    // TODO read function or migrate sqlfunction to dart
    return _iSQLConnector.readTable(
      tableName: purchaseViewToTable[purchaseView]!,
      selectFieldsAndTypes: PurchaseEntityData.fields,
      limit: limit,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<Purchase?> findPurchaseById(int id) {

    return _iSQLConnector.readTable(
      tableName: PurchaseEntityData.table,
      selectFieldsAndTypes: PurchaseEntityData.fields,
      whereFieldsAndValues: <String, int>{
        idField : id,
      },
    ).asStream().map( _dynamicToSinglePurchase );

  }

  @override
  Stream<Store?> findStoreFromPurchase(int id) {

    return _iSQLConnector.readWeakRelation(
      primaryTable: StoreEntityData.table,
      subordinateTable: PurchaseEntityData.table,
      idField: idField,
      joinField: PurchaseEntityData.storeField,
      whereFieldsAndValues: <String, dynamic>{
        idField : id,
      },
      primaryResults: true,
      selectFieldsAndTypes: StoreEntityData.fields,
    ).asStream().map( _dynamicToSingleStore );

  }

  @override
  Stream<List<Game>> findAllGamesFromPurchase(int id) {

    return _iSQLConnector.readRelation(
      tableName: GameEntityData.table,
      relationTable: GamePurchaseRelationData.table,
      idField: idField,
      joinField: GameEntityData.relationField,
      whereFieldsAndValues: <String, dynamic>{
        PurchaseEntityData.relationField : id,
      },
      selectFieldsAndTypes: GameEntityData.fields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<DLC>> findAllDLCsFromPurchase(int id) {

    return _iSQLConnector.readRelation(
      tableName: DLCEntityData.table,
      relationTable: DLCPurchaseRelationData.table,
      idField: idField,
      joinField: DLCEntityData.relationField,
      whereFieldsAndValues: <String, dynamic>{
        PurchaseEntityData.relationField : id,
      },
      selectFieldsAndTypes: DLCEntityData.fields,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<PurchaseType>> findAllPurchaseTypesFromPurchase(int id) {

    return _iSQLConnector.readRelation(
      tableName: PurchaseTypeEntityData.table,
      relationTable: PurchaseTypeRelationData.table,
      idField: idField,
      joinField: PurchaseTypeEntityData.relationField,
      whereFieldsAndValues: <String, dynamic>{
        PurchaseEntityData.relationField : id,
      },
      selectFieldsAndTypes: PurchaseTypeEntityData.fields,
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

    return _iSQLConnector.readTable(
      selectFieldsAndTypes: StoreEntityData.fields,
      tableName: storeViewToTable[storeView]!,
      limit: limit,
    ).asStream().map( _dynamicToListStore );
  }

  @override
  Stream<Store?> findStoreById(int id) {

    return _iSQLConnector.readTable(
      selectFieldsAndTypes: StoreEntityData.fields,
      tableName: StoreEntityData.table,
      whereFieldsAndValues: <String, int>{
        idField : id,
      },
    ).asStream().map( _dynamicToSingleStore );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesFromStore(int storeId) {

    return _iSQLConnector.readWeakRelation(
      primaryTable: StoreEntityData.table,
      subordinateTable: PurchaseEntityData.table,
      idField: idField,
      joinField: PurchaseEntityData.storeField,
      whereFieldsAndValues: <String, dynamic>{
        PurchaseEntityData.storeField : storeId,
      },
      primaryResults: false,
      selectFieldsAndTypes: PurchaseEntityData.fields,
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

    return _iSQLConnector.readTable(
      selectFieldsAndTypes: SystemEntityData.fields,
      tableName: systemViewToTable[systemView]!,
      limit: limit,
    ).asStream().map( _dynamicToListSystem );
  }

  @override
  Stream<System?> findSystemById(int id) {

    return _iSQLConnector.readTable(
      selectFieldsAndTypes: SystemEntityData.fields,
      tableName: SystemEntityData.table,
      whereFieldsAndValues: <String, int>{
        idField : id,
      },
    ).asStream().map( _dynamicToSingleSystem );

  }

  @override
  Stream<List<Platform>> findAllPlatformsFromSystem(int id) {

    return _iSQLConnector.readRelation(
      tableName: PlatformEntityData.table,
      relationTable: PlatformSystemRelationData.table,
      idField: idField,
      joinField: PlatformEntityData.relationField,
      whereFieldsAndValues: <String, dynamic>{
        SystemEntityData.relationField : id,
      },
      selectFieldsAndTypes: PlatformEntityData.fields,
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

    return _iSQLConnector.readTable(
      selectFieldsAndTypes: GameTagEntityData.fields,
      tableName: tagViewToTable[tagView]!,
      limit: limit,
    ).asStream().map( _dynamicToListGameTag );

  }

  @override
  Stream<Tag?> findGameTagById(int id) {

    return _iSQLConnector.readTable(
      selectFieldsAndTypes: GameTagEntityData.fields,
      tableName: GameTagEntityData.table,
      whereFieldsAndValues: <String, int>{
        idField : id,
      },
    ).asStream().map( _dynamicToSingleGameTag );

  }

  @override
  Stream<List<Game>> findAllGamesFromGameTag(int id) {

    return _iSQLConnector.readRelation(
      tableName: GameEntityData.table,
      relationTable: GameTagRelationData.table,
      idField: idField,
      joinField: GameEntityData.relationField,
      whereFieldsAndValues: <String, dynamic>{
        GameTagEntityData.relationField : id,
      },
      selectFieldsAndTypes: GameEntityData.fields,
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

    return _iSQLConnector.readTable(
      selectFieldsAndTypes: PurchaseTypeEntityData.fields,
      tableName: typeViewToTable[typeView]!,
      limit: limit,
    ).asStream().map( _dynamicToListPurchaseType );

  }

  @override
  Stream<PurchaseType?> findPurchaseTypeById(int id) {

    return _iSQLConnector.readTable(
      selectFieldsAndTypes: PurchaseTypeEntityData.fields,
      tableName: PurchaseTypeEntityData.table,
      whereFieldsAndValues: <String, int>{
        idField : id,
      },
    ).asStream().map( _dynamicToSinglePurchaseType );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesFromPurchaseType(int id) {

    return _iSQLConnector.readRelation(
      tableName: PurchaseEntityData.table,
      relationTable: PurchaseTypeRelationData.table,
      idField: idField,
      joinField: PurchaseEntityData.relationField,
      whereFieldsAndValues: <String, dynamic>{
        PurchaseTypeEntityData.relationField : id,
      },
      selectFieldsAndTypes: PurchaseEntityData.fields,
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
      id: game.id,
      fieldsAndValues: fieldsAndValues,
      tableName: GameEntityData.table,
      findItemById: findGameById,
    );

  }

    //DLC
  @override
  Future<DLC?> updateDLC(DLC dlc, DLC updatedDlc, DLCUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = dlc.toEntity().getUpdateDynamicMap(updatedDlc.toEntity(), updateProperties);

    return _updateCollectionItem<DLC>(
      id: dlc.id,
      fieldsAndValues: fieldsAndValues,
      tableName: DLCEntityData.table,
      findItemById: findDLCById,
    );

  }

    //Platform
  @override
  Future<Platform?> updatePlatform(Platform platform, Platform updatedPlatform, PlatformUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = platform.toEntity().getUpdateDynamicMap(updatedPlatform.toEntity(), updateProperties);

    return _updateCollectionItem<Platform>(
      id: platform.id,
      fieldsAndValues: fieldsAndValues,
      tableName: PlatformEntityData.table,
      findItemById: findPlatformById,
    );

  }

    //Purchase
  @override
  Future<Purchase?> updatePurchase(Purchase purchase, Purchase updatedPurchase, PurchaseUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = purchase.toEntity().getUpdateDynamicMap(updatedPurchase.toEntity(), updateProperties);

    return _updateCollectionItem<Purchase>(
      id: purchase.id,
      fieldsAndValues: fieldsAndValues,
      tableName: PurchaseEntityData.table,
      findItemById: findPurchaseById,
    );

  }

    //Store
  @override
  Future<Store?> updateStore(Store store, Store updatedStore, StoreUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = store.toEntity().getUpdateDynamicMap(updatedStore.toEntity(), updateProperties);

    return _updateCollectionItem<Store>(
      id: store.id,
      fieldsAndValues: fieldsAndValues,
      tableName: StoreEntityData.table,
      findItemById: findStoreById,
    );

  }

    //System
  @override
  Future<System?> updateSystem(System system, System updatedSystem, SystemUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = system.toEntity().getUpdateDynamicMap(updatedSystem.toEntity(), updateProperties);

    return _updateCollectionItem<System>(
      id: system.id,
      fieldsAndValues: fieldsAndValues,
      tableName: SystemEntityData.table,
      findItemById: findSystemById,
    );

  }

    //Tag
  @override
  Future<Tag?> updateGameTag(Tag tag, Tag updatedTag, GameTagUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = tag.toEntity().getUpdateDynamicMap(updatedTag.toEntity(), updateProperties);

    return _updateCollectionItem<Tag>(
      id: tag.id,
      fieldsAndValues: fieldsAndValues,
      tableName: GameTagEntityData.table,
      findItemById: findGameTagById,
    );

  }

    //Type
  @override
  Future<PurchaseType?> updatePurchaseType(PurchaseType type, PurchaseType updatedType, PurchaseTypeUpdateProperties updateProperties) {

    final Map<String, dynamic> fieldsAndValues = type.toEntity().getUpdateDynamicMap(updatedType.toEntity(), updateProperties);

    return _updateCollectionItem<PurchaseType>(
      id: type.id,
      fieldsAndValues: fieldsAndValues,
      tableName: PurchaseTypeEntityData.table,
      findItemById: findPurchaseTypeById,
    );

  }
  //#endregion UPDATE


  //#region DELETE
  //#region Game
  @override
  Future<dynamic> deleteGameById(int id) {

    return _iSQLConnector.deleteRecord(
      tableName: GameEntityData.table,
      whereFieldsAndValues: GameEntityData.getIdMap(id),
    );

  }

  @override
  Future<dynamic> unrelateGamePlatform(int gameId, int platformId) {

    return _iSQLConnector.deleteRecord(
      tableName: GamePlatformRelationData.table,
      whereFieldsAndValues: GamePlatformRelationData.getIdMap(gameId, platformId),
    );

  }

  @override
  Future<dynamic> unrelateGamePurchase(int gameId, int purchaseId) {

    return _iSQLConnector.deleteRecord(
      tableName: GamePurchaseRelationData.table,
      whereFieldsAndValues: GamePurchaseRelationData.getIdMap(gameId, purchaseId),
    );

  }

  @override
  Future<dynamic> unrelateGameDLC(int dlcId) {

    return _iSQLConnector.updateTable(
      tableName: DLCEntityData.table,
      whereFieldsAndValues: DLCEntityData.getIdMap(dlcId),
      setFieldsAndValues: <String, dynamic> {
        DLCEntityData.baseGameField : null,
      },
    );

  }

  @override
  Future<dynamic> unrelateGameTag(int gameId, int tagId) {

    return _iSQLConnector.deleteRecord(
      tableName: GameTagRelationData.table,
      whereFieldsAndValues: GameTagRelationData.getIdMap(gameId, tagId),
    );

  }

  @override
  Future<dynamic> deleteGameFinishById(int gameId, DateTime date) {

    return _iSQLConnector.deleteRecord(
      tableName: GameFinishEntityData.table,
      whereFieldsAndValues: GameFinishEntityData.getIdMap(gameId, date),
    );

  }

  @override
  Future<dynamic> deleteGameTimeLogById(int gameId, DateTime dateTime) {

    return _iSQLConnector.deleteRecord(
      tableName: GameTimeLogEntityData.table,
      whereFieldsAndValues: GameTimeLogEntityData.getIdMap(gameId, dateTime),
    );

  }
  //#endregion Game

  //#region DLC
  @override
  Future<dynamic> deleteDLCById(int id) {

    return _iSQLConnector.deleteRecord(
      tableName: DLCEntityData.table,
      whereFieldsAndValues: DLCEntityData.getIdMap(id),
    );

  }

  @override
  Future<dynamic> unrelateDLCPurchase(int dlcId, int purchaseId) {

    return _iSQLConnector.deleteRecord(
      tableName: DLCPurchaseRelationData.table,
      whereFieldsAndValues: DLCPurchaseRelationData.getIdMap(dlcId, purchaseId),
    );

  }

  @override
  Future<dynamic> deleteDLCFinishById(int dlcId, DateTime date) {

    return _iSQLConnector.deleteRecord(
      tableName: DLCFinishEntityData.table,
      whereFieldsAndValues: DLCFinishEntityData.getIdMap(dlcId, date),
    );

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<dynamic> deletePlatformById(int id) {

    return _iSQLConnector.deleteRecord(
      tableName: PlatformEntityData.table,
      whereFieldsAndValues: PlatformEntityData.getIdMap(id),
    );

  }

  @override
  Future<dynamic> unrelatePlatformSystem(int platformId, int systemId) {

    return _iSQLConnector.deleteRecord(
      tableName: PlatformSystemRelationData.table,
      whereFieldsAndValues: PlatformSystemRelationData.getIdMap(platformId, systemId),
    );
  }
  //#endregion Platform

  //#region Purchase
  @override
  Future<dynamic> deletePurchaseById(int id) {

    return _iSQLConnector.deleteRecord(
      tableName: PurchaseEntityData.table,
      whereFieldsAndValues: PurchaseEntityData.getIdMap(id),
    );

  }

  @override
  Future<dynamic> unrelatePurchaseType(int purchaseId, int typeId) {

    return _iSQLConnector.deleteRecord(
      tableName: PurchaseTypeRelationData.table,
      whereFieldsAndValues: PurchaseTypeRelationData.getIdMap(purchaseId, typeId),
    );

  }
  //#endregion Purchase

  //#region Store
  @override
  Future<dynamic> deleteStoreById(int id) {

    return _iSQLConnector.deleteRecord(
      tableName: StoreEntityData.table,
      whereFieldsAndValues: StoreEntityData.getIdMap(id),
    );

  }

  @override
  Future<dynamic> unrelateStorePurchase(int purchaseId) {

    return _iSQLConnector.updateTable(
      tableName: PurchaseEntityData.table,
      whereFieldsAndValues: PurchaseEntityData.getIdMap(purchaseId),
      setFieldsAndValues: <String, dynamic> {
        PurchaseEntityData.storeField : null,
      },
    );

  }
  //#endregion Store

  //#region System
  @override
  Future<dynamic> deleteSystemById(int id) {

    return _iSQLConnector.deleteRecord(
      tableName: SystemEntityData.table,
      whereFieldsAndValues: SystemEntityData.getIdMap(id),
    );

  }
  //#endregion System

  //#region Tag
  @override
  Future<dynamic> deleteGameTagById(int id) {

    return _iSQLConnector.deleteRecord(
      tableName: GameTagEntityData.table,
      whereFieldsAndValues: GameTagEntityData.getIdMap(id),
    );

  }
  //#endregion Tag

  //#region Type
  @override
  Future<dynamic> deletePurchaseTypeById(int id) {

    return _iSQLConnector.deleteRecord(
      tableName: PurchaseTypeEntityData.table,
      whereFieldsAndValues: PurchaseTypeEntityData.getIdMap(id),
    );

  }
  //#endregion Type
  //#endregion DELETE


  //#region SEARCH
  @override
  Stream<List<Game>> findAllGamesByName(String name, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: GameEntityData.table,
      searchField: GameEntityData.searchField,
      query: name,
      selectFieldsAndTypes: GameEntityData.fields,
      limit: maxResults,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<DLC>> findAllDLCsByName(String name, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: DLCEntityData.table,
      searchField: DLCEntityData.searchField,
      query: name,
      selectFieldsAndTypes: DLCEntityData.fields,
      limit: maxResults,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<Platform>> findAllPlatformsByName(String name, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: PlatformEntityData.table,
      searchField: PlatformEntityData.searchField,
      query: name,
      selectFieldsAndTypes: PlatformEntityData.fields,
      limit: maxResults,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<Purchase>> findAllPurchasesByDescription(String description, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: PurchaseEntityData.table,
      searchField: PurchaseEntityData.searchField,
      query: description,
      selectFieldsAndTypes: PurchaseEntityData.fields,
      limit: maxResults,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<Store>> findAllStoresByName(String name, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: StoreEntityData.table,
      searchField: StoreEntityData.searchField,
      query: name,
      selectFieldsAndTypes: StoreEntityData.fields,
      limit: maxResults,
    ).asStream().map( _dynamicToListStore );

  }

  @override
  Stream<List<System>> findAllSystemsByName(String name, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: SystemEntityData.table,
      searchField: SystemEntityData.searchField,
      query: name,
      selectFieldsAndTypes: SystemEntityData.fields,
      limit: maxResults,
    ).asStream().map( _dynamicToListSystem );

  }

  @override
  Stream<List<Tag>> findAllGameTagsByName(String name, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: GameTagEntityData.table,
      searchField: GameTagEntityData.searchField,
      query: name,
      selectFieldsAndTypes: GameTagEntityData.fields,
      limit: maxResults,
    ).asStream().map( _dynamicToListGameTag );

  }

  @override
  Stream<List<PurchaseType>> findAllPurchaseTypesByName(String name, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: PurchaseTypeEntityData.table,
      searchField: PurchaseTypeEntityData.searchField,
      query: name,
      selectFieldsAndTypes: PurchaseTypeEntityData.fields,
      limit: maxResults,
    ).asStream().map( _dynamicToListPurchaseType );
  }
  //#endregion SEARCH

  @override
  Stream<List<GameWithLogs>> findAllGamesWithTimeLogsByYear(int year) {

    // Select * From "GameLog" log Left Join "Game" g On g."ID" = log."Game_ID" Where date_part('year', log."DateTime") = 2021 Order by g."ID"
    return _iSQLConnector.readJoinTable(
      leftTable: GameTimeLogEntityData.table,
      rightTable: GameEntityData.table,
      leftTableIdField: GameEntityData.relationField,
      rightTableIdField: idField,
      leftSelectFields: GameTimeLogEntityData.fields,
      rightSelectFields: GameEntityData.fields,
      where: "date_part(\'year\', \"DateTime\") = $year",
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
      id: id,
      uploadImagePath: uploadImagePath,
      initialImageName: 'header',
      oldImageName: oldImageName,
      tableName: GameEntityData.table,
      imageField: GameEntityData.imageField,
      findItemById: findGameById,
    );

  }

  @override
  Future<Game?> renameGameCover(int id, String imageName, String newImageName) {

    return _renameCollectionItemImage<Game>(
      id: id,
      oldImageName: imageName,
      newImageName: newImageName,
      tableName: GameEntityData.table,
      imageField: GameEntityData.imageField,
      findItemById: findGameById,
    );

  }

  @override
  Future<Game?> deleteGameCover(int id, String imageName) {

    return _deleteCollectionItemImage<Game>(
      id: id,
      imageName: imageName,
      tableName: GameEntityData.table,
      imageField: GameEntityData.imageField,
      findItemById: findGameById,
    );

  }
  //#endregion Game

  //#region DLC
  @override
  Future<DLC?> uploadDLCCover(int id, String uploadImagePath, [String? oldImageName]) {

    return _uploadCollectionItemImage<DLC>(
      id: id,
      uploadImagePath: uploadImagePath,
      initialImageName: 'header',
      oldImageName: oldImageName,
      tableName: DLCEntityData.table,
      imageField: DLCEntityData.imageField,
      findItemById: findDLCById,
    );

  }

  @override
  Future<DLC?> renameDLCCover(int id, String imageName, String newImageName) {

    return _renameCollectionItemImage<DLC>(
      id: id,
      oldImageName: imageName,
      newImageName: newImageName,
      tableName: DLCEntityData.table,
      imageField: DLCEntityData.imageField,
      findItemById: findDLCById,
    );

  }

  @override
  Future<DLC?> deleteDLCCover(int id, String imageName) {

    return _deleteCollectionItemImage<DLC>(
      id: id,
      imageName: imageName,
      tableName: DLCEntityData.table,
      imageField: DLCEntityData.imageField,
      findItemById: findDLCById,
    );

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<Platform?> uploadPlatformIcon(int id, String uploadImagePath, [String? oldImageName]) {

    return _uploadCollectionItemImage<Platform>(
      id: id,
      uploadImagePath: uploadImagePath,
      initialImageName: 'icon',
      oldImageName: oldImageName,
      tableName: PlatformEntityData.table,
      imageField: PlatformEntityData.imageField,
      findItemById: findPlatformById,
    );

  }

  @override
  Future<Platform?> renamePlatformIcon(int id, String imageName, String newImageName) {

    return _renameCollectionItemImage<Platform>(
      id: id,
      oldImageName: imageName,
      newImageName: newImageName,
      tableName: PlatformEntityData.table,
      imageField: PlatformEntityData.imageField,
      findItemById: findPlatformById,
    );

  }


  @override
  Future<Platform?> deletePlatformIcon(int id, String imageName) {

    return _deleteCollectionItemImage<Platform>(
      id: id,
      imageName: imageName,
      tableName: PlatformEntityData.table,
      imageField: PlatformEntityData.imageField,
      findItemById: findPlatformById,
    );

  }
  //#endregion Platform

  //#region Store
  @override
  Future<Store?> uploadStoreIcon(int id, String uploadImagePath, [String? oldImageName]) {

    return _uploadCollectionItemImage<Store>(
      id: id,
      uploadImagePath: uploadImagePath,
      initialImageName: 'icon',
      oldImageName: oldImageName,
      tableName: StoreEntityData.table,
      imageField: StoreEntityData.imageField,
      findItemById: findStoreById,
    );

  }

  @override
  Future<Store?> renameStoreIcon(int id, String imageName, String newImageName) {

    return _renameCollectionItemImage<Store>(
      id: id,
      oldImageName: imageName,
      newImageName: newImageName,
      tableName: StoreEntityData.table,
      imageField: StoreEntityData.imageField,
      findItemById: findStoreById,
    );

  }

  @override
  Future<Store?> deleteStoreIcon(int id, String imageName) {

    return _deleteCollectionItemImage<Store>(
      id: id,
      imageName: imageName,
      tableName: StoreEntityData.table,
      imageField: StoreEntityData.imageField,
      findItemById: findStoreById,
    );

  }
  //#region Store

  //#region System
  @override
  Future<System?> uploadSystemIcon(int id, String uploadImagePath, [String? oldImageName]) {

    return _uploadCollectionItemImage<System>(
      id: id,
      uploadImagePath: uploadImagePath,
      initialImageName: 'icon',
      oldImageName: oldImageName,
      tableName: SystemEntityData.table,
      imageField: SystemEntityData.imageField,
      findItemById: findSystemById,
    );

  }

  @override
  Future<System?> renameSystemIcon(int id, String imageName, String newImageName) {

    return _renameCollectionItemImage<System>(
      id: id,
      oldImageName: imageName,
      newImageName: newImageName,
      tableName: SystemEntityData.table,
      imageField: SystemEntityData.imageField,
      findItemById: findSystemById,
    );

  }

  @override
  Future<System?> deleteSystemIcon(int id, String imageName) {

    return _deleteCollectionItemImage<System>(
      id: id,
      imageName: imageName,
      tableName: SystemEntityData.table,
      imageField: SystemEntityData.imageField,
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
  Future<T?> _createCollectionItem<T extends CollectionItem>({required T newItem, required String tableName, required Stream<T?> Function(int) findItemById}) async {

    final CollectionItemEntity itemEntity = newItem.toEntity();

    final int? id = await _iSQLConnector.insertRecord(
      tableName: tableName,
      fieldsAndValues: itemEntity.getCreateDynamicMap(),
      idField: idField,
    ).asStream().map( (List<Map<String, Map<String, dynamic>>> results) => _dynamicToId(results, tableName, idField) ).first;

    if(id != null) {
      return findItemById(id).first;
    } else {
      return Future<T?>.value(null);
    }

  }

  Future<T?> _updateCollectionItem<T extends CollectionItem>({required int id, required Map<String, dynamic> fieldsAndValues, required String tableName, required Stream<T?> Function(int) findItemById}) async {

    await _iSQLConnector.updateTable(
      tableName: tableName,
      whereFieldsAndValues: <String, dynamic>{
        idField : id,
      },
      setFieldsAndValues: fieldsAndValues,
    );

    return findItemById(id).first;

  }

  Future<T?> _uploadCollectionItemImage<T extends CollectionItem>({required int id, required String uploadImagePath, required String initialImageName, required String? oldImageName, required String tableName, required String imageField, required Stream<T?> Function(int) findItemById}) async {

    if(oldImageName != null) {
      await _iImageConnector.deleteImage(
        tableName: tableName,
        imageName: oldImageName,
      );
    }

    final String imageName = await _iImageConnector.setImage(
      imagePath: uploadImagePath,
      tableName: tableName,
      imageName: _getImageName(id, initialImageName),
    );

    return _updateCollectionItem<T>(
      id: id,
      fieldsAndValues: <String, dynamic> {
        imageField : imageName,
      },
      tableName: tableName,
      findItemById: findItemById,
    );

  }

  Future<T?> _renameCollectionItemImage<T extends CollectionItem>({required int id, required String oldImageName, required String newImageName, required String tableName, required String imageField, required Stream<T?> Function(int) findItemById}) async {

    final String imageName = await _iImageConnector.renameImage(
      tableName: tableName,
      oldImageName: oldImageName,
      newImageName: _getImageName(id, newImageName),
    );

    return _updateCollectionItem<T>(
      id: id,
      fieldsAndValues: <String, dynamic> {
        imageField : imageName,
      },
      tableName: tableName,
      findItemById: findItemById,
    );

  }

  Future<T?> _deleteCollectionItemImage<T extends CollectionItem>({required int id, required String imageName, required String tableName, required String imageField, required Stream<T?> Function(int) findItemById}) async {

    await _iImageConnector.deleteImage(
      tableName: tableName,
      imageName: imageName,
    );

    return _updateCollectionItem<T>(
      id: id,
      fieldsAndValues: <String, dynamic> {
        imageField : null,
      },
      tableName: tableName,
      findItemById: findItemById,
    );

  }

  int? _dynamicToId(List<Map<String, Map<String, dynamic>>> results, String tableName, String tableIdField) {
    int? id;

    if(results.isNotEmpty) {
      final Map<String, dynamic> map = CollectionItemEntity.combineMaps(results.first, tableName);
      id = map[tableIdField] as int;
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