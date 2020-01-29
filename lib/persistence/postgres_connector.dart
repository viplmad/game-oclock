import 'dart:async';

import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';

import 'db_connector.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/game.dart' as gameEntity;
import 'package:game_collection/entity/dlc.dart' as dlcEntity;
import 'package:game_collection/entity/purchase.dart' as purchaseEntity;
import 'package:game_collection/entity/platform.dart' as platformEntity;
import 'package:game_collection/entity/store.dart' as storeEntity;
import 'package:game_collection/entity/system.dart' as systemEntity;
import 'package:game_collection/entity/tag.dart' as tagEntity;
import 'package:game_collection/entity/type.dart' as typeEntity;

class PostgresConnector implements IDBConnector {

  PostgresInstance _instance;
  PostgreSQLConnection _connection;

  PostgresConnector() {

    try {
      //TODO load from json
      throw Exception();

    } catch (Exception) {
      print("json not provided, resorting to temporary connection");

      this._instance = PostgresInstance.fromString(_tempConnectionString);
    }

    _connection = new PostgreSQLConnection(
        _instance._host,
        _instance._port,
        _instance._database,
        username: _instance._user,
        password: _instance._password,
        useSSL: true,
    );

  }

  @override
  Future<dynamic> open() {

    return _connection.open();

  }

  @override
  Future<dynamic> close() {

    return _connection.close();

  }

  @override
  bool isClosed() {

    return _connection.isClosed;

  }

  @override
  bool isOpen() {

    return !this.isClosed();

  }

  @override
  bool isUpdating() {

    return _connection.queueSize != 0;

  }

  //#region Generic Queries
  Future<dynamic> _updateTable<T>({@required String tableName, @required int ID, @required String fieldName, @required T newValue}) {

    if(newValue == null) {
      return _updateTableToNull(
          tableName: tableName,
          ID: ID,
          fieldName: fieldName,
      );
    }

    String sql = _updateStatement(tableName);

    return _connection.mappedResultsQuery(sql + " SET " + _forceDoubleQuotes(fieldName) + " = @newValue WHERE " + _forceDoubleQuotes(IDField) + " = @tableID ", substitutionValues: {
      "newValue" : !(newValue is Duration)?
          newValue
          :
          //Duration is not supported, special case
          (newValue as Duration).inSeconds,
      "tableID" : ID,
    });

  }

  Future<dynamic> _updateTableToNull({@required String tableName, @required int ID, @required String fieldName}) {

    String sql = _updateStatement(tableName);

    return _connection.mappedResultsQuery(sql + " SET " + _forceDoubleQuotes(fieldName) + " = NULL WHERE " + _forceDoubleQuotes(IDField) + " = @tableID ", substitutionValues: {
      "tableID" : ID,
    });

  }

  Future<List<Map<String, Map<String, dynamic>>>> _readTableAll({@required String tableName, List<String> selectFields, Map<String, dynamic> whereFieldsAndValues, List<String> sortFields}) {

    String sql = _selectAllStatement(tableName, selectFields) + _whereStatement(whereFieldsAndValues?.keys?.toList()?? null) + _orderByStatement(sortFields);

    return _connection.mappedResultsQuery(sql, substitutionValues: whereFieldsAndValues);

  }

  Future<List<Map<String, Map<String, dynamic>>>> _readRelationAll({@required String leftTableName, @required String rightTableName, @required bool leftResults, @required int relationID, List<String> selectFields, List<String> sortFields}) {

    String relationTable = _relationTable(leftTableName, rightTableName);
    String leftIDField = _relationIDField(leftTableName);
    String rightIDField = _relationIDField(rightTableName);

    String sql = _selectJoinStatement(
        leftResults? leftTableName : rightTableName,
        relationTable,
        IDField,
        leftResults? leftIDField : rightIDField,
        selectFields,
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(leftResults? rightIDField : leftIDField) + " = @relationID " + _orderByStatement(sortFields), substitutionValues: {
      "relationID" : relationID,
    });

  }

  Future<List<Map<String, Map<String, dynamic>>>> _readWeakRelationAll({@required String primaryTable, @required String subordinateTable, @required String relationField, @required int relationID, List<String> selectFields, List<String> sortFields}) {

    String sql = _selectStatement(selectFields, 'b');

    sql += " FROM " + _forceDoubleQuotes(subordinateTable) + " b JOIN " + _forceDoubleQuotes(primaryTable) + " a "
        + " ON b." + _forceDoubleQuotes(relationField) + " = a." + _forceDoubleQuotes(IDField) + " ";

    return _connection.mappedResultsQuery(sql + " WHERE a." + _forceDoubleQuotes(IDField) + " = @relationID" + _orderByStatement(sortFields), substitutionValues: {
      "relationID" : relationID,
    });

  }

  Future<List<Map<String, Map<String, dynamic>>>> _readWithID({@required String tableName, @required int tableID, List<String> fieldNames}) {

    String sql = _selectAllStatement(tableName, fieldNames);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(IDField) + " = @tableID ", substitutionValues: {
      "tableID" : tableID,
    });

  }

  Future<List<Map<String, Map<String, dynamic>>>> _readTableSearch({@required String tableName, @required String searchField, @required String query, List<String> fieldNames, int limitResults}) {

    query = _searchableQuery(query);

    String sql = _selectAllStatement(tableName, fieldNames);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(searchField) + " ILIKE @query LIMIT " + limitResults.toString(), substitutionValues: {
      "query" : query,
    });

  }

  Future<dynamic> _insertRelation({@required String leftTableName, @required String rightTableName, @required int leftTableID, @required int rightTableID}) {

    String relationTable = _relationTable(leftTableName, rightTableName);

    String sql = _insertStatement(relationTable);

    return _connection.mappedResultsQuery(sql + " VALUES(@leftID, @rightID) ", substitutionValues: {
      "leftID" : leftTableID,
      "rightID" : rightTableID,
    });

  }

  Future<dynamic> _insertTable({@required String tableName, Map<String, dynamic> fieldAndValues}) {

    String sql = _insertStatement(tableName);

    String fieldNamesForSQL = "";
    String fieldValuesForSQL = "";
    fieldAndValues.forEach( (String fieldName, dynamic value) {

      fieldNamesForSQL += _forceDoubleQuotes(fieldName) + ", ";

      fieldValuesForSQL += "@" + fieldName + ", ";

    });
    fieldNamesForSQL = fieldNamesForSQL.substring(0, fieldNamesForSQL.length-2);
    fieldValuesForSQL = fieldValuesForSQL.substring(0, fieldValuesForSQL.length-2);

    return _connection.mappedResultsQuery(sql + " (" + fieldNamesForSQL + ") VALUES(" + fieldValuesForSQL + ") ",
        substitutionValues: fieldAndValues,
    );

  }

  Future<dynamic> _insertTableOnlyName({@required String tableName, @required String fieldName, @required String nameValue}) {

    String sql = _insertStatement(tableName) + " (" + _forceDoubleQuotes(fieldName) + ") ";

    return _connection.mappedResultsQuery(sql + " VALUES(@nameValue) ", substitutionValues: {
      "nameValue" : nameValue,
    });

  }
  
  Future<dynamic> _deleteTable({@required String tableName, @required int ID}) {

    String sql = _deleteStatement(tableName);

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(IDField) + " = @ID ", substitutionValues: {
      "ID" : ID,
    });
    
  }

  Future<dynamic> _deleteRelation({@required String leftTableName, @required String rightTableName, @required int leftID, @required int rightID}) {

    String relationTable = _relationTable(leftTableName, rightTableName);
    String leftIDField = _relationIDField(leftTableName);
    String rightIDField = _relationIDField(rightTableName);

    String sql = _deleteStatement(relationTable);

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(leftIDField) + " = @leftID AND " + _forceDoubleQuotes(rightIDField) + " = @rightID ", substitutionValues: {
      "leftID" : leftID,
      "rightID" : rightID,
    });

  }
  //#endregion Generic Queries


  //#region CREATE
    //#region Game
  @override
  Future<dynamic> insertGame(String name, String edition) {

    return _insertTable(
      tableName: gameEntity.gameTable,
      fieldAndValues: <String, dynamic> {
        gameEntity.nameField : name,
        gameEntity.editionField : edition,
      },
    );

  }

  @override
  Future<dynamic> insertGamePlatform(int gameID, int platformID) {

    return _insertRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: platformEntity.platformTable,
      leftTableID: gameID,
      rightTableID: platformID,
    );

  }

  @override
  Future<dynamic> insertGamePurchase(int gameID, int purchaseID) {

    return _insertRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftTableID: gameID,
      rightTableID: purchaseID,
    );

  }

  @override
  Future insertGameDLC(int gameID, int dlcID) {

    return _updateTable(
      tableName: dlcEntity.dlcTable,
      ID: dlcID,
      fieldName: dlcEntity.baseGameField,
      newValue: gameID,
    );

  }

  @override
  Future<dynamic> insertGameTag(int gameID, int tagID) {

    return _insertRelation(
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

    return _insertTableOnlyName(
      tableName: dlcEntity.dlcTable,
      fieldName: dlcEntity.nameField,
      nameValue: name,
    );

  }

  @override
  Future<dynamic> insertDLCPurchase(int dlcID, int purchaseID) {

    return _insertRelation(
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

    return _insertTableOnlyName(
      tableName: platformEntity.platformTable,
      fieldName: platformEntity.nameField,
      nameValue: name,
    );

  }

  @override
  Future<dynamic> insertPlatformSystem(int platformID, int systemID) {

    return _insertRelation(
      leftTableName: platformEntity.platformTable,
      rightTableName: systemEntity.systemTable,
      leftTableID: platformID,
      rightTableID: systemID,
    );

  }
    //#endregion Platform

    //#region Purchase
  Future<dynamic> insertPurchase(String description) {

    return _insertTableOnlyName(
      tableName: purchaseEntity.purchaseTable,
      fieldName: purchaseEntity.descriptionField,
      nameValue: description,
    );

  }

  @override
  Future<dynamic> insertPurchaseType(int purchaseID, int typeID) {

    return _insertRelation(
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

    return _insertTableOnlyName(
      tableName: storeEntity.storeTable,
      fieldName: storeEntity.nameField,
      nameValue: name,
    );

  }

  @override
  Future<dynamic> insertStorePurchase(int storeID, int purchaseID) {

    return _updateTable(
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

    return _insertTableOnlyName(
      tableName: systemEntity.systemTable,
      fieldName: systemEntity.nameField,
      nameValue: name,
    );

  }
    //#endregion System

    //#region Tag
  @override
  Future<dynamic> insertTag(String name) {

    return _insertTableOnlyName(
      tableName: tagEntity.tagTable,
      fieldName: tagEntity.nameField,
      nameValue: name,
    );

  }
    //#endregion Tag

    //#region Type
  @override
  Future<dynamic> insertType(String name) {

    return _insertTableOnlyName(
      tableName: typeEntity.typeTable,
      fieldName: typeEntity.nameField,
      nameValue: name,
    );

  }
    //#endregion Type
  //#endregion CREATE

  //#region READ
    //#region Game
  @override
  Stream<List<gameEntity.Game>> getAllGames([List<String> sortFields = const [gameEntity.releaseYearField, gameEntity.nameField]]) {

    return _readTableAll(
      tableName: gameEntity.gameTable,
      selectFields: gameEntity.gameFields,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<platformEntity.Platform>> getPlatformsFromGame(int ID) {

    return _readRelationAll(
      leftTableName: gameEntity.gameTable,
      rightTableName: platformEntity.platformTable,
      leftResults: false,
      relationID: ID,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromGame(int ID) {

    return _readRelationAll(
      leftTableName: gameEntity.gameTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftResults: false,
      relationID: ID,
      selectFields: purchaseEntity.purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<dlcEntity.DLC>> getDLCsFromGame(int ID) {

    return _readWeakRelationAll(
      primaryTable: gameEntity.gameTable,
      subordinateTable: dlcEntity.dlcTable,
      relationField: dlcEntity.baseGameField,
      relationID: ID,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<tagEntity.Tag>> getTagsFromGame(int ID) {

    return _readRelationAll(
      leftTableName: gameEntity.gameTable,
      rightTableName: tagEntity.tagTable,
      leftResults: false,
      relationID: ID,
    ).asStream().map( _dynamicToListTag );

  }
    //#endregion Game

    //#region DLC
  @override
  Stream<List<dlcEntity.DLC>> getAllDLCs([List<String> sortFields = const [dlcEntity.releaseYearField, dlcEntity.nameField]]) {

    return _readTableAll(
      tableName: dlcEntity.dlcTable,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<gameEntity.Game> getBaseGameFromDLC(int baseGameID) {

    return _readWithID(
      tableName: gameEntity.gameTable,
      tableID: baseGameID,
      fieldNames: gameEntity.gameFields,
    ).asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromDLC(int ID) {

    return _readRelationAll(
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
  Stream<List<platformEntity.Platform>> getAllPlatforms([List<String> sortFields = const [platformEntity.typeField, platformEntity.nameField]]) {

    return _readTableAll(
      tableName: platformEntity.platformTable,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<gameEntity.Game>> getGamesFromPlatform(int ID) {

    return _readRelationAll(
      leftTableName: gameEntity.gameTable,
      rightTableName: platformEntity.platformTable,
      leftResults: true,
      relationID: ID,
      selectFields: gameEntity.gameFields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<systemEntity.System>> getSystemsFromPlatform(int ID) {

    return _readRelationAll(
      leftTableName: platformEntity.platformTable,
      rightTableName: systemEntity.systemTable,
      leftResults: false,
      relationID: ID,
    ).asStream().map( _dynamicToListSystem );

  }
    //#endregion Platform

    //#region Purchase
  @override
  Stream<List<purchaseEntity.Purchase>> getAllPurchases([List<String> sortFields = const [purchaseEntity.dateField, purchaseEntity.descriptionField]]) {

    return _readTableAll(
      tableName: purchaseEntity.purchaseTable,
      selectFields: purchaseEntity.purchaseFields,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<storeEntity.Store> getStoreFromPurchase(int storeID) {

    return _readWithID(
      tableName: storeEntity.storeTable,
      tableID: storeID,
    ).asStream().map( _dynamicToSingleStore );

  }

  @override
  Stream<List<gameEntity.Game>> getGamesFromPurchase(int ID) {

    return _readRelationAll(
      leftTableName: gameEntity.gameTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftResults: true,
      relationID: ID,
      selectFields: gameEntity.gameFields,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<dlcEntity.DLC>> getDLCsFromPurchase(int ID) {

    return _readRelationAll(
      leftTableName: dlcEntity.dlcTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftResults: true,
      relationID: ID,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<typeEntity.PurchaseType>> getTypesFromPurchase(int ID) {

    return _readRelationAll(
      leftTableName: purchaseEntity.purchaseTable,
      rightTableName: typeEntity.typeTable,
      leftResults: false,
      relationID: ID,
    ).asStream().map( _dynamicToListType );

  }
    //#endregion Purchase

    //#region Purchase
  @override
  Stream<List<storeEntity.Store>> getAllStores([List<String> sortFields = const [storeEntity.nameField]]) {

    return _readTableAll(
      tableName: storeEntity.storeTable,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListStore );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromStore(int ID) {

    return _readWeakRelationAll(
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
  Stream<List<systemEntity.System>> getAllSystems([List<String> sortFields = const [systemEntity.generationField, systemEntity.manufacturerField]]) {

    return _readTableAll(
      tableName: systemEntity.systemTable,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListSystem );

  }

  @override
  Stream<List<platformEntity.Platform>> getPlatformsFromSystem(int ID) {

    return _readRelationAll(
      leftTableName: platformEntity.platformTable,
      rightTableName: systemEntity.systemTable,
      leftResults: true,
      relationID: ID,
    ).asStream().map( _dynamicToListPlatform );

  }
    //@endregion System

    //#region Tag
  @override
  Stream<List<tagEntity.Tag>> getAllTags([List<String> sortFields = const [tagEntity.nameField]]) {

    return _readTableAll(
      tableName: tagEntity.tagTable,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListTag );

  }

  @override
  Stream<List<gameEntity.Game>> getGamesFromTag(int ID) {

    return _readRelationAll(
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
  Stream<List<typeEntity.PurchaseType>> getAllTypes([List<String> sortFields = const [typeEntity.nameField]]) {

    return _readTableAll(
      tableName: typeEntity.typeTable,
      sortFields: sortFields,
    ).asStream().map( _dynamicToListType );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromType(int ID) {

    return _readRelationAll(
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

    return _updateTable(
      tableName: gameEntity.gameTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updateDLC<T>(int ID, String fieldName, T newValue) {

    return _updateTable(
      tableName: dlcEntity.dlcTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updatePlatform<T>(int ID, String fieldName, T newValue) {

    return _updateTable(
      tableName: platformEntity.platformTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updatePurchase<T>(int ID, String fieldName, T newValue) {

    return _updateTable(
      tableName: purchaseEntity.purchaseTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updateStore<T>(int ID, String fieldName, T newValue) {

    return _updateTable(
      tableName: storeEntity.storeTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updateSystem<T>(int ID, String fieldName, T newValue) {

    return _updateTable(
      tableName: systemEntity.systemTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updateTag<T>(int ID, String fieldName, T newValue) {

    return _updateTable(
      tableName: tagEntity.tagTable,
      ID: ID,
      fieldName: fieldName,
      newValue: newValue,
    );

  }

  @override
  Future<dynamic> updateType<T>(int ID, String fieldName, T newValue) {

    return _updateTable(
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

    return _deleteTable(
      tableName: gameEntity.gameTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deleteGamePlatform(int gameID, int platformID) {

    return _deleteRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: platformEntity.platformTable,
      leftID: gameID,
      rightID: platformID,
    );

  }

  @override
  Future<dynamic> deleteGamePurchase(int gameID, int purchaseID) {

    return _deleteRelation(
      leftTableName: gameEntity.gameTable,
      rightTableName: purchaseEntity.purchaseTable,
      leftID: gameID,
      rightID: purchaseID,
    );

  }

  @override
  Future<dynamic> deleteGameDLC(int dlcID) {

    return _updateTableToNull(
      tableName: dlcEntity.dlcTable,
      ID: dlcID,
      fieldName: dlcEntity.baseGameField,
    );

  }

  @override
  Future<dynamic> deleteGameTag(int gameID, int tagID) {

    return _deleteRelation(
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

    return _deleteTable(
      tableName: dlcEntity.dlcTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deleteDLCPurchase(int dlcID, int purchaseID) {

    return _deleteRelation(
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

    return _deleteTable(
      tableName: platformEntity.platformTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deletePlatformSystem(int platformID, int systemID) {

    return _deleteRelation(
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

    return _deleteTable(
      tableName: purchaseEntity.purchaseTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deletePurchaseType(int purchaseID, int typeID) {

    return _deleteRelation(
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

    return _deleteTable(
      tableName: storeEntity.storeTable,
      ID: ID,
    );

  }

  @override
  Future<dynamic> deleteStorePurchase(int purchaseID) {

    return _updateTableToNull(
      tableName: purchaseEntity.purchaseTable,
      ID: purchaseID,
      fieldName: purchaseEntity.storeField,
    );

  }
    //#endregion Store

    //#region System
  @override
  Future<dynamic> deleteSystem(int ID) {

    return _deleteTable(
      tableName: systemEntity.systemTable,
      ID: ID,
    );

  }
    //#endregion System

    //#region Tag
  @override
  Future<dynamic> deleteTag(int ID) {

    return _deleteTable(
      tableName: tagEntity.tagTable,
      ID: ID,
    );

  }
    //#endregion Tag

    //#region Type
  @override
  Future<dynamic> deleteType(int ID) {

    return _deleteTable(
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

    return _readTableSearch(
      tableName: gameEntity.gameTable,
      searchField: gameEntity.nameField,
      query: nameQuery,
      fieldNames: gameEntity.gameFields,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<dlcEntity.DLC>> getDLCsWithName(String nameQuery, int maxResults) {

    return _readTableSearch(
      tableName: dlcEntity.dlcTable,
      searchField: dlcEntity.nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<platformEntity.Platform>> getPlatformsWithName(String nameQuery, int maxResults) {

    return _readTableSearch(
      tableName: platformEntity.platformTable,
      searchField: platformEntity.nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesWithDescription(String descQuery, int maxResults) {

    return _readTableSearch(
      tableName: purchaseEntity.purchaseTable,
      searchField: purchaseEntity.descriptionField,
      query: descQuery,
      fieldNames: purchaseEntity.purchaseFields,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<storeEntity.Store>> getStoresWithName(String nameQuery, int maxResults) {

    return _readTableSearch(
      tableName: storeEntity.storeTable,
      searchField: storeEntity.nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListStore );

  }

  @override
  Stream<List<systemEntity.System>> getSystemsWithName(String nameQuery, int maxResults) {

    return _readTableSearch(
      tableName: systemEntity.systemTable,
      searchField: systemEntity.nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListSystem );

  }

  @override
  Stream<List<tagEntity.Tag>> getTagsWithName(String nameQuery, int maxResults) {

    return _readTableSearch(
      tableName: tagEntity.tagTable,
      searchField: tagEntity.nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListTag );

  }

  @override
  Stream<List<typeEntity.PurchaseType>> getTypesWithName(String nameQuery, int maxResults) {

    return _readTableSearch(
      tableName: typeEntity.typeTable,
      searchField: typeEntity.nameField,
      query: nameQuery,
      limitResults: maxResults,
    ).asStream().map( _dynamicToListType );

  }
  //#endregion SEARCH


  //#region Helpers
  String _selectStatement([List<String> fieldNames, String alias = '']) {

    String selection = ' * ';
    if(fieldNames != null) {
      selection = _formatSelectionFields(fieldNames, alias);
    }

    return "SELECT " + selection;

  }

  String _selectAllStatement(String table, [List<String> fieldNames]) {

    return _selectStatement(fieldNames) + " FROM " + _forceDoubleQuotes(table);

  }

  String _selectJoinStatement(String leftTable, String rightTable, String leftTableID, String rightTableID, [List<String> selectFields]) {

    return _selectStatement(selectFields) + " FROM \"" + leftTable + "\" JOIN \"" + rightTable + "\" ON \"" + leftTableID + "\" = \"" + rightTableID + "\" ";

  }

  String _orderByStatement(List<String> sortFields) {

    return sortFields != null? " ORDER BY " + _forceFieldsDoubleQuotes(sortFields).join(", ") : "";

  }

  String _whereStatement(List<String> filterFields) {

    if(filterFields != null) {

      String filterForSQL;
      filterFields.forEach( (String fieldName) {

        filterForSQL += _forceDoubleQuotes(fieldName) + " = @" + fieldName + " AND ";

      });
      //Remove trailing AND
      filterForSQL = filterForSQL.substring(0, filterForSQL.length-4);

      return " WHERE " + filterForSQL;
    }

    return "";

  }

  String _updateStatement(String table) {

    return "UPDATE " + _forceDoubleQuotes(table);

  }

  String _insertStatement(String table) {

    return "INSERT INTO " + _forceDoubleQuotes(table);

  }

  String _deleteStatement(String table) {

    return "DELETE FROM " + _forceDoubleQuotes(table);

  }

  String _searchableQuery(String query) {

    return " %" + query + "% ";

  }

  String _forceDoubleQuotes(String text) {

    return "\"" + text + "\"";

  }

  List<String> _forceFieldsDoubleQuotes(List<String> fields) {

    return fields.map( (String field) => _forceDoubleQuotes(field) ).toList();

  }

  String _formatSelectionFields(List<String> fieldNames, [String alias = '']) {

    alias = (alias != null && alias != '')? alias + '.' : '';

    String fieldNamesForSQL = "";
    fieldNames.forEach( (String fieldName) {

      String _formattedField = alias + _forceDoubleQuotes(fieldName);

      if(fieldName == purchaseEntity.priceField
          || fieldName == purchaseEntity.externalCreditField
          || fieldName == purchaseEntity.originalPriceField) {

        fieldNamesForSQL += _formattedField + "::float";

      } else if(fieldName == gameEntity.timeField) {

        fieldNamesForSQL += "(Extract(hours from " + _formattedField + ") * 60 + EXTRACT(minutes from " + _formattedField + "))::int AS " + _formattedField;

      } else {

        fieldNamesForSQL += _formattedField;

      }

      fieldNamesForSQL += ", ";

    });
    //Remove trailing comma
    fieldNamesForSQL = fieldNamesForSQL.substring(0, fieldNamesForSQL.length-2);

    return fieldNamesForSQL;

  }

  String _relationTable(String leftTable, String rightTable) {

    return leftTable + "-" + rightTable;

  }

  String _relationIDField(String table) {

    return table + "_" + IDField;

  }
  //#endregion Helpers

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


const herokuURIPattern = "^postgres:\\\/\\\/(?<user>[^:]*):(?<pass>[^@]*)@(?<host>[^:]*):(?<port>[^\\\/]*)\\\/(?<db>[^\/]*)\$";
const String _tempConnectionString = "***REMOVED***";

class PostgresInstance {

  final String _host;
  final int _port;
  final String _database;
  final String _user;
  final String _password;

  PostgresInstance._(this._host, this._port, this._database, this._user, this._password);

  factory PostgresInstance.fromString(String connectionString) {

    RegExp pattern = RegExp(herokuURIPattern);

    RegExpMatch match = pattern.firstMatch(connectionString);

    if (match == null) {
      throw Exception("Could not parse Postgres connection string.");
    }

    return PostgresInstance._(
      match.namedGroup('host'),
      int.parse(match.namedGroup('port')),
      match.namedGroup('db'),
      match.namedGroup('user'),
      match.namedGroup('pass'),
    );

  }

}