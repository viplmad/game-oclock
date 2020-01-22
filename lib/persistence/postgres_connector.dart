import 'dart:async';
import 'dart:io' as io;

import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';

import 'db_conector.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/game.dart' as gameEntity;
import 'package:game_collection/entity/dlc.dart' as dlcEntity;
import 'package:game_collection/entity/purchase.dart' as purchaseEntity;
import 'package:game_collection/entity/platform.dart' as platformEntity;
import 'package:game_collection/entity/store.dart' as storeEntity;
import 'package:game_collection/entity/system.dart' as systemEntity;
import 'package:game_collection/entity/tag.dart' as tagEntity;
import 'package:game_collection/entity/type.dart' as typeEntity;

const herokuURIPattern = "^postgres:\\\/\\\/(?<user>[^:]*):(?<pass>[^@]*)@(?<host>[^:]*):(?<port>[^\\\/]*)\\\/(?<db>[^\/]*)\$";

class PostgresConnector implements DBConnector {

  final String _tempConnectionString = "***REMOVED***";

  PostgresInstance _instance;
  PostgreSQLConnection _connection;

  static PostgresConnector _singleton;

  static PostgresConnector getConnector() {
    if (_singleton == null) {
      _singleton = PostgresConnector();
    }

    return _singleton;
  }

  PostgresConnector() {
    try {
      String valueFromHeroku = io.Platform.environment["DATABASE_URL"];

      this._instance = PostgresInstance.fromString(valueFromHeroku);
    } catch (Exception) {
      print("DATABASE_URL not set up, resorting to backup");

      this._instance = PostgresInstance.fromString(_tempConnectionString);
    }

    _connection = new PostgreSQLConnection(
        _instance.host,
        _instance.port,
        _instance.database,
        username: _instance.user,
        password: _instance.password,
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

    return !_connection.isClosed;

  }

  @override
  bool isUpdating() {

    //TODO
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
      "newValue" : newValue,
      "tableID" : ID,
    });

  }

  Future<dynamic> _updateTableToNull({@required String tableName, @required int ID, @required String fieldName}) {

    String sql = _updateStatement(tableName);

    return _connection.mappedResultsQuery(sql + " SET " + _forceDoubleQuotes(fieldName) + " = NULL WHERE " + _forceDoubleQuotes(IDField) + " = @tableID ", substitutionValues: {
      "tableID" : ID,
    });

  }

  Future<List<Map<String, Map<String, dynamic>>>> _readTableAll({@required String tableName}) {

    String sql = _selectAllStatement(tableName);

    return _connection.mappedResultsQuery(sql);

  }

  Future<List<Map<String, Map<String, dynamic>>>> _readTableSelection({@required String tableName, @required List<String> fieldNames}) {

    String sql = "SELECT ";

    String fieldNamesForSQL = "";
    fieldNames.forEach( (String fieldName) {

      String _formattedField = _forceDoubleQuotes(fieldName);

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
    
    sql += fieldNamesForSQL + " FROM " + _forceDoubleQuotes(tableName); 

    return _connection.mappedResultsQuery(sql);

  }

  Future<List<Map<String, Map<String, dynamic>>>> _readRelationAll({@required String leftTableName, @required String rightTableName, @required bool leftResults, @required int relationID}) {

    String relationTable = _relationTable(leftTableName, rightTableName);
    String leftIDField = _relationIDField(leftTableName);
    String rightIDField = _relationIDField(rightTableName);

    String sql = _selectJoinStatement(
        leftResults? leftTableName : rightTableName,
        relationTable,
        IDField,
        leftResults? leftIDField : rightIDField,
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(leftResults? rightIDField : leftIDField) + " = @relationID ", substitutionValues: {
      "relationID" : relationID,
    });

  }

  Future<List<Map<String, Map<String, dynamic>>>> _readWeakRelationAll({@required String primaryTable, @required String subordinateTable, @required String relationField, @required int relationID}) {

    String sql = "SELECT * ";

    sql += "FROM " + _forceDoubleQuotes(subordinateTable) + " b JOIN " + _forceDoubleQuotes(primaryTable) + " a "
        + " ON b." + _forceDoubleQuotes(relationField) + " = a." + _forceDoubleQuotes(IDField) + " ";

    return _connection.mappedResultsQuery(sql + " WHERE a." + _forceDoubleQuotes(IDField) + " = @relationID", substitutionValues: {
      "relationID" : relationID,
    });

  }

  Future<List<Map<String, Map<String, dynamic>>>> _readWithID({@required String tableName, @required int tableID}) {

    String sql = _selectAllStatement(tableName);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(IDField) + " = @tableID ", substitutionValues: {
      "tableID" : tableID,
    });

  }

  Future<List<Map<String, Map<String, dynamic>>>> _readTableSearch({@required String tableName, @required String searchField, @required String query}) {

    query = _searchableQuery(query);

    String sql = _selectAllStatement(tableName);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(searchField) + " ILIKE @query ", substitutionValues: {
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
  Stream<List<gameEntity.Game>> getAllGames() {

    return _readTableSelection(
        tableName: gameEntity.gameTable,
        fieldNames: gameEntity.gameFields,
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
  Stream<List<dlcEntity.DLC>> getAllDLCs() {

    return _readTableAll(
        tableName: dlcEntity.dlcTable,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<gameEntity.Game> getBaseGameFromDLC(int baseGameID) {

    return _readWithID(
        tableName: gameEntity.gameTable,
        tableID: baseGameID,
    ).asStream().map( _dynamicToSingleGame );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromDLC(int ID) {

    return _readRelationAll(
        leftTableName: dlcEntity.dlcTable,
        rightTableName: purchaseEntity.purchaseTable,
        leftResults: false,
        relationID: ID,
    ).asStream().map( _dynamicToListPurchase );

  }
    //#endregion DLC

    //#region Platform
  @override
  Stream<List<platformEntity.Platform>> getAllPlatforms() {

    return _readTableAll(
        tableName: platformEntity.platformTable,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<gameEntity.Game>> getGamesFromPlatform(int ID) {

    return _readRelationAll(
        leftTableName: gameEntity.gameTable,
        rightTableName: platformEntity.platformTable,
        leftResults: true,
        relationID: ID,
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
  Stream<List<purchaseEntity.Purchase>> getAllPurchases() {

    return _readTableSelection(
        tableName: purchaseEntity.purchaseTable,
        fieldNames: purchaseEntity.purchaseFields,
    ).asStream().map( _dynamicToListPurchase );

    /*return _readTableAll(
        tableName: purchaseEntity.purchaseTable,
    ).asStream().map( _dynamicToListPurchase );*/

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
  Stream<List<storeEntity.Store>> getAllStores() {

    return _readTableAll(
        tableName: storeEntity.storeTable,
    ).asStream().map( _dynamicToListStore );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromStore(int ID) {

    return _readWeakRelationAll(
      primaryTable: storeEntity.storeTable,
      subordinateTable: purchaseEntity.purchaseTable,
      relationField: purchaseEntity.storeField,
      relationID: ID,
    ).asStream().map( _dynamicToListPurchase );

  }
    //#endregion Store

    //#region System
  @override
  Stream<List<systemEntity.System>> getAllSystems() {

    return _readTableAll(
        tableName: systemEntity.systemTable,
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
  Stream<List<tagEntity.Tag>> getAllTags() {

    return _readTableAll(
        tableName: tagEntity.tagTable,
    ).asStream().map( _dynamicToListTag );

  }

  @override
  Stream<List<gameEntity.Game>> getGamesFromTag(int ID) {

    return _readRelationAll(
        leftTableName: gameEntity.gameTable,
        rightTableName: tagEntity.tagTable,
        leftResults: true,
        relationID: ID,
    ).asStream().map( _dynamicToListGame );

  }
    //#endregion Tag

    //#region Type
  @override
  Stream<List<typeEntity.PurchaseType>> getAllTypes() {

    return _readTableAll(
        tableName: typeEntity.typeTable,
    ).asStream().map( _dynamicToListType );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromType(int ID) {

    return _readRelationAll(
        leftTableName: purchaseEntity.purchaseTable,
        rightTableName: typeEntity.typeTable,
        leftResults: true,
        relationID: ID,
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
  Stream<List<Entity>> getSearchStream(String tableName, String query) {

    switch(tableName) {
      case gameEntity.gameTable:
        return getGamesWithName(query);
      case dlcEntity.dlcTable:
        return getDLCsWithName(query);
      case platformEntity.platformTable:
        return getPlatformsWithName(query);
      case purchaseEntity.purchaseTable:
        return getPurchasesWithDescription(query);
      case storeEntity.storeTable:
        return getStoresWithName(query);
      case systemEntity.systemTable:
        return getSystemsWithName(query);
      case tagEntity.tagTable:
        return getTagsWithName(query);
      case typeEntity.typeTable:
        return getTypesWithName(query);
    }
    return null;

  }

  @override
  Stream<List<gameEntity.Game>> getGamesWithName(String nameQuery) {

    return _readTableSearch(
        tableName: gameEntity.gameTable,
        searchField: gameEntity.nameField,
        query: nameQuery,
    ).asStream().map( _dynamicToListGame );

  }

  @override
  Stream<List<dlcEntity.DLC>> getDLCsWithName(String nameQuery) {

    return _readTableSearch(
      tableName: dlcEntity.dlcTable,
      searchField: dlcEntity.nameField,
      query: nameQuery,
    ).asStream().map( _dynamicToListDLC );

  }

  @override
  Stream<List<platformEntity.Platform>> getPlatformsWithName(String nameQuery) {

    return _readTableSearch(
      tableName: platformEntity.platformTable,
      searchField: platformEntity.nameField,
      query: nameQuery,
    ).asStream().map( _dynamicToListPlatform );

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesWithDescription(String descQuery) {

    return _readTableSearch(
      tableName: purchaseEntity.purchaseTable,
      searchField: purchaseEntity.descriptionField,
      query: descQuery,
    ).asStream().map( _dynamicToListPurchase );

  }

  @override
  Stream<List<storeEntity.Store>> getStoresWithName(String nameQuery) {

    return _readTableSearch(
      tableName: storeEntity.storeTable,
      searchField: storeEntity.nameField,
      query: nameQuery,
    ).asStream().map( _dynamicToListStore );

  }

  @override
  Stream<List<systemEntity.System>> getSystemsWithName(String nameQuery) {

    return _readTableSearch(
      tableName: systemEntity.systemTable,
      searchField: systemEntity.nameField,
      query: nameQuery,
    ).asStream().map( _dynamicToListSystem );

  }

  @override
  Stream<List<tagEntity.Tag>> getTagsWithName(String nameQuery) {

    return _readTableSearch(
      tableName: tagEntity.tagTable,
      searchField: tagEntity.nameField,
      query: nameQuery,
    ).asStream().map( _dynamicToListTag );

  }

  @override
  Stream<List<typeEntity.PurchaseType>> getTypesWithName(String nameQuery) {

    return _readTableSearch(
      tableName: typeEntity.typeTable,
      searchField: typeEntity.nameField,
      query: nameQuery,
    ).asStream().map( _dynamicToListType );

  }
  //#endregion SEARCH


  //#region Helpers
  String _selectAllStatement(String table) {

    return "SELECT * FROM " + _forceDoubleQuotes(table);

  }

  String _selectJoinStatement(String leftTable, String rightTable, String leftTableID, String rightTableID, [String select = "Select * "]) {

    return select + " FROM \"" + leftTable + "\" JOIN \"" + rightTable + "\" ON \"" + leftTableID + "\" = \"" + rightTableID + "\" ";

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

    return "%" + query + "%";

  }

  String _forceDoubleQuotes(String text) {

    return "\"" + text + "\"";

  }

  List<String> _forceFieldsDoubleQuotes(List<String> fields) {

    return fields.map( (String field) => _forceDoubleQuotes(field) ).toList();

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
      singleGame = gameEntity.Game.fromDynamicMap(results[0][gameEntity.gameTable]);
    }

    return singleGame;

  }

  storeEntity.Store _dynamicToSingleStore(List<Map<String, Map<String, dynamic>>> results) {

    storeEntity.Store singleStore;

    if(results.isEmpty) {
      singleStore = storeEntity.Store(ID: -1);
    } else {
      singleStore = storeEntity.Store.fromDynamicMap(results[0][storeEntity.storeTable]);
    }

    return singleStore;

  }
  //#endregion Dynamic Map to List

}

class PostgresInstance {
  final String host;
  final int port;
  final String database;
  final String user;
  final String password;

  PostgresInstance(this.host, this.port, this.database, this.user, this.password);

  factory PostgresInstance.fromString(String connectionString) {
    RegExp pattern = RegExp(herokuURIPattern);

    RegExpMatch match = pattern.firstMatch(connectionString);

    if (match == null)
      throw Exception("Could not parse Postgres connection string.");

    return PostgresInstance(
      match.namedGroup('host'),
      int.parse(match.namedGroup('port')),
      match.namedGroup('db'),
      match.namedGroup('user'),
      match.namedGroup('pass'),
    );
  }
}