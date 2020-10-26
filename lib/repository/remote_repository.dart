import 'package:game_collection/connector/item/sql/isql_connector.dart';
import 'package:game_collection/connector/image/iimage_connector.dart';

import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/model/model.dart';

import 'icollection_repository.dart';


class RemoteRepository implements ICollectionRepository {
  RemoteRepository._(ISQLConnector iSQLConnector, IImageConnector iImageConnector) {
    _iSQLConnector = iSQLConnector;
    _iImageConnector = iImageConnector;
  }

  ISQLConnector _iSQLConnector;
  IImageConnector _iImageConnector;

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
  Future<Game> createGame(String name, String edition) {

    return _iSQLConnector.insertRecord(
      tableName: gameTable,
      fieldAndValues: <String, dynamic> {
        game_nameField : name,
        game_editionField : edition,
      },
      returningFields: gameFields,
    ).asStream().map( _dynamicToSingleGame ).first;

  }

  @override
  Future<dynamic> relateGamePlatform(int gameId, int platformId) {

    return _iSQLConnector.insertRelation(
      leftTableName: gameTable,
      rightTableName: platformTable,
      leftTableId: gameId,
      rightTableId: platformId,
    );

  }

  @override
  Future<dynamic> relateGamePurchase(int gameId, int purchaseId) {

    return _iSQLConnector.insertRelation(
      leftTableName: gameTable,
      rightTableName: purchaseTable,
      leftTableId: gameId,
      rightTableId: purchaseId,
    );

  }

  @override
  Future<dynamic> relateGameDLC(int gameId, int dlcId) {

    return _iSQLConnector.updateTable(
      tableName: dlcTable,
      id: dlcId,
      fieldName: dlc_baseGameField,
      newValue: gameId,
    );

  }

  @override
  Future<dynamic> relateGameTag(int gameId, int tagId) {

    return _iSQLConnector.insertRelation(
      leftTableName: gameTable,
      rightTableName: tagTable,
      leftTableId: gameId,
      rightTableId: tagId,
    );

  }
  //#endregion Game

  //#region DLC
  @override
  Future<DLC> createDLC(String name) {

    return _iSQLConnector.insertRecord(
      tableName: dlcTable,
      fieldAndValues: <String, dynamic> {
        dlc_nameField : name,
      },
    ).asStream().map( _dynamicToSingleDLC ).first;

  }

  @override
  Future<dynamic> relateDLCPurchase(int dlcId, int purchaseId) {

    return _iSQLConnector.insertRelation(
      leftTableName: dlcTable,
      rightTableName: purchaseTable,
      leftTableId: dlcId,
      rightTableId: purchaseId,
    );

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<Platform> createPlatform(String name) {

    return _iSQLConnector.insertRecord(
      tableName: platformTable,
      fieldAndValues: <String, dynamic> {
        plat_nameField : name,
      },
    ).asStream().map( _dynamicToSinglePlatform ).first;

  }

  @override
  Future<dynamic> relatePlatformSystem(int platformId, int systemId) {

    return _iSQLConnector.insertRelation(
      leftTableName: platformTable,
      rightTableName: systemTable,
      leftTableId: platformId,
      rightTableId: systemId,
    );

  }
  //#endregion Platform

  //#region Purchase
  Future<Purchase> createPurchase(String description) {

    return _iSQLConnector.insertRecord(
      tableName: purchaseTable,
      fieldAndValues: <String, dynamic> {
        purc_descriptionField : description,
      },
      returningFields: purchaseFields,
    ).asStream().map( _dynamicToSinglePurchase ).first;

  }

  @override
  Future<dynamic> relatePurchaseType(int purchaseId, int typeId) {

    return _iSQLConnector.insertRelation(
      leftTableName: purchaseTable,
      rightTableName: typeTable,
      leftTableId: purchaseId,
      rightTableId: typeId,
    );

  }
  //#endregion Purchase

  //#region Store
  @override
  Future<Store> createStore(String name) {

    return _iSQLConnector.insertRecord(
      tableName: storeTable,
      fieldAndValues: <String, dynamic> {
        stor_nameField : name,
      },
    ).asStream().map( _dynamicToSingleStore ).first;

  }

  @override
  Future<dynamic> relateStorePurchase(int storeId, int purchaseId) {

    return _iSQLConnector.updateTable(
      tableName: purchaseTable,
      id: purchaseId,
      fieldName: purc_storeField,
      newValue: storeId,
    );

  }
  //#endregion Store

  //#region System
  @override
  Future<System> createSystem(String name) {

    return _iSQLConnector.insertRecord(
      tableName: systemTable,
      fieldAndValues: <String, dynamic> {
        sys_nameField : name,
      },
    ).asStream().map( _dynamicToSingleSystem ).first;

  }
  //#endregion System

  //#region Tag
  @override
  Future<Tag> createTag(String name) {

    return _iSQLConnector.insertRecord(
      tableName: tagTable,
      fieldAndValues: <String, dynamic> {
        tag_nameField : name,
      },
    ).asStream().map( _dynamicToSingleTag ).first;

  }
  //#endregion Tag

  //#region Type
  @override
  Future<PurchaseType> createType(String name) {

    return _iSQLConnector.insertRecord(
      tableName: typeTable,
      fieldAndValues: <String, dynamic> {
        type_nameField : name,
      },
    ).asStream().map( _dynamicToSingleType ).first;

  }
  //#endregion Type
  //#endregion CREATE

  //#region READ
  //#region Game
  @override
  Stream<List<Game>> getAllGames() {

    return getAllWithView(GameView.Main);

  }

  @override
  Stream<List<Game>> getAllOwned() {

    return getOwnedWithView(GameView.Main);

  }

  @override
  Stream<List<Game>> getAllRoms() {

    return getRomsWithView(GameView.Main);

  }

  @override
  Stream<List<Game>> getAllWithView(GameView gameView, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: allViewToTable[gameView],
      selectFields: gameFields,
      limitResults: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> getAllWithYearView(GameView gameView, int year, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: allViewToTable[gameView],
      selectFields: gameFields,
      limitResults: limit,
      tableArguments: <int>[
        year,
      ],
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> getOwnedWithView(GameView gameView, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: gameViewToTable[gameView],
      selectFields: gameFields,
      limitResults: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> getOwnedWithYearView(GameView gameView, int year, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: gameViewToTable[gameView],
      selectFields: gameFields,
      limitResults: limit,
      tableArguments: <int>[
        year,
      ],
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> getRomsWithView(GameView gameView, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: romViewToTable[gameView],
      selectFields: gameFields,
      limitResults: limit,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<Game>> getRomsWithYearView(GameView gameView, int year, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: romViewToTable[gameView],
      selectFields: gameFields,
      limitResults: limit,
      tableArguments: <int>[
        year,
      ],
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<Game> getGameWithId(int id) {

    return _iSQLConnector.readTable(
      tableName: gameTable,
      selectFields: gameFields,
      whereFieldsAndValues: <String, int>{
        IdField : id,
      },
    ).asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<Platform>> getPlatformsFromGame(int id) {

    return _iSQLConnector.readRelation(
      leftTableName: gameTable,
      rightTableName: platformTable,
      leftResults: false,
      relationId: id,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<Purchase>> getPurchasesFromGame(int id) {

    return _iSQLConnector.readRelation(
      leftTableName: gameTable,
      rightTableName: purchaseTable,
      leftResults: false,
      relationId: id,
      selectFields: purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<DLC>> getDLCsFromGame(int id) {

    return _iSQLConnector.readWeakRelation(
      primaryTable: gameTable,
      subordinateTable: dlcTable,
      relationField: dlc_baseGameField,
      relationId: id,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<Tag>> getTagsFromGame(int id) {

    return _iSQLConnector.readRelation(
      leftTableName: gameTable,
      rightTableName: tagTable,
      leftResults: false,
      relationId: id,
    ).asStream().map( _dynamicToListTag );

  }
  //#endregion Game

  //#region DLC
  @override
  Stream<List<DLC>> getAllDLCs([List<String> sortFields]) {

    return getDLCsWithView(DLCView.Main);

  }

  @override
  Stream<List<DLC>> getDLCsWithView(DLCView dlcView, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: dlcViewToTable[dlcView],
      limitResults: limit,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<DLC> getDLCWithId(int id) {

    return _iSQLConnector.readTable(
      tableName: dlcTable,
      whereFieldsAndValues: <String, int>{
        IdField : id,
      },
    ).asStream().map( _dynamicToSingleDLC );

  }

  @override
  Stream<Game> getBaseGameFromDLC(int id) {

    return _iSQLConnector.readWeakRelation(
      primaryTable: gameTable,
      subordinateTable: dlcTable,
      relationField: dlc_baseGameField,
      relationId: id,
      primaryResults: true,
      selectFields: gameFields,
    ).asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<Purchase>> getPurchasesFromDLC(int id) {

    return _iSQLConnector.readRelation(
      leftTableName: dlcTable,
      rightTableName: purchaseTable,
      leftResults: false,
      relationId: id,
      selectFields: purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

  }
  //#endregion DLC

  //#region Platform
  @override
  Stream<List<Platform>> getAllPlatforms() {

    return getPlatformsWithView(PlatformView.Main);

  }

  @override
  Stream<List<Platform>> getPlatformsWithView(PlatformView platformView, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: platformViewToTable[platformView],
      limitResults: limit,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<Platform> getPlatformWithId(int id) {

    return _iSQLConnector.readTable(
      tableName: platformTable,
      whereFieldsAndValues: <String, int>{
        IdField : id,
      },
    ).asStream().map( _dynamicToSinglePlatform );

  }

  @override
  Stream<List<Game>> getGamesFromPlatform(int id) {

    return _iSQLConnector.readRelation(
      leftTableName: gameTable,
      rightTableName: platformTable,
      leftResults: true,
      relationId: id,
      selectFields: gameFields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<System>> getSystemsFromPlatform(int id) {

    return _iSQLConnector.readRelation(
      leftTableName: platformTable,
      rightTableName: systemTable,
      leftResults: false,
      relationId: id,
    ).asStream().map( _dynamicToListSystem );

  }
  //#endregion Platform

  //#region Purchase
  @override
  Stream<List<Purchase>> getAllPurchases([List<String> sortFields]) {

    return getPurchasesWithView(PurchaseView.Main);

  }

  @override
  Stream<List<Purchase>> getPurchasesWithView(PurchaseView purchaseView, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: purchaseViewToTable[purchaseView],
      selectFields: purchaseFields,
      limitResults: limit,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<Purchase>> getPurchasesWithYearView(PurchaseView purchaseView, int year, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: purchaseViewToTable[purchaseView],
      selectFields: purchaseFields,
      limitResults: limit,
      tableArguments: <int>[
        year,
      ],
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<Purchase> getPurchaseWithId(int id) {

    return _iSQLConnector.readTable(
      tableName: purchaseTable,
      selectFields: purchaseFields,
      whereFieldsAndValues: <String, int>{
        IdField : id,
      },
    ).asStream().map( _dynamicToSinglePurchase );

  }

  Stream<Store> getStoreFromPurchase(int id) {

    return _iSQLConnector.readWeakRelation(
      primaryTable: storeTable,
      subordinateTable: purchaseTable,
      relationField: purc_storeField,
      relationId: id,
      primaryResults: true,
    ).asStream().map( _dynamicToSingleStore );

  }

  @override
  Stream<List<Game>> getGamesFromPurchase(int id) {

    return _iSQLConnector.readRelation(
      leftTableName: gameTable,
      rightTableName: purchaseTable,
      leftResults: true,
      relationId: id,
      selectFields: gameFields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<DLC>> getDLCsFromPurchase(int id) {

    return _iSQLConnector.readRelation(
      leftTableName: dlcTable,
      rightTableName: purchaseTable,
      leftResults: true,
      relationId: id,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<PurchaseType>> getTypesFromPurchase(int id) {

    return _iSQLConnector.readRelation(
      leftTableName: purchaseTable,
      rightTableName: typeTable,
      leftResults: false,
      relationId: id,
    ).asStream().map( _dynamicToListType );

  }
  //#endregion Purchase

  //#region Store
  @override
  Stream<List<Store>> getAllStores([List<String> sortFields]) {

    return getStoresWithView(StoreView.Main);

  }

  @override
  Stream<List<Store>> getStoresWithView(StoreView storeView, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: storeViewToTable[storeView],
      limitResults: limit,
    ).asStream().map( _dynamicToListStore );

  }

  @override
  Stream<Store> getStoreWithId(int id) {

    return _iSQLConnector.readTable(
      tableName: storeTable,
      whereFieldsAndValues: <String, int>{
        IdField : id,
      },
    ).asStream().map( _dynamicToSingleStore );

  }

  @override
  Stream<List<Purchase>> getPurchasesFromStore(int id) {

    return _iSQLConnector.readWeakRelation(
      primaryTable: storeTable,
      subordinateTable: purchaseTable,
      relationField: purc_storeField,
      relationId: id,
      selectFields: purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

  }
  //#endregion Store

  //#region System
  @override
  Stream<List<System>> getAllSystems([List<String> sortFields]) {

    return getSystemsWithView(SystemView.Main);

  }

  @override
  Stream<List<System>> getSystemsWithView(SystemView systemView, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: systemViewToTable[systemView],
      limitResults: limit,
    ).asStream().map( _dynamicToListSystem );

  }

  @override
  Stream<System> getSystemWithId(int id) {

    return _iSQLConnector.readTable(
      tableName: systemTable,
      whereFieldsAndValues: <String, int>{
        IdField : id,
      },
    ).asStream().map( _dynamicToSingleSystem );

  }

  @override
  Stream<List<Platform>> getPlatformsFromSystem(int id) {

    return _iSQLConnector.readRelation(
      leftTableName: platformTable,
      rightTableName: systemTable,
      leftResults: true,
      relationId: id,
    ).asStream().map( _dynamicToListPlatform );

  }
  //@endregion System

  //#region Tag
  @override
  Stream<List<Tag>> getAllTags([List<String> sortFields]) {

    return getTagsWithView(TagView.Main);

  }

  @override
  Stream<List<Tag>> getTagsWithView(TagView tagView, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: tagViewToTable[tagView],
      limitResults: limit,
    ).asStream().map( _dynamicToListTag );

  }

  @override
  Stream<Tag> getTagWithId(int id) {

    return _iSQLConnector.readTable(
      tableName: tagTable,
      whereFieldsAndValues: <String, int>{
        IdField : id,
      },
    ).asStream().map( _dynamicToSingleTag );

  }

  @override
  Stream<List<Game>> getGamesFromTag(int id) {

    return _iSQLConnector.readRelation(
      leftTableName: gameTable,
      rightTableName: tagTable,
      leftResults: true,
      relationId: id,
      selectFields: gameFields,
    ).asStream().map( _dynamicToListGame );

  }
  //#endregion Tag

  //#region Type
  @override
  Stream<List<PurchaseType>> getAllTypes([List<String> sortFields]) {

    return getTypesWithView(TypeView.Main);

  }

  @override
  Stream<List<PurchaseType>> getTypesWithView(TypeView typeView, [int limit]) {

    return _iSQLConnector.readTable(
      tableName: typeViewToTable[typeView],
      limitResults: limit,
    ).asStream().map( _dynamicToListType );

  }

  @override
  Stream<PurchaseType> getTypeWithId(int id) {

    return _iSQLConnector.readTable(
      tableName: typeTable,
      whereFieldsAndValues: <String, int>{
        IdField : id,
      },
    ).asStream().map( _dynamicToSingleType );

  }

  @override
  Stream<List<Purchase>> getPurchasesFromType(int id) {

    return _iSQLConnector.readRelation(
      leftTableName: purchaseTable,
      rightTableName: typeTable,
      leftResults: true,
      relationId: id,
      selectFields: purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

  }
  //#endregion Type
  //#endregion READ

  //#region UPDATE
  @override
  Future<Game> updateGame<T>(int id, String fieldName, T newValue) {

    return _iSQLConnector.updateTable(
      tableName: gameTable,
      id: id,
      fieldName: fieldName,
      newValue: newValue,
      returningFields: gameFields,
    ).asStream().map( _dynamicToSingleGame ).first;

  }

  @override
  Future<DLC> updateDLC<T>(int id, String fieldName, T newValue) {

    return _iSQLConnector.updateTable(
      tableName: dlcTable,
      id: id,
      fieldName: fieldName,
      newValue: newValue,
    ).asStream().map( _dynamicToSingleDLC ).first;

  }

  @override
  Future<Platform> updatePlatform<T>(int id, String fieldName, T newValue) {

    return _iSQLConnector.updateTable(
      tableName: platformTable,
      id: id,
      fieldName: fieldName,
      newValue: newValue,
    ).asStream().map( _dynamicToSinglePlatform ).first;

  }

  @override
  Future<Purchase> updatePurchase<T>(int id, String fieldName, T newValue) {

    return _iSQLConnector.updateTable(
      tableName: purchaseTable,
      id: id,
      fieldName: fieldName,
      newValue: newValue,
      returningFields: purchaseFields,
    ).asStream().map( _dynamicToSinglePurchase ).first;

  }

  @override
  Future<Store> updateStore<T>(int id, String fieldName, T newValue) {

    return _iSQLConnector.updateTable(
      tableName: storeTable,
      id: id,
      fieldName: fieldName,
      newValue: newValue,
    ).asStream().map( _dynamicToSingleStore ).first;

  }

  @override
  Future<System> updateSystem<T>(int id, String fieldName, T newValue) {

    return _iSQLConnector.updateTable(
      tableName: systemTable,
      id: id,
      fieldName: fieldName,
      newValue: newValue,
    ).asStream().map( _dynamicToSingleSystem ).first;

  }

  @override
  Future<Tag> updateTag<T>(int id, String fieldName, T newValue) {

    return _iSQLConnector.updateTable(
      tableName: tagTable,
      id: id,
      fieldName: fieldName,
      newValue: newValue,
    ).asStream().map( _dynamicToSingleTag ).first;

  }

  @override
  Future<PurchaseType> updateType<T>(int id, String fieldName, T newValue) {

    return _iSQLConnector.updateTable(
      tableName: typeTable,
      id: id,
      fieldName: fieldName,
      newValue: newValue,
    ).asStream().map( _dynamicToSingleType ).first;

  }
  //#endregion UPDATE

  //#region DELETE
  //#region Game
  @override
  Future<dynamic> deleteGame(int id) {

    return _iSQLConnector.deleteTable(
      tableName: gameTable,
      id: id,
    );

  }

  @override
  Future<dynamic> deleteGamePlatform(int gameId, int platformId) {

    return _iSQLConnector.deleteRelation(
      leftTableName: gameTable,
      rightTableName: platformTable,
      leftId: gameId,
      rightId: platformId,
    );

  }

  @override
  Future<dynamic> deleteGamePurchase(int gameId, int purchaseId) {

    return _iSQLConnector.deleteRelation(
      leftTableName: gameTable,
      rightTableName: purchaseTable,
      leftId: gameId,
      rightId: purchaseId,
    );

  }

  @override
  Future<dynamic> deleteGameDLC(int dlcId) {

    return _iSQLConnector.updateTable(
      tableName: dlcTable,
      id: dlcId,
      fieldName: dlc_baseGameField,
      newValue: null,
    );

  }

  @override
  Future<dynamic> deleteGameTag(int gameId, int tagId) {

    return _iSQLConnector.deleteRelation(
      leftTableName: gameTable,
      rightTableName: tagTable,
      leftId: gameId,
      rightId: tagId,
    );

  }
  //#endregion Game

  //#region DLC
  @override
  Future<dynamic> deleteDLC(int id) {

    return _iSQLConnector.deleteTable(
      tableName: dlcTable,
      id: id,
    );

  }

  @override
  Future<dynamic> deleteDLCPurchase(int dlcId, int purchaseId) {

    return _iSQLConnector.deleteRelation(
      leftTableName: dlcTable,
      rightTableName: purchaseTable,
      leftId: dlcId,
      rightId: purchaseId,
    );

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<dynamic> deletePlatform(int id) {

    return _iSQLConnector.deleteTable(
      tableName: platformTable,
      id: id,
    );

  }

  @override
  Future<dynamic> deletePlatformSystem(int platformId, int systemId) {

    return _iSQLConnector.deleteRelation(
      leftTableName: platformTable,
      rightTableName: systemTable,
      leftId: platformId,
      rightId: systemId,
    );

  }
  //#endregion Platform

  //#region Purchase
  @override
  Future<dynamic> deletePurchase(int id) {

    return _iSQLConnector.deleteTable(
      tableName: purchaseTable,
      id: id,
    );

  }

  @override
  Future<dynamic> deletePurchaseType(int purchaseId, int typeId) {

    return _iSQLConnector.deleteRelation(
      leftTableName: purchaseTable,
      rightTableName: typeTable,
      leftId: purchaseId,
      rightId: typeId,
    );

  }
  //#endregion Purchase

  //#region Store
  @override
  Future<dynamic> deleteStore(int id) {

    return _iSQLConnector.deleteTable(
      tableName: storeTable,
      id: id,
    );

  }

  @override
  Future<dynamic> deleteStorePurchase(int purchaseId) {

    return _iSQLConnector.updateTable(
      tableName: purchaseTable,
      id: purchaseId,
      fieldName: purc_storeField,
      newValue: null,
    );

  }
  //#endregion Store

  //#region System
  @override
  Future<dynamic> deleteSystem(int id) {

    return _iSQLConnector.deleteTable(
      tableName: systemTable,
      id: id,
    );

  }
  //#endregion System

  //#region Tag
  @override
  Future<dynamic> deleteTag(int id) {

    return _iSQLConnector.deleteTable(
      tableName: tagTable,
      id: id,
    );

  }
  //#endregion Tag

  //#region Type
  @override
  Future<dynamic> deleteType(int id) {

    return _iSQLConnector.deleteTable(
      tableName: typeTable,
      id: id,
    );

  }
  //#endregion Type
  //#endregion DELETE

  //#region SEARCH
  @override
  Stream<List<Game>> getGamesWithName(String nameQuery, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: gameTable,
      searchField: game_nameField,
      query: nameQuery,
      fieldNames: gameFields,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<DLC>> getDLCsWithName(String nameQuery, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: dlcTable,
      searchField: dlc_nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<Platform>> getPlatformsWithName(String nameQuery, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: platformTable,
      searchField: plat_nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<Purchase>> getPurchasesWithDescription(String descQuery, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: purchaseTable,
      searchField: purc_descriptionField,
      query: descQuery,
      fieldNames: purchaseFields,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<Store>> getStoresWithName(String nameQuery, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: storeTable,
      searchField: stor_nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListStore );

  }

  @override
  Stream<List<System>> getSystemsWithName(String nameQuery, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: systemTable,
      searchField: sys_nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListSystem );

  }

  @override
  Stream<List<Tag>> getTagsWithName(String nameQuery, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: tagTable,
      searchField: tag_nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListTag );

  }

  @override
  Stream<List<PurchaseType>> getTypesWithName(String nameQuery, int maxResults) {

    return _iSQLConnector.readTableSearch(
      tableName: typeTable,
      searchField: type_nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListType );

  }
  //#endregion SEARCH

  //#region IMAGE
  //#region Game
  @override
  Future<Game> uploadGameCover(int gameId, String uploadImagePath, [String oldImageName]) async {

    if(oldImageName != null) {
      await _iImageConnector.deleteImage(
        tableName: gameTable,
        imageName: oldImageName,
      );
    }

    final String coverName = await _iImageConnector.setImage(
      imagePath: uploadImagePath,
      tableName: gameTable,
      imageName: _getImageName(gameId, 'header'),
    );

    return updateGame(gameId, game_coverField, coverName);

  }

  @override
  Future<Game> renameGameCover(int gameId, String imageName, String newImageName) async {

    final String coverName = await _iImageConnector.renameImage(
      tableName: gameTable,
      oldImageName: imageName,
      newImageName: _getImageName(gameId, newImageName),
    );

    return updateGame(gameId, game_coverField, coverName);

  }

  @override
  Future<Game> deleteGameCover(int gameId, String imageName) async {

    await _iImageConnector.deleteImage(
      tableName: gameTable,
      imageName: imageName,
    );

    return updateGame(gameId, game_coverField, null);

  }
  //#endregion Game

  //#region DLC
  @override
  Future<DLC> uploadDLCCover(int dlcId, String uploadImagePath, [String oldImageName]) async {

    if(oldImageName != null) {
      await _iImageConnector.deleteImage(
        tableName: dlcTable,
        imageName: oldImageName,
      );
    }

    final String coverName = await _iImageConnector.setImage(
      imagePath: uploadImagePath,
      tableName: dlcTable,
      imageName: _getImageName(dlcId, 'header'),
    );

    return updateDLC(dlcId, dlc_coverField, coverName);

  }

  @override
  Future<DLC> renameDLCCover(int dlcId, String imageName, String newImageName) async {

    final String coverName = await _iImageConnector.renameImage(
      tableName: dlcTable,
      oldImageName: imageName,
      newImageName: _getImageName(dlcId, newImageName),
    );

    return updateDLC(dlcId, dlc_coverField, coverName);

  }

  @override
  Future<DLC> deleteDLCCover(int dlcId, String imageName) async {

    await _iImageConnector.deleteImage(
      tableName: dlcTable,
      imageName: imageName,
    );

    return updateDLC(dlcId, dlc_coverField, null);

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<Platform> uploadPlatformIcon(int platformId, String uploadImagePath, [String oldImageName]) async {

    if(oldImageName != null) {
      await _iImageConnector.deleteImage(
        tableName: platformTable,
        imageName: oldImageName,
      );
    }

    final String iconName = await _iImageConnector.setImage(
      imagePath: uploadImagePath,
      tableName: platformTable,
      imageName: _getImageName(platformId, 'icon'),
    );

    return updatePlatform(platformId, plat_iconField, iconName);

  }

  @override
  Future<Platform> renamePlatformIcon(int platformId, String imageName, String newImageName) async {

    final String iconName = await _iImageConnector.renameImage(
      tableName: platformTable,
      oldImageName: imageName,
      newImageName: _getImageName(platformId, newImageName),
    );

    return updatePlatform(platformId, plat_iconField, iconName);

  }

  @override
  Future<Platform> deletePlatformIcon(int platformId, String imageName) async {

    await _iImageConnector.deleteImage(
      tableName: platformTable,
      imageName: imageName,
    );

    return updatePlatform(platformId, plat_iconField, null);

  }
  //#endregion Platform

  //#region Store
  @override
  Future<Store> uploadStoreIcon(int storeId, String uploadImagePath, [String oldImageName]) async {

    if(oldImageName != null) {
      await _iImageConnector.deleteImage(
        tableName: storeTable,
        imageName: oldImageName,
      );
    }

    final String iconName = await _iImageConnector.setImage(
      imagePath: uploadImagePath,
      tableName: storeTable,
      imageName: _getImageName(storeId, 'icon'),
    );

    return updateStore(storeId, stor_iconField, iconName);

  }

  Future<Store> renameStoreIcon(int storeId, String imageName, String newImageName) async {

    final String iconName = await _iImageConnector.renameImage(
      tableName: storeTable,
      oldImageName: imageName,
      newImageName: _getImageName(storeId, newImageName),
    );

    return updateStore(storeId, stor_iconField, iconName);

  }

  @override
  Future<Store> deleteStoreIcon(int storeId, String imageName) async {

    await _iImageConnector.deleteImage(
      tableName: storeTable,
      imageName: imageName,
    );

    return updateStore(storeId, stor_iconField, null);

  }
  //#endregion Store

  //#region System
  @override
  Future<System> uploadSystemIcon(int systemId, String uploadImagePath, [String oldImageName]) async {

    if(oldImageName != null) {
      await _iImageConnector.deleteImage(
        tableName: systemTable,
        imageName: oldImageName,
      );
    }

    final String iconName = await _iImageConnector.setImage(
      imagePath: uploadImagePath,
      tableName: systemTable,
      imageName: _getImageName(systemId, 'icon'),
    );

    return updateSystem(systemId, sys_iconField, iconName);

  }

  @override
  Future<System> renameSystemIcon(int systemId, String imageName, String newImageName) async {

    final String iconName = await _iImageConnector.renameImage(
      tableName: systemTable,
      oldImageName: imageName,
      newImageName: _getImageName(systemId, newImageName),
    );

    return updateSystem(systemId, sys_iconField, iconName);

  }

  @override
  Future<System> deleteSystemIcon(int systemId, String imageName) async {

    await _iImageConnector.deleteImage(
      tableName: systemTable,
      imageName: imageName,
    );

    return updateSystem(systemId, sys_iconField, null);

  }
  //#endregion System
  //#endregion IMAGE

  //#region DOWNLOAD
  String _getGameCoverURL(String gameCoverName) {

    return gameCoverName != null?
        _iImageConnector.getURI(
          tableName: gameTable,
          imageFilename: gameCoverName,
        )
        : null;

  }

  String _getDLCCoverURL(String dlcCoverName) {

    return dlcCoverName != null?
        _iImageConnector.getURI(
          tableName: dlcTable,
          imageFilename: dlcCoverName,
        )
        : null;

  }

  String _getPlatformIconURL(String platformIconName) {

    return platformIconName != null?
        _iImageConnector.getURI(
          tableName: platformTable,
          imageFilename: platformIconName,
        )
        : null;

  }

  String _getStoreIconURL(String storeIconName) {

    return storeIconName != null?
        _iImageConnector.getURI(
          tableName: storeTable,
          imageFilename: storeIconName,
        )
        : null;

  }

  String _getSystemIconURL(String systemIconName) {

    return systemIconName != null?
        _iImageConnector.getURI(
          tableName: systemTable,
          imageFilename: systemIconName,
        )
        : null;

  }
  //#endregion DOWNLOAD

  //#region Dynamic Map to List
  List<Game> _dynamicToListGame(List<Map<String, Map<String, dynamic>>> results) {

    return GameEntity.fromDynamicMapList(results).map( (GameEntity gameEntity) {
      return Game.fromEntity(gameEntity, _getGameCoverURL(gameEntity.coverFilename));
    }).toList(growable: false);

  }

  List<DLC> _dynamicToListDLC(List<Map<String, Map<String, dynamic>>> results) {

    return DLCEntity.fromDynamicMapList(results).map( (DLCEntity dlcEntity) {
      return DLC.fromEntity(dlcEntity, _getDLCCoverURL(dlcEntity.coverFilename));
    }).toList(growable: false);

  }

  List<Platform> _dynamicToListPlatform(List<Map<String, Map<String, dynamic>>> results) {

    return PlatformEntity.fromDynamicMapList(results).map( (PlatformEntity platformEntity) {
      return Platform.fromEntity(platformEntity, _getPlatformIconURL(platformEntity.iconFilename));
    }).toList(growable: false);

  }

  List<Purchase> _dynamicToListPurchase(List<Map<String, Map<String, dynamic>>> results) {

    return PurchaseEntity.fromDynamicMapList(results).map( (PurchaseEntity purchaseEntity) {
      return Purchase.fromEntity(purchaseEntity);
    }).toList(growable: false);

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

  List<Tag> _dynamicToListTag(List<Map<String, Map<String, dynamic>>> results) {

    return TagEntity.fromDynamicMapList(results).map( (TagEntity tagEntity) {
      return Tag.fromEntity(tagEntity);
    }).toList(growable: false);

  }

  List<PurchaseType> _dynamicToListType(List<Map<String, Map<String, dynamic>>> results) {

    return PurchaseTypeEntity.fromDynamicMapList(results).map( (PurchaseTypeEntity typeEntity) {
      return PurchaseType.fromEntity(typeEntity);
    }).toList(growable: false);

  }

  Game _dynamicToSingleGame(List<Map<String, Map<String, dynamic>>> results) {

    Game singleGame;

    if(results.isNotEmpty) {
      singleGame = _dynamicToListGame(results).first;
    }

    return singleGame;

  }

  DLC _dynamicToSingleDLC(List<Map<String, Map<String, dynamic>>> results) {

    DLC singleDLC;

    if(results.isNotEmpty) {
      singleDLC = _dynamicToListDLC(results).first;
    }

    return singleDLC;

  }

  Platform _dynamicToSinglePlatform(List<Map<String, Map<String, dynamic>>> results) {

    Platform singlePlatform;

    if(results.isNotEmpty) {
      singlePlatform = _dynamicToListPlatform(results).first;
    }

    return singlePlatform;

  }

  Purchase _dynamicToSinglePurchase(List<Map<String, Map<String, dynamic>>> results) {

    Purchase singlePurchase;

    if(results.isNotEmpty) {
      singlePurchase = _dynamicToListPurchase(results).first;
    }

    return singlePurchase;

  }

  Store _dynamicToSingleStore(List<Map<String, Map<String, dynamic>>> results) {

    Store singleStore;

    if(results.isNotEmpty) {
      singleStore = _dynamicToListStore(results).first;
    }

    return singleStore;

  }

  System _dynamicToSingleSystem(List<Map<String, Map<String, dynamic>>> results) {

    System singleSystem;

    if(results.isNotEmpty) {
      singleSystem = _dynamicToListSystem(results).first;
    }

    return singleSystem;

  }

  Tag _dynamicToSingleTag(List<Map<String, Map<String, dynamic>>> results) {

    Tag singleTag;

    if(results.isNotEmpty) {
      singleTag = _dynamicToListTag(results).first;
    }

    return singleTag;

  }

  PurchaseType _dynamicToSingleType(List<Map<String, Map<String, dynamic>>> results) {

    PurchaseType singleType;

    if(results.isNotEmpty) {
      singleType = _dynamicToListType(results).first;
    }

    return singleType;

  }
  //#endregion Dynamic Map to List

  String _getImageName(int id, String imageName) {

    return id.toString() + '-' + imageName;

  }
}

const Map<GameView, String> allViewToTable = {
  GameView.Main : "All-Main",
  GameView.LastCreated : "All-Last Created",
  GameView.Playing : "All-Playing",
  GameView.NextUp : "All-Next Up",
  GameView.LastFinished : "All-Last Finished",
  GameView.Review : "All-Year In Review",
};

const Map<GameView, String> gameViewToTable = {
  GameView.Main : "Owned-Main",
  GameView.LastCreated : "Owned-Last Created",
  GameView.Playing : "Owned-Playing",
  GameView.NextUp : "Owned-Next Up",
  GameView.LastFinished : "Owned-Last Finished",
  GameView.Review : "Owned-Year In Review",
};

const Map<GameView, String> romViewToTable = {
  GameView.Main : "Rom-Main",
  GameView.LastCreated : "Rom-Last Created",
  GameView.Playing : "Rom-Playing",
  GameView.NextUp : "Rom-Next Up",
  GameView.LastFinished : "Rom-Last Finished",
  GameView.Review : "Rom-Year In Review",
};

const Map<DLCView, String> dlcViewToTable = {
  DLCView.Main : "DLC-Main",
  DLCView.LastCreated : "DLC-Last Created",
};

const Map<PlatformView, String> platformViewToTable = {
  PlatformView.Main : "Platform-Main",
  PlatformView.LastCreated : "Platform-Last Created",
};

const Map<PurchaseView, String> purchaseViewToTable = {
  PurchaseView.Main : "Purchase-Main",
  PurchaseView.LastCreated : "Purchase-Last Created",
  PurchaseView.Pending : "Purchase-Pending",
  PurchaseView.LastPurchased : "Purchase-Last Purchased",
  PurchaseView.Review : "Purchase-Year In Review",
};

const Map<StoreView, String> storeViewToTable = {
  StoreView.Main : "Store-Main",
  StoreView.LastCreated : "Store-Last Created",
};

const Map<SystemView, String> systemViewToTable = {
  SystemView.Main : "System-Main",
  SystemView.LastCreated : "System-Last Created",
};

const Map<TagView, String> tagViewToTable = {
  TagView.Main : "Tag-Main",
  TagView.LastCreated : "Tag-Last Created",
};

const Map<TypeView, String> typeViewToTable = {
  TypeView.Main : "Type-Main",
  TypeView.LastCreated : "Type-Last Created",
};