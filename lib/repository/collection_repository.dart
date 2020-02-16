import 'package:game_collection/client/idb_connector.dart';
import 'package:game_collection/client/iimage_connector.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'icollection_repository.dart';


class CollectionRepository implements ICollectionRepository {

  CollectionRepository._(IDBConnector idbConnector, IImageConnector iImageConnector) {
    _dbConnector = idbConnector;
    _imageConnector = iImageConnector;
  }

  IDBConnector _dbConnector;
  IImageConnector _imageConnector;

  static CollectionRepository _singleton;
  factory CollectionRepository({IDBConnector idbConnector, IImageConnector iImageConnector}) {
    if(_singleton == null) {
      _singleton = CollectionRepository._(
        idbConnector,
        iImageConnector,
      );
    }

    return _singleton;
  }

  @override
  Future<dynamic> open() {

    return _dbConnector.open();

  }

  Future<dynamic> close() {

    return _dbConnector.close();

  }

  //#region CREATE
  //#region Game
  @override
  Future<Game> insertGame(String name, String edition) {

    return _dbConnector.insertTable(
      tableName: gameTable,
      fieldAndValues: <String, dynamic> {
        game_nameField : name,
        game_editionField : edition,
      },
      returningFields: gameFields,
    ).asStream().map( _dynamicToSingleGame ).first;

  }

  @override
  Future<dynamic> insertGamePlatform(int gameID, int platformID) {

    return _dbConnector.insertRelation(
      leftTableName: gameTable,
      rightTableName: platformTable,
      leftTableID: gameID,
      rightTableID: platformID,
    );

  }

  @override
  Future<dynamic> insertGamePurchase(int gameID, int purchaseID) {

    return _dbConnector.insertRelation(
      leftTableName: gameTable,
      rightTableName: purchaseTable,
      leftTableID: gameID,
      rightTableID: purchaseID,
    );

  }

  @override
  Future insertGameDLC(int gameID, int dlcID) {

    return _dbConnector.updateTable(
      tableName: dlcTable,
      ID: dlcID,
      fieldName: dlc_baseGameField,
      newValue: gameID,
    );

  }

  @override
  Future<dynamic> insertGameTag(int gameID, int tagID) {

    return _dbConnector.insertRelation(
      leftTableName: gameTable,
      rightTableName: tagTable,
      leftTableID: gameID,
      rightTableID: tagID,
    );

  }
  //#endregion Game

  //#region DLC
  @override
  Future<DLC> insertDLC(String name) {

    return _dbConnector.insertTable(
      tableName: dlcTable,
      fieldAndValues: <String, dynamic> {
        dlc_nameField : name,
      },
    ).asStream().map( _dynamicToSingleDLC ).first;

  }

  @override
  Future<dynamic> insertDLCPurchase(int dlcID, int purchaseID) {

    return _dbConnector.insertRelation(
      leftTableName: dlcTable,
      rightTableName: purchaseTable,
      leftTableID: dlcID,
      rightTableID: purchaseID,
    );

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<Platform> insertPlatform(String name) {

    return _dbConnector.insertTable(
      tableName: platformTable,
      fieldAndValues: <String, dynamic> {
        plat_nameField : name,
      },
    ).asStream().map( _dynamicToSinglePlatform ).first;

  }

  @override
  Future<dynamic> insertPlatformSystem(int platformID, int systemID) {

    return _dbConnector.insertRelation(
      leftTableName: platformTable,
      rightTableName: systemTable,
      leftTableID: platformID,
      rightTableID: systemID,
    );

  }
  //#endregion Platform

  //#region Purchase
  Future<Purchase> insertPurchase(String description) {

    return _dbConnector.insertTable(
      tableName: purchaseTable,
      fieldAndValues: <String, dynamic> {
        purc_descriptionField : description,
      },
      returningFields: purchaseFields,
    ).asStream().map( _dynamicToSinglePurchase ).first;

  }

  @override
  Future<dynamic> insertPurchaseType(int purchaseID, int typeID) {

    return _dbConnector.insertRelation(
      leftTableName: purchaseTable,
      rightTableName: typeTable,
      leftTableID: purchaseID,
      rightTableID: typeID,
    );

  }
  //#endregion Purchase

  //#region Store
  @override
  Future<Store> insertStore(String name) {

    return _dbConnector.insertTable(
      tableName: storeTable,
      fieldAndValues: <String, dynamic> {
        stor_nameField : name,
      },
    ).asStream().map( _dynamicToSingleStore ).first;

  }

  @override
  Future<dynamic> insertStorePurchase(int storeID, int purchaseID) {

    return _dbConnector.updateTable(
      tableName: purchaseTable,
      ID: purchaseID,
      fieldName: purc_storeField,
      newValue: storeID,
    );

  }
  //#endregion Store

  //#region System
  @override
  Future<System> insertSystem(String name) {

    return _dbConnector.insertTable(
      tableName: systemTable,
      fieldAndValues: <String, dynamic> {
        sys_nameField : name,
      },
    ).asStream().map( _dynamicToSingleSystem ).first;

  }
  //#endregion System

  //#region Tag
  @override
  Future<Tag> insertTag(String name) {

    return _dbConnector.insertTable(
      tableName: tagTable,
      fieldAndValues: <String, dynamic> {
        tag_nameField : name,
      },
    ).asStream().map( _dynamicToSingleTag ).first;

  }
  //#endregion Tag

  //#region Type
  @override
  Future<PurchaseType> insertType(String name) {

    return _dbConnector.insertTable(
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

    return getGamesWithView(GameView.Main);

  }

  @override
  Stream<List<Game>> getGamesWithView(GameView gameView) {

    return _dbConnector.readTable(
      tableName: gameViewToTable[gameView],
      selectFields: gameFields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<Game> getGameWithID(int ID) {

    return _dbConnector.readTable(
      tableName: gameTable,
      selectFields: gameFields,
      whereFieldsAndValues: <String, int> {
        IDField : ID,
      },
    ).asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<Platform>> getPlatformsFromGame(int ID) {

    return _dbConnector.readRelation(
      leftTableName: gameTable,
      rightTableName: platformTable,
      leftResults: false,
      relationID: ID,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<Purchase>> getPurchasesFromGame(int ID) {

    return _dbConnector.readRelation(
      leftTableName: gameTable,
      rightTableName: purchaseTable,
      leftResults: false,
      relationID: ID,
      selectFields: purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<DLC>> getDLCsFromGame(int ID) {

    return _dbConnector.readWeakRelation(
      primaryTable: gameTable,
      subordinateTable: dlcTable,
      relationField: dlc_baseGameField,
      relationID: ID,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<Tag>> getTagsFromGame(int ID) {

    return _dbConnector.readRelation(
      leftTableName: gameTable,
      rightTableName: tagTable,
      leftResults: false,
      relationID: ID,
    ).asStream().map( _dynamicToListTag );

  }
  //#endregion Game

  //#region DLC
  @override
  Stream<List<DLC>> getAllDLCs([List<String> sortFields]) {

    return getDLCsWithView(DLCView.Main);

  }

  @override
  Stream<List<DLC>> getDLCsWithView(DLCView dlcView) {

    return _dbConnector.readTable(
      tableName: dlcViewToTable[dlcView],
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<DLC> getDLCWithID(int ID) {

    return _dbConnector.readTable(
      tableName: dlcTable,
      whereFieldsAndValues: <String, int> {
        IDField : ID,
      },
    ).asStream().map( _dynamicToSingleDLC );

  }

  @override
  Stream<Game> getBaseGameFromDLC(int ID) {

    return _dbConnector.readWeakRelation(
      primaryTable: gameTable,
      subordinateTable: dlcTable,
      relationField: dlc_baseGameField,
      relationID: ID,
      primaryResults: true,
      selectFields: gameFields,
    ).asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<Purchase>> getPurchasesFromDLC(int ID) {

    return _dbConnector.readRelation(
      leftTableName: dlcTable,
      rightTableName: purchaseTable,
      leftResults: false,
      relationID: ID,
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
  Stream<List<Platform>> getPlatformsWithView(PlatformView platformView) {

    return _dbConnector.readTable(
      tableName: platformViewToTable[platformView],
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<Platform> getPlatformWithID(int ID) {

    return _dbConnector.readTable(
      tableName: platformTable,
      whereFieldsAndValues: <String, int> {
        IDField : ID,
      },
    ).asStream().map( _dynamicToSinglePlatform );

  }

  @override
  Stream<List<Game>> getGamesFromPlatform(int ID) {

    return _dbConnector.readRelation(
      leftTableName: gameTable,
      rightTableName: platformTable,
      leftResults: true,
      relationID: ID,
      selectFields: gameFields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<System>> getSystemsFromPlatform(int ID) {

    return _dbConnector.readRelation(
      leftTableName: platformTable,
      rightTableName: systemTable,
      leftResults: false,
      relationID: ID,
    ).asStream().map( _dynamicToListSystem );

  }
  //#endregion Platform

  //#region Purchase
  @override
  Stream<List<Purchase>> getAllPurchases([List<String> sortFields]) {

    return getPurchasesWithView(PurchaseView.Main);

  }

  @override
  Stream<List<Purchase>> getPurchasesWithView(PurchaseView purchaseView) {

    return _dbConnector.readTable(
      tableName: purchaseViewToTable[purchaseView],
      selectFields: purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<Purchase> getPurchaseWithID(int ID) {

    return _dbConnector.readTable(
      tableName: purchaseTable,
      selectFields: purchaseFields,
      whereFieldsAndValues: <String, int> {
        IDField : ID,
      },
    ).asStream().map( _dynamicToSinglePurchase );

  }

  Stream<Store> getStoreFromPurchase(int ID) {

    return _dbConnector.readWeakRelation(
      primaryTable: storeTable,
      subordinateTable: purchaseTable,
      relationField: purc_storeField,
      relationID: ID,
      primaryResults: true,
    ).asStream().map( _dynamicToSingleStore );

  }

  @override
  Stream<List<Game>> getGamesFromPurchase(int ID) {

    return _dbConnector.readRelation(
      leftTableName: gameTable,
      rightTableName: purchaseTable,
      leftResults: true,
      relationID: ID,
      selectFields: gameFields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<DLC>> getDLCsFromPurchase(int ID) {

    return _dbConnector.readRelation(
      leftTableName: dlcTable,
      rightTableName: purchaseTable,
      leftResults: true,
      relationID: ID,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<PurchaseType>> getTypesFromPurchase(int ID) {

    return _dbConnector.readRelation(
      leftTableName: purchaseTable,
      rightTableName: typeTable,
      leftResults: false,
      relationID: ID,
    ).asStream().map( _dynamicToListType );

  }
  //#endregion Purchase

  //#region Store
  @override
  Stream<List<Store>> getAllStores([List<String> sortFields]) {

    return getStoresWithView(StoreView.Main);

  }

  @override
  Stream<List<Store>> getStoresWithView(StoreView storeView) {

    return _dbConnector.readTable(
      tableName: storeViewToTable[storeView],
    ).asStream().map( _dynamicToListStore );

  }

  @override
  Stream<Store> getStoreWithID(int ID) {

    return _dbConnector.readTable(
      tableName: storeTable,
      whereFieldsAndValues: <String, int> {
        IDField : ID,
      },
    ).asStream().map( _dynamicToSingleStore );

  }

  @override
  Stream<List<Purchase>> getPurchasesFromStore(int ID) {

    return _dbConnector.readWeakRelation(
      primaryTable: storeTable,
      subordinateTable: purchaseTable,
      relationField: purc_storeField,
      relationID: ID,
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
  Stream<List<System>> getSystemsWithView(SystemView systemView) {

    return _dbConnector.readTable(
      tableName: systemViewToTable[systemView],
    ).asStream().map( _dynamicToListSystem );

  }

  @override
  Stream<System> getSystemWithID(int ID) {

    return _dbConnector.readTable(
      tableName: systemTable,
      whereFieldsAndValues: <String, int> {
        IDField : ID,
      },
    ).asStream().map( _dynamicToSingleSystem );

  }

  @override
  Stream<List<Platform>> getPlatformsFromSystem(int ID) {

    return _dbConnector.readRelation(
      leftTableName: platformTable,
      rightTableName: systemTable,
      leftResults: true,
      relationID: ID,
    ).asStream().map( _dynamicToListPlatform );

  }
  //@endregion System

  //#region Tag
  @override
  Stream<List<Tag>> getAllTags([List<String> sortFields]) {

    return getTagsWithView(TagView.Main);

  }

  @override
  Stream<List<Tag>> getTagsWithView(TagView tagView) {

    return _dbConnector.readTable(
      tableName: tagViewToTable[tagView],
    ).asStream().map( _dynamicToListTag );

  }

  @override
  Stream<Tag> getTagWithID(int ID) {

    return _dbConnector.readTable(
      tableName: tagTable,
      whereFieldsAndValues: <String, int> {
        IDField : ID,
      },
    ).asStream().map( _dynamicToSingleTag );

  }

  @override
  Stream<List<Game>> getGamesFromTag(int ID) {

    return _dbConnector.readRelation(
      leftTableName: gameTable,
      rightTableName: tagTable,
      leftResults: true,
      relationID: ID,
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
  Stream<List<PurchaseType>> getTypesWithView(TypeView typeView) {

    return _dbConnector.readTable(
      tableName: typeViewToTable[typeView],
    ).asStream().map( _dynamicToListType );

  }

  @override
  Stream<PurchaseType> getTypeWithID(int ID) {

    return _dbConnector.readTable(
      tableName: typeTable,
      whereFieldsAndValues: <String, int> {
        IDField : ID,
      },
    ).asStream().map( _dynamicToSingleType );

  }

  @override
  Stream<List<Purchase>> getPurchasesFromType(int ID) {

    return _dbConnector.readRelation(
      leftTableName: purchaseTable,
      rightTableName: typeTable,
      leftResults: true,
      relationID: ID,
      selectFields: purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

  }
  //#endregion Type
  //#endregion READ

  //#region UPDATE
  @override
  Future<Game> updateGame<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: gameTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
      returningFields: gameFields,
    ).asStream().map( _dynamicToSingleGame ).first;

  }

  @override
  Future<DLC> updateDLC<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: dlcTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    ).asStream().map( _dynamicToSingleDLC ).first;

  }

  @override
  Future<Platform> updatePlatform<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: platformTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    ).asStream().map( _dynamicToSinglePlatform ).first;

  }

  @override
  Future<Purchase> updatePurchase<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: purchaseTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
      returningFields: purchaseFields,
    ).asStream().map( _dynamicToSinglePurchase ).first;

  }

  @override
  Future<Store> updateStore<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: storeTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    ).asStream().map( _dynamicToSingleStore ).first;

  }

  @override
  Future<System> updateSystem<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: systemTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    ).asStream().map( _dynamicToSingleSystem ).first;

  }

  @override
  Future<Tag> updateTag<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: tagTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    ).asStream().map( _dynamicToSingleTag ).first;

  }

  @override
  Future<PurchaseType> updateType<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: typeTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    ).asStream().map( _dynamicToSingleType ).first;

  }
  //#endregion UPDATE

  //#region DELETE
  //#region Game
  @override
  Future<dynamic> deleteGame(int ID) {

    return _dbConnector.deleteTable(
      tableName: gameTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deleteGamePlatform(int gameID, int platformID) {

    return _dbConnector.deleteRelation(
      leftTableName: gameTable,
      rightTableName: platformTable,
      leftID: gameID,
      rightID: platformID,
    );

  }

  @override
  Future<dynamic> deleteGamePurchase(int gameID, int purchaseID) {

    return _dbConnector.deleteRelation(
      leftTableName: gameTable,
      rightTableName: purchaseTable,
      leftID: gameID,
      rightID: purchaseID,
    );

  }

  @override
  Future<dynamic> deleteGameDLC(int dlcID) {

    return _dbConnector.updateTable(
      tableName: dlcTable,
      ID: dlcID,
      fieldName: dlc_baseGameField,
      newValue: null,
    );

  }

  @override
  Future<dynamic> deleteGameTag(int gameID, int tagID) {

    return _dbConnector.deleteRelation(
      leftTableName: gameTable,
      rightTableName: tagTable,
      leftID: gameID,
      rightID: tagID,
    );

  }
  //#endregion Game

  //#region DLC
  @override
  Future<dynamic> deleteDLC(int ID) {

    return _dbConnector.deleteTable(
      tableName: dlcTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deleteDLCPurchase(int dlcID, int purchaseID) {

    return _dbConnector.deleteRelation(
      leftTableName: dlcTable,
      rightTableName: purchaseTable,
      leftID: dlcID,
      rightID: purchaseID,
    );

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<dynamic> deletePlatform(int ID) {

    return _dbConnector.deleteTable(
      tableName: platformTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deletePlatformSystem(int platformID, int systemID) {

    return _dbConnector.deleteRelation(
      leftTableName: platformTable,
      rightTableName: systemTable,
      leftID: platformID,
      rightID: systemID,
    );

  }
  //#endregion Platform

  //#region Purchase
  @override
  Future<dynamic> deletePurchase(int ID) {

    return _dbConnector.deleteTable(
      tableName: purchaseTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deletePurchaseType(int purchaseID, int typeID) {

    return _dbConnector.deleteRelation(
      leftTableName: purchaseTable,
      rightTableName: typeTable,
      leftID: purchaseID,
      rightID: typeID,
    );

  }
  //#endregion Purchase

  //#region Store
  @override
  Future<dynamic> deleteStore(int ID) {

    return _dbConnector.deleteTable(
      tableName: storeTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deleteStorePurchase(int purchaseID) {

    return _dbConnector.updateTable(
      tableName: purchaseTable,
      ID: purchaseID,
      fieldName: purc_storeField,
      newValue: null,
    );

  }
  //#endregion Store

  //#region System
  @override
  Future<dynamic> deleteSystem(int ID) {

    return _dbConnector.deleteTable(
      tableName: systemTable,
      ID: ID,
    );

  }
  //#endregion System

  //#region Tag
  @override
  Future<dynamic> deleteTag(int ID) {

    return _dbConnector.deleteTable(
      tableName: tagTable,
      ID: ID,
    );

  }
  //#endregion Tag

  //#region Type
  @override
  Future<dynamic> deleteType(int ID) {

    return _dbConnector.deleteTable(
      tableName: typeTable,
      ID: ID,
    );

  }
  //#endregion Type
  //#endregion DELETE

  //#region SEARCH
  Stream<List<CollectionItem>> getSearchStream(String tableName, String query, int maxResults) {

    switch(tableName) {
      case gameTable:
        return getGamesWithName(query, maxResults);
      case dlcTable:
        return getDLCsWithName(query, maxResults);
      case platformTable:
        return getPlatformsWithName(query, maxResults);
      case purchaseTable:
        return getPurchasesWithDescription(query, maxResults);
      case storeTable:
        return getStoresWithName(query, maxResults);
      case systemTable:
        return getSystemsWithName(query, maxResults);
      case tagTable:
        return getTagsWithName(query, maxResults);
      case typeTable:
        return getTypesWithName(query, maxResults);
    }
    return null;

  }

  @override
  Stream<List<Game>> getGamesWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: gameTable,
      searchField: game_nameField,
      query: nameQuery,
      fieldNames: gameFields,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<DLC>> getDLCsWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: dlcTable,
      searchField: dlc_nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<Platform>> getPlatformsWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: platformTable,
      searchField: plat_nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<Purchase>> getPurchasesWithDescription(String descQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: purchaseTable,
      searchField: purc_descriptionField,
      query: descQuery,
      fieldNames: purchaseFields,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<Store>> getStoresWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: storeTable,
      searchField: stor_nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListStore );

  }

  @override
  Stream<List<System>> getSystemsWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: systemTable,
      searchField: sys_nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListSystem );

  }

  @override
  Stream<List<Tag>> getTagsWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: tagTable,
      searchField: tag_nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListTag );

  }

  @override
  Stream<List<PurchaseType>> getTypesWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: typeTable,
      searchField: type_nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListType );

  }
  //#endregion SEARCH

  //#region UPLOAD
  @override
  Future<dynamic> uploadGameCover(int gameID, String uploadImagePath) {

    return _imageConnector.uploadImage(
      imagePath: uploadImagePath,
      tableName: gameTable,
      imageName: gameID.toString(),
    );

  }
  //#endregion UPLOAD

  //#region DOWNLOAD
  @override
  String getGameCoverURL(int gameID) {

    return _imageConnector.getDownloadURL(
      tableName: gameTable,
      imageName: gameID.toString(),
    );

  }
  //#endregion DOWNLOAD

  //#region Dynamic Map to List
  List<Game> _dynamicToListGame(List<Map<String, Map<String, dynamic>>> results) {

    return GameEntity.fromDynamicMapList(results).map( (GameEntity gameEntity) {
      return Game.fromEntity(gameEntity);
    }).toList();

  }

  List<DLC> _dynamicToListDLC(List<Map<String, Map<String, dynamic>>> results) {

    return DLCEntity.fromDynamicMapList(results).map( (DLCEntity dlcEntity) {
      return DLC.fromEntity(dlcEntity);
    }).toList();

  }

  List<Platform> _dynamicToListPlatform(List<Map<String, Map<String, dynamic>>> results) {

    return PlatformEntity.fromDynamicMapList(results).map( (PlatformEntity platformEntity) {
      return Platform.fromEntity(platformEntity);
    }).toList();

  }

  List<Purchase> _dynamicToListPurchase(List<Map<String, Map<String, dynamic>>> results) {

    return PurchaseEntity.fromDynamicMapList(results).map( (PurchaseEntity purchaseEntity) {
      return Purchase.fromEntity(purchaseEntity);
    }).toList();

  }

  List<Store> _dynamicToListStore(List<Map<String, Map<String, dynamic>>> results) {

    return StoreEntity.fromDynamicMapList(results).map( (StoreEntity storeEntity) {
      return Store.fromEntity(storeEntity);
    }).toList();

  }

  List<System> _dynamicToListSystem(List<Map<String, Map<String, dynamic>>> results) {

    return SystemEntity.fromDynamicMapList(results).map( (SystemEntity systemEntity) {
      return System.fromEntity(systemEntity);
    }).toList();

  }

  List<Tag> _dynamicToListTag(List<Map<String, Map<String, dynamic>>> results) {

    return TagEntity.fromDynamicMapList(results).map( (TagEntity tagEntity) {
      return Tag.fromEntity(tagEntity);
    }).toList();

  }

  List<PurchaseType> _dynamicToListType(List<Map<String, Map<String, dynamic>>> results) {

    return PurchaseTypeEntity.fromDynamicMapList(results).map( (PurchaseTypeEntity typeEntity) {
      return PurchaseType.fromEntity(typeEntity);
    }).toList();

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

}

Map<GameView, String> gameViewToTable = {
  GameView.Main : "Game-Main",
  GameView.Playing : "Game-Playing",
  GameView.NextUp : "Game-Next Up",
  GameView.LastFinished : "Game-Last Finished",
  GameView.Review2019 : "Game-2019 In Review",
};

Map<DLCView, String> dlcViewToTable = {
  DLCView.Main : "DLC-Main",
};

Map<PlatformView, String> platformViewToTable = {
  PlatformView.Main : "Platform-Main",
};

Map<PurchaseView, String> purchaseViewToTable = {
  PurchaseView.Main : "Purchase-Main",
  PurchaseView.Pending : "Purchase-Pending",
  PurchaseView.LastPurchased : "Purchase-Last Purchased",
  PurchaseView.Review2019 : "Purchase-2019 In Review",
};

Map<StoreView, String> storeViewToTable = {
  StoreView.Main : "Store-Main",
};

Map<SystemView, String> systemViewToTable = {
  SystemView.Main : "System-Main",
};

Map<TagView, String> tagViewToTable = {
  TagView.Main : "Tag-Main",
};

Map<TypeView, String> typeViewToTable = {
  TypeView.Main : "Type-Main",
};