import 'package:game_collection/client/idb_connector.dart';
import 'package:game_collection/client/iimage_connector.dart';
import 'package:game_collection/client/postgres_connector.dart';
import 'package:game_collection/client/cloudinary_connector.dart';

import 'package:game_collection/model/entity.dart';
import 'package:game_collection/model/game.dart' as gameEntity;
import 'package:game_collection/model/dlc.dart' as dlcEntity;
import 'package:game_collection/model/purchase.dart' as purchaseEntity;
import 'package:game_collection/model/platform.dart' as platformEntity;
import 'package:game_collection/model/store.dart' as storeEntity;
import 'package:game_collection/model/system.dart' as systemEntity;
import 'package:game_collection/model/tag.dart' as tagEntity;
import 'package:game_collection/model/type.dart' as typeEntity;

import 'icollection_repository.dart';

class CollectionRepository implements ICollectionRepository {

  IDBConnector _dbConnector;
  IImageConnector _imageConnector;

  CollectionRepository._() {
    _dbConnector = PostgresConnector();
    _imageConnector = CloudinaryConnector();
  }

  static CollectionRepository _singleton;
  factory CollectionRepository() {
    if(_singleton == null) {
      _singleton = CollectionRepository._();
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
  Future<dynamic> insertGame(String name, String edition) {

    return _dbConnector.insertTable(
      tableName: gameEntity.gameTable,
      fieldAndValues: <String, dynamic> {
        gameEntity.nameField : name,
        gameEntity.editionField : edition,
      },
    );

  }

  @override
  Future<dynamic> insertGamePlatform(int gameID, int platformID) {

    return _dbConnector.insertRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: platformEntity.platformTable,
      leftTableID: gameID,
      rightTableID: platformID,
    );

  }

  @override
  Future<dynamic> insertGamePurchase(int gameID, int purchaseID) {

    return _dbConnector.insertRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftTableID: gameID,
      rightTableID: purchaseID,
    );

  }

  @override
  Future insertGameDLC(int gameID, int dlcID) {

    return _dbConnector.updateTable(
      tableName: dlcEntity.dlcTable,
      ID: dlcID,
      fieldName: dlcEntity.baseGameField,
      newValue: gameID,
    );

  }

  @override
  Future<dynamic> insertGameTag(int gameID, int tagID) {

    return _dbConnector.insertRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: tagEntity.tagTable,
      leftTableID: gameID,
      rightTableID: tagID,
    );

  }
  //#endregion Game

  //#region DLC
  @override
  Future<dynamic> insertDLC(String name) {

    return _dbConnector.insertTable(
      tableName: dlcEntity.dlcTable,
      fieldAndValues: <String, dynamic> {
        dlcEntity.nameField : name,
      },
    );

  }

  @override
  Future<dynamic> insertDLCPurchase(int dlcID, int purchaseID) {

    return _dbConnector.insertRelation(
      leftTableName: dlcEntity.dlcTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftTableID: dlcID,
      rightTableID: purchaseID,
    );

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<dynamic> insertPlatform(String name) {

    return _dbConnector.insertTable(
      tableName: platformEntity.platformTable,
      fieldAndValues: <String, dynamic> {
        platformEntity.nameField : name,
      },
    );

  }

  @override
  Future<dynamic> insertPlatformSystem(int platformID, int systemID) {

    return _dbConnector.insertRelation(
      leftTableName: platformEntity.platformTable,
      rightTableName: systemEntity.systemTable,
      leftTableID: platformID,
      rightTableID: systemID,
    );

  }
  //#endregion Platform

  //#region Purchase
  Future<dynamic> insertPurchase(String description) {

    return _dbConnector.insertTable(
      tableName: purchaseEntity.purchaseTable,
      fieldAndValues: <String, dynamic> {
        purchaseEntity.descriptionField : description,
      },
    );

  }

  @override
  Future<dynamic> insertPurchaseType(int purchaseID, int typeID) {

    return _dbConnector.insertRelation(
      leftTableName: purchaseEntity.purchaseTable,
      rightTableName: typeEntity.typeTable,
      leftTableID: purchaseID,
      rightTableID: typeID,
    );

  }
  //#endregion Purchase

  //#region Store
  @override
  Future<dynamic> insertStore(String name) {

    return _dbConnector.insertTable(
      tableName: storeEntity.storeTable,
      fieldAndValues: <String, dynamic> {
        storeEntity.nameField : name,
      },
    );

  }

  @override
  Future<dynamic> insertStorePurchase(int storeID, int purchaseID) {

    return _dbConnector.updateTable(
      tableName: purchaseEntity.purchaseTable,
      ID: purchaseID,
      fieldName: purchaseEntity.storeField,
      newValue: storeID,
    );

  }
  //#endregion Store

  //#region System
  @override
  Future<dynamic> insertSystem(String name) {

    return _dbConnector.insertTable(
      tableName: systemEntity.systemTable,
      fieldAndValues: <String, dynamic> {
        systemEntity.nameField : name,
      },
    );

  }
  //#endregion System

  //#region Tag
  @override
  Future<dynamic> insertTag(String name) {

    return _dbConnector.insertTable(
      tableName: tagEntity.tagTable,
      fieldAndValues: <String, dynamic> {
        tagEntity.nameField : name,
      },
    );

  }
  //#endregion Tag

  //#region Type
  @override
  Future<dynamic> insertType(String name) {

    return _dbConnector.insertTable(
      tableName: typeEntity.typeTable,
      fieldAndValues: <String, dynamic> {
        typeEntity.nameField : name,
      },
    );

  }
  //#endregion Type
  //#endregion CREATE

  //#region READ
  //#region Game
  @override
  Stream<List<gameEntity.Game>> getAllGames([List<String> sortFields]) {

    return _dbConnector.readTable(
      tableName: gameEntity.gameTable,
      selectFields: gameEntity.gameFields,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<platformEntity.Platform>> getPlatformsFromGame(int ID) {

    return _dbConnector.readRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: platformEntity.platformTable,
      leftResults: false,
      relationID: ID,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromGame(int ID) {

    return _dbConnector.readRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftResults: false,
      relationID: ID,
      selectFields: purchaseEntity.purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<dlcEntity.DLC>> getDLCsFromGame(int ID) {

    return _dbConnector.readWeakRelation(
      primaryTable: gameEntity.gameTable,
      subordinateTable: dlcEntity.dlcTable,
      relationField: dlcEntity.baseGameField,
      relationID: ID,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<tagEntity.Tag>> getTagsFromGame(int ID) {

    return _dbConnector.readRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: tagEntity.tagTable,
      leftResults: false,
      relationID: ID,
    ).asStream().map( _dynamicToListTag );

  }
  //#endregion Game

  //#region DLC
  @override
  Stream<List<dlcEntity.DLC>> getAllDLCs([List<String> sortFields]) {

    return _dbConnector.readTable(
      tableName: dlcEntity.dlcTable,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<gameEntity.Game> getBaseGameFromDLC(int baseGameID) {

    return _dbConnector.readTable(
      tableName: gameEntity.gameTable,
      selectFields: gameEntity.gameFields,
      whereFieldsAndValues: <String, dynamic> {
        IDField : baseGameID,
      },
    ).asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromDLC(int ID) {

    return _dbConnector.readRelation(
      leftTableName: dlcEntity.dlcTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftResults: false,
      relationID: ID,
      selectFields: purchaseEntity.purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

  }
  //#endregion DLC

  //#region Platform
  @override
  Stream<List<platformEntity.Platform>> getAllPlatforms([List<String> sortFields]) {

    return _dbConnector.readTable(
      tableName: platformEntity.platformTable,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<gameEntity.Game>> getGamesFromPlatform(int ID) {

    return _dbConnector.readRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: platformEntity.platformTable,
      leftResults: true,
      relationID: ID,
      selectFields: gameEntity.gameFields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<systemEntity.System>> getSystemsFromPlatform(int ID) {

    return _dbConnector.readRelation(
      leftTableName: platformEntity.platformTable,
      rightTableName: systemEntity.systemTable,
      leftResults: false,
      relationID: ID,
    ).asStream().map( _dynamicToListSystem );

  }
  //#endregion Platform

  //#region Purchase
  @override
  Stream<List<purchaseEntity.Purchase>> getAllPurchases([List<String> sortFields]) {

    return _dbConnector.readTable(
      tableName: purchaseEntity.purchaseTable,
      selectFields: purchaseEntity.purchaseFields,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListPurchase );

  }

  Stream<storeEntity.Store> getStoreFromPurchase(int storeID) {

    return _dbConnector.readTable(
      tableName: storeEntity.storeTable,
      whereFieldsAndValues: <String, dynamic> {
        IDField : storeID,
      },
    ).asStream().map( _dynamicToSingleStore );

  }

  @override
  Stream<List<gameEntity.Game>> getGamesFromPurchase(int ID) {

    return _dbConnector.readRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftResults: true,
      relationID: ID,
      selectFields: gameEntity.gameFields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<dlcEntity.DLC>> getDLCsFromPurchase(int ID) {

    return _dbConnector.readRelation(
      leftTableName: dlcEntity.dlcTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftResults: true,
      relationID: ID,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<typeEntity.PurchaseType>> getTypesFromPurchase(int ID) {

    return _dbConnector.readRelation(
      leftTableName: purchaseEntity.purchaseTable,
      rightTableName: typeEntity.typeTable,
      leftResults: false,
      relationID: ID,
    ).asStream().map( _dynamicToListType );

  }
  //#endregion Purchase

  //#region Purchase
  @override
  Stream<List<storeEntity.Store>> getAllStores([List<String> sortFields]) {

    return _dbConnector.readTable(
      tableName: storeEntity.storeTable,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListStore );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromStore(int ID) {

    return _dbConnector.readWeakRelation(
      primaryTable: storeEntity.storeTable,
      subordinateTable: purchaseEntity.purchaseTable,
      relationField: purchaseEntity.storeField,
      relationID: ID,
      selectFields: purchaseEntity.purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

  }
  //#endregion Store

  //#region System
  @override
  Stream<List<systemEntity.System>> getAllSystems([List<String> sortFields]) {

    return _dbConnector.readTable(
      tableName: systemEntity.systemTable,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListSystem );

  }

  @override
  Stream<List<platformEntity.Platform>> getPlatformsFromSystem(int ID) {

    return _dbConnector.readRelation(
      leftTableName: platformEntity.platformTable,
      rightTableName: systemEntity.systemTable,
      leftResults: true,
      relationID: ID,
    ).asStream().map( _dynamicToListPlatform );

  }
  //@endregion System

  //#region Tag
  @override
  Stream<List<tagEntity.Tag>> getAllTags([List<String> sortFields]) {

    return _dbConnector.readTable(
      tableName: tagEntity.tagTable,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListTag );

  }

  @override
  Stream<List<gameEntity.Game>> getGamesFromTag(int ID) {

    return _dbConnector.readRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: tagEntity.tagTable,
      leftResults: true,
      relationID: ID,
      selectFields: gameEntity.gameFields,
    ).asStream().map( _dynamicToListGame );

  }
  //#endregion Tag

  //#region Type
  @override
  Stream<List<typeEntity.PurchaseType>> getAllTypes([List<String> sortFields]) {

    return _dbConnector.readTable(
      tableName: typeEntity.typeTable,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListType );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromType(int ID) {

    return _dbConnector.readRelation(
      leftTableName: purchaseEntity.purchaseTable,
      rightTableName: typeEntity.typeTable,
      leftResults: true,
      relationID: ID,
      selectFields: purchaseEntity.purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

  }
  //#endregion Type
  //#endregion READ

  //#region UPDATE
  @override
  Future<dynamic> updateGame<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: gameEntity.gameTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updateDLC<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: dlcEntity.dlcTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updatePlatform<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: platformEntity.platformTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updatePurchase<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: purchaseEntity.purchaseTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updateStore<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: storeEntity.storeTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updateSystem<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: systemEntity.systemTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updateTag<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: tagEntity.tagTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updateType<T>(int ID, String fieldName, T newValue) {

    return _dbConnector.updateTable(
      tableName: typeEntity.typeTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  //#region Game
  @override
  Future<dynamic> deleteGame(int ID) {

    return _dbConnector.deleteTable(
      tableName: gameEntity.gameTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deleteGamePlatform(int gameID, int platformID) {

    return _dbConnector.deleteRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: platformEntity.platformTable,
      leftID: gameID,
      rightID: platformID,
    );

  }

  @override
  Future<dynamic> deleteGamePurchase(int gameID, int purchaseID) {

    return _dbConnector.deleteRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftID: gameID,
      rightID: purchaseID,
    );

  }

  @override
  Future<dynamic> deleteGameDLC(int dlcID) {

    return _dbConnector.updateTable(
      tableName: dlcEntity.dlcTable,
      ID: dlcID,
      fieldName: dlcEntity.baseGameField,
      newValue: null,
    );

  }

  @override
  Future<dynamic> deleteGameTag(int gameID, int tagID) {

    return _dbConnector.deleteRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: tagEntity.tagTable,
      leftID: gameID,
      rightID: tagID,
    );

  }
  //#endregion Game

  //#region DLC
  @override
  Future<dynamic> deleteDLC(int ID) {

    return _dbConnector.deleteTable(
      tableName: dlcEntity.dlcTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deleteDLCPurchase(int dlcID, int purchaseID) {

    return _dbConnector.deleteRelation(
      leftTableName: dlcEntity.dlcTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftID: dlcID,
      rightID: purchaseID,
    );

  }
  //#endregion DLC

  //#region Platform
  @override
  Future<dynamic> deletePlatform(int ID) {

    return _dbConnector.deleteTable(
      tableName: platformEntity.platformTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deletePlatformSystem(int platformID, int systemID) {

    return _dbConnector.deleteRelation(
      leftTableName: platformEntity.platformTable,
      rightTableName: systemEntity.systemTable,
      leftID: platformID,
      rightID: systemID,
    );

  }
  //#endregion Platform

  //#region Purchase
  @override
  Future<dynamic> deletePurchase(int ID) {

    return _dbConnector.deleteTable(
      tableName: purchaseEntity.purchaseTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deletePurchaseType(int purchaseID, int typeID) {

    return _dbConnector.deleteRelation(
      leftTableName: purchaseEntity.purchaseTable,
      rightTableName: typeEntity.typeTable,
      leftID: purchaseID,
      rightID: typeID,
    );

  }
  //#endregion Purchase

  //#region Store
  @override
  Future<dynamic> deleteStore(int ID) {

    return _dbConnector.deleteTable(
      tableName: storeEntity.storeTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deleteStorePurchase(int purchaseID) {

    return _dbConnector.updateTable(
      tableName: purchaseEntity.purchaseTable,
      ID: purchaseID,
      fieldName: purchaseEntity.storeField,
      newValue: null,
    );

  }
  //#endregion Store

  //#region System
  @override
  Future<dynamic> deleteSystem(int ID) {

    return _dbConnector.deleteTable(
      tableName: systemEntity.systemTable,
      ID: ID,
    );

  }
  //#endregion System

  //#region Tag
  @override
  Future<dynamic> deleteTag(int ID) {

    return _dbConnector.deleteTable(
      tableName: tagEntity.tagTable,
      ID: ID,
    );

  }
  //#endregion Tag

  //#region Type
  @override
  Future<dynamic> deleteType(int ID) {

    return _dbConnector.deleteTable(
      tableName: typeEntity.typeTable,
      ID: ID,
    );

  }
  //#endregion Type
  //#endregion DELETE

  //#region SEARCH
  Stream<List<Entity>> getSearchStream(String tableName, String query, int maxResults) {

    switch(tableName) {
      case gameEntity.gameTable:
        return getGamesWithName(query, maxResults);
      case dlcEntity.dlcTable:
        return getDLCsWithName(query, maxResults);
      case platformEntity.platformTable:
        return getPlatformsWithName(query, maxResults);
      case purchaseEntity.purchaseTable:
        return getPurchasesWithDescription(query, maxResults);
      case storeEntity.storeTable:
        return getStoresWithName(query, maxResults);
      case systemEntity.systemTable:
        return getSystemsWithName(query, maxResults);
      case tagEntity.tagTable:
        return getTagsWithName(query, maxResults);
      case typeEntity.typeTable:
        return getTypesWithName(query, maxResults);
    }
    return null;

  }

  @override
  Stream<List<gameEntity.Game>> getGamesWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: gameEntity.gameTable,
      searchField: gameEntity.nameField,
      query: nameQuery,
      fieldNames: gameEntity.gameFields,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<dlcEntity.DLC>> getDLCsWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: dlcEntity.dlcTable,
      searchField: dlcEntity.nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<platformEntity.Platform>> getPlatformsWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: platformEntity.platformTable,
      searchField: platformEntity.nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesWithDescription(String descQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: purchaseEntity.purchaseTable,
      searchField: purchaseEntity.descriptionField,
      query: descQuery,
      fieldNames: purchaseEntity.purchaseFields,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<storeEntity.Store>> getStoresWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: storeEntity.storeTable,
      searchField: storeEntity.nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListStore );

  }

  @override
  Stream<List<systemEntity.System>> getSystemsWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: systemEntity.systemTable,
      searchField: systemEntity.nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListSystem );

  }

  @override
  Stream<List<tagEntity.Tag>> getTagsWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: tagEntity.tagTable,
      searchField: tagEntity.nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListTag );

  }

  @override
  Stream<List<typeEntity.PurchaseType>> getTypesWithName(String nameQuery, int maxResults) {

    return _dbConnector.readTableSearch(
      tableName: typeEntity.typeTable,
      searchField: typeEntity.nameField,
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
      tableName: gameEntity.gameTable,
      imageName: gameID.toString(),
    );

  }
  //#endregion UPLOAD

  //#region DOWNLOAD
  @override
  String getGameCoverURL(int gameID) {

    return _imageConnector.getDownloadURL(
      tableName: gameEntity.gameTable,
      imageName: gameID.toString(),
    );

  }
  //#endregion DOWNLOAD

  //#region Dynamic Map to List
  List<gameEntity.Game> _dynamicToListGame(List<Map<String, Map<String, dynamic>>> results) {

    return gameEntity.Game.fromDynamicMapList(results);

  }

  List<dlcEntity.DLC> _dynamicToListDLC(List<Map<String, Map<String, dynamic>>> results) {

    return dlcEntity.DLC.fromDynamicMapList(results);

  }

  List<platformEntity.Platform> _dynamicToListPlatform(List<Map<String, Map<String, dynamic>>> results) {

    return platformEntity.Platform.fromDynamicMapList(results);

  }

  List<purchaseEntity.Purchase> _dynamicToListPurchase(List<Map<String, Map<String, dynamic>>> results) {

    return purchaseEntity.Purchase.fromDynamicMapList(results);

  }

  List<storeEntity.Store> _dynamicToListStore(List<Map<String, Map<String, dynamic>>> results) {

    return storeEntity.Store.fromDynamicMapList(results);

  }

  List<systemEntity.System> _dynamicToListSystem(List<Map<String, Map<String, dynamic>>> results) {

    return systemEntity.System.fromDynamicMapList(results);

  }

  List<tagEntity.Tag> _dynamicToListTag(List<Map<String, Map<String, dynamic>>> results) {

    return tagEntity.Tag.fromDynamicMapList(results);

  }

  List<typeEntity.PurchaseType> _dynamicToListType(List<Map<String, Map<String, dynamic>>> results) {

    return typeEntity.PurchaseType.fromDynamicMapList(results);

  }

  gameEntity.Game _dynamicToSingleGame(List<Map<String, Map<String, dynamic>>> results) {

    gameEntity.Game singleGame;

    if(results.isEmpty) {
      singleGame = gameEntity.Game(ID: -1);
    } else {
      singleGame = _dynamicToListGame(results).first;
    }

    return singleGame;

  }

  storeEntity.Store _dynamicToSingleStore(List<Map<String, Map<String, dynamic>>> results) {

    storeEntity.Store singleStore;

    if(results.isEmpty) {
      singleStore = storeEntity.Store(ID: -1);
    } else {
      singleStore = _dynamicToListStore(results).first;
    }

    return singleStore;

  }
  //#endregion Dynamic Map to List

}