import 'dart:async';
import 'dart:io' as io;
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
  Stream<List<gameEntity.Game>> getAllGames() {

    String sql = _allQuery(gameEntity.gameTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return gameEntity.Game.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<platformEntity.Platform>> getPlatformsFromGame(int ID) {

    String relationTable = _relationTable(gameEntity.gameTable, platformEntity.platformTable);
    String gameIDField = _relationIDField(gameEntity.gameTable);
    String platformIDField = _relationIDField(platformEntity.platformTable);

    String sql = _joinQuery(
        platformEntity.platformTable,
        relationTable,
        IDField,
        platformIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(gameIDField) + " = @gameID ", substitutionValues: {
      "gameID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return platformEntity.Platform.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromGame(int ID) {

    String relationTable = _relationTable(gameEntity.gameTable, purchaseEntity.purchaseTable);
    String gameIDField = _relationIDField(gameEntity.gameTable);
    String purchaseIDField = _relationIDField(purchaseEntity.purchaseTable);

    String sql = _joinQuery(
        purchaseEntity.purchaseTable,
        relationTable,
        IDField,
        purchaseIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(gameIDField) + " = @gameID ", substitutionValues: {
      "gameID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return purchaseEntity.Purchase.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<dlcEntity.DLC>> getDLCsFromGame(int ID) {

    String sql = "SELECT * ";

    sql += "FROM " + _forceDoubleQuotes(dlcEntity.dlcTable) + " d JOIN " + _forceDoubleQuotes(gameEntity.gameTable) + " g "
        + " ON d." + _forceDoubleQuotes(dlcEntity.baseGameField) + " = g." + _forceDoubleQuotes(IDField) + " ";

    return _connection.mappedResultsQuery(sql + " WHERE g." + _forceDoubleQuotes(IDField) + " = @gameID", substitutionValues: {
      "gameID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return dlcEntity.DLC.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<tagEntity.Tag>> getTagsFromGame(int ID) {

    String relationTable = _relationTable(gameEntity.gameTable, tagEntity.tagTable);
    String gameIDField = _relationIDField(gameEntity.gameTable);
    String tagIDField = _relationIDField(tagEntity.tagTable);

    String sql = _joinQuery(
        tagEntity.tagTable,
        relationTable,
        IDField,
        tagIDField
    );
    
    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(gameIDField) + " = @gameID ", substitutionValues: {
      "gameID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return tagEntity.Tag.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<dlcEntity.DLC>> getAllDLCs() {

    String sql = _allQuery(dlcEntity.dlcTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return dlcEntity.DLC.fromDynamicMapList(results);

    });

  }

  @override
  Stream<gameEntity.Game> getBaseGameFromDLC(int baseGameID) {

    String sql = _allQuery(gameEntity.gameTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(IDField) + " = @baseGameID ", substitutionValues: {
      "baseGameID" : baseGameID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {
      gameEntity.Game baseGame;

      if(results.isEmpty) {
        baseGame = gameEntity.Game(ID: -1);
      } else {
        baseGame = gameEntity.Game.fromDynamicMap(results[0][gameEntity.gameTable]);
      }

      return baseGame;
    });

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromDLC(int ID) {

    String relationTable = _relationTable(dlcEntity.dlcTable, purchaseEntity.purchaseTable);
    String purchaseIDField = _relationIDField(purchaseEntity.purchaseTable);
    String dlcIDField = _relationIDField(dlcEntity.dlcTable);

    String sql = _joinQuery(
        purchaseEntity.purchaseTable,
        relationTable,
        IDField,
        purchaseIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(dlcIDField) + " = @dlcID ", substitutionValues: {
      "dlcID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return purchaseEntity.Purchase.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<platformEntity.Platform>> getAllPlatforms() {

    String sql = _allQuery(platformEntity.platformTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return platformEntity.Platform.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<gameEntity.Game>> getGamesFromPlatform(int ID) {

    String relationTable = _relationTable(gameEntity.gameTable, platformEntity.platformTable);
    String gameIDField = _relationIDField(gameEntity.gameTable);
    String platformIDField = _relationIDField(platformEntity.platformTable);

    String sql = _joinQuery(
        gameEntity.gameTable,
        relationTable,
        IDField,
        gameIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(platformIDField) + " = @platformID ", substitutionValues: {
      "platformID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return gameEntity.Game.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<systemEntity.System>> getSystemsFromPlatform(int ID) {

    String relationTable = _relationTable(platformEntity.platformTable, systemEntity.systemTable);
    String platformIDField = _relationIDField(platformEntity.platformTable);
    String systemIDField = _relationIDField(systemEntity.systemTable);

    String sql = _joinQuery(
        systemEntity.systemTable,
        relationTable,
        IDField,
        systemIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(platformIDField) + " = @platformID ", substitutionValues: {
      "platformID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return systemEntity.System.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getAllPurchases() {

    String sql = _allQuery(purchaseEntity.purchaseTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return purchaseEntity.Purchase.fromDynamicMapList(results);

    });

  }

  @override
  Stream<storeEntity.Store> getStoreFromPurchase(int storeID) {

    String sql = _allQuery(storeEntity.storeTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(IDField) + " = @storeID ", substitutionValues: {
      "storeID" : storeID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {
      storeEntity.Store purchaseStore;

      if(results.isEmpty) {
        purchaseStore = storeEntity.Store(ID: -1);
      } else {
        purchaseStore = storeEntity.Store.fromDynamicMap(results[0][storeEntity.storeTable]);
      }

      return purchaseStore;
    });

  }

  @override
  Stream<List<gameEntity.Game>> getGamesFromPurchase(int ID) {

    String relationTable = _relationTable(gameEntity.gameTable, purchaseEntity.purchaseTable);
    String gameIDField = _relationIDField(gameEntity.gameTable);
    String purchaseIDField = _relationIDField(purchaseEntity.purchaseTable);

    String sql = _joinQuery(
        gameEntity.gameTable,
        relationTable,
        IDField,
        gameIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(purchaseIDField) + " = @purchaseID ", substitutionValues: {
      "purchaseID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return gameEntity.Game.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<dlcEntity.DLC>> getDLCsFromPurchase(int ID) {

    String relationTable = _relationTable(dlcEntity.dlcTable, purchaseEntity.purchaseTable);
    String purchaseIDField = _relationIDField(purchaseEntity.purchaseTable);
    String dlcIDField = _relationIDField(dlcEntity.dlcTable);

    String sql = _joinQuery(
        dlcEntity.dlcTable,
        relationTable,
        IDField,
        dlcIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(purchaseIDField) + " = @purchaseID ", substitutionValues: {
      "purchaseID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return dlcEntity.DLC.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<typeEntity.PurchaseType>> getTypesFromPurchase(int ID) {

    String relationTable = _relationTable(purchaseEntity.purchaseTable, typeEntity.typeTable);
    String purchaseIDField = _relationIDField(purchaseEntity.purchaseTable);
    String typeIDField = _relationIDField(typeEntity.typeTable);

    String sql = _joinQuery(
        typeEntity.typeTable,
        relationTable,
        IDField,
        typeIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(purchaseIDField) + " = @purchaseID ", substitutionValues: {
      "purchaseID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return typeEntity.PurchaseType.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<storeEntity.Store>> getAllStores() {

    String sql = _allQuery(storeEntity.storeTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return storeEntity.Store.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromStore(int ID) {

    String sql = "SELECT * ";

    sql += "FROM " + _forceDoubleQuotes(purchaseEntity.purchaseTable) + " p JOIN " + _forceDoubleQuotes(storeEntity.storeTable) + " s "
        + " ON p." + _forceDoubleQuotes(purchaseEntity.storeField) + " = s." + _forceDoubleQuotes(IDField) + " ";

    return _connection.mappedResultsQuery(sql + " WHERE s." + _forceDoubleQuotes(IDField) + " = @storeID", substitutionValues: {
      "storeID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return purchaseEntity.Purchase.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<systemEntity.System>> getAllSystems() {

    String sql = _allQuery(systemEntity.systemTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return systemEntity.System.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<platformEntity.Platform>> getPlatformsFromSystem(int ID) {

    String relationTable = _relationTable(platformEntity.platformTable, systemEntity.systemTable);
    String platformIDField = _relationIDField(platformEntity.platformTable);
    String systemIDField = _relationIDField(systemEntity.systemTable);

    String sql = _joinQuery(
        platformEntity.platformTable,
        relationTable,
        IDField,
        platformIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(systemIDField) + " = @systemID ", substitutionValues: {
      "systemID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return platformEntity.Platform.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<tagEntity.Tag>> getAllTags() {

    String sql = _allQuery(tagEntity.tagTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return tagEntity.Tag.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<gameEntity.Game>> getGamesFromTag(int ID) {

    String relationTable = _relationTable(gameEntity.gameTable, tagEntity.tagTable);
    String gameIDField = _relationIDField(gameEntity.gameTable);
    String tagIDField = _relationIDField(tagEntity.tagTable);

    String sql = _joinQuery(
        gameEntity.gameTable,
        relationTable,
        IDField,
        gameIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(tagIDField) + " = @tagID ", substitutionValues: {
      "tagID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return gameEntity.Game.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<typeEntity.PurchaseType>> getAllTypes() {

    String sql = _allQuery(typeEntity.typeTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return typeEntity.PurchaseType.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromType(int ID) {

    String relationTable = _relationTable(purchaseEntity.purchaseTable, typeEntity.typeTable);
    String purchaseIDField = _relationIDField(purchaseEntity.purchaseTable);
    String typeIDField = _relationIDField(typeEntity.typeTable);

    String sql = _joinQuery(
        purchaseEntity.purchaseTable,
        relationTable,
        IDField,
        purchaseIDField
    );

    return _connection.mappedResultsQuery(sql + "WHERE " + _forceDoubleQuotes(typeIDField) + " = @typeID ", substitutionValues: {
      "typeID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return purchaseEntity.Purchase.fromDynamicMapList(results);

    });

  }

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

    nameQuery = "%" + nameQuery + "%";

    String sql = _allQuery(gameEntity.gameTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(gameEntity.nameField) + " ILIKE @nameQuery ", substitutionValues: {
      "nameQuery" : nameQuery,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return gameEntity.Game.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<dlcEntity.DLC>> getDLCsWithName(String nameQuery) {

    nameQuery = "%" + nameQuery + "%";

    String sql = _allQuery(dlcEntity.dlcTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(dlcEntity.nameField) + " ILIKE @nameQuery ", substitutionValues: {
      "nameQuery" : nameQuery,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return dlcEntity.DLC.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<platformEntity.Platform>> getPlatformsWithName(String nameQuery) {

    nameQuery = "%" + nameQuery + "%";

    String sql = _allQuery(platformEntity.platformTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(platformEntity.nameField) + " ILIKE @nameQuery ", substitutionValues: {
      "nameQuery" : nameQuery,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return platformEntity.Platform.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<purchaseEntity.Purchase>> getPurchasesWithDescription(String descQuery) {

    descQuery = "%" + descQuery + "%";

    String sql = _allQuery(purchaseEntity.purchaseTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(purchaseEntity.descriptionField) + " ILIKE @descQuery ", substitutionValues: {
      "descQuery" : descQuery,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return purchaseEntity.Purchase.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<storeEntity.Store>> getStoresWithName(String nameQuery) {

    nameQuery = "%" + nameQuery + "%";

    String sql = _allQuery(storeEntity.storeTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(storeEntity.nameField) + " ILIKE @nameQuery ", substitutionValues: {
      "nameQuery" : nameQuery,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return storeEntity.Store.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<systemEntity.System>> getSystemsWithName(String nameQuery) {

    nameQuery = "%" + nameQuery + "%";

    String sql = _allQuery(systemEntity.systemTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(systemEntity.nameField) + " ILIKE @nameQuery ", substitutionValues: {
      "nameQuery" : nameQuery,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return systemEntity.System.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<tagEntity.Tag>> getTagsWithName(String nameQuery) {

    nameQuery = "%" + nameQuery + "%";

    String sql = _allQuery(tagEntity.tagTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(tagEntity.nameField) + " ILIKE @nameQuery ", substitutionValues: {
      "nameQuery" : nameQuery,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return tagEntity.Tag.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<typeEntity.PurchaseType>> getTypesWithName(String nameQuery) {

    nameQuery = "%" + nameQuery + "%";

    String sql = _allQuery(typeEntity.typeTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(typeEntity.nameField) + " ILIKE @nameQuery ", substitutionValues: {
      "nameQuery" : nameQuery,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return typeEntity.PurchaseType.fromDynamicMapList(results);

    });

  }

  @override
  Future<dynamic> updateDescriptionPurchase(int ID, String newText) {

    String sql = "UPDATE " + _forceDoubleQuotes(purchaseEntity.purchaseTable);

    return _connection.mappedResultsQuery(sql + " SET " + _forceDoubleQuotes(purchaseEntity.descriptionField) + " = @newText WHERE " + _forceDoubleQuotes(IDField) + " = @purchaseID ", substitutionValues: {
      "newText" : newText,
      "purchaseID" : ID,
    });

  }

  @override
  Future<dynamic> insertGamePurchase(int gameID, int purchaseID) {

    String relationTable = _relationTable(gameEntity.gameTable, purchaseEntity.purchaseTable);

    String sql = "INSERT INTO " + _forceDoubleQuotes(relationTable);

    return _connection.mappedResultsQuery(sql + " VALUES(@gameID, @purchaseID) ", substitutionValues: {
      "gameID" : gameID,
      "purchaseID" : purchaseID,
    });

  }

  Future<dynamic> deleteGamePurchase(int gameID, int purchaseID) {

    String relationTable = _relationTable(gameEntity.gameTable, purchaseEntity.purchaseTable);
    String gameIDField = _relationIDField(gameEntity.gameTable);
    String purchaseIDField = _relationIDField(purchaseEntity.purchaseTable);

    String sql = "DELETE FROM " + _forceDoubleQuotes(relationTable);

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(gameIDField) + " = @gameID AND " + _forceDoubleQuotes(purchaseIDField) + " = @purchaseID ", substitutionValues: {
      "gameID" : gameID,
      "purchaseID" : purchaseID,
    });

  }



  @override
  Future<dynamic> insertDLCPurchase(int dlcID, int purchaseID) {

    String relationTable = _relationTable(dlcEntity.dlcTable, purchaseEntity.purchaseTable);

    String sql = "INSERT INTO " + _forceDoubleQuotes(relationTable);

    return _connection.mappedResultsQuery(sql + " VALUES(@dlcID, @purchaseID) ", substitutionValues: {
      "dlcID" : dlcID,
      "purchaseID" : purchaseID,
    });

  }

  Future<dynamic> deleteDLCPurchase(int dlcID, int purchaseID) {

    String relationTable = _relationTable(dlcEntity.dlcTable, purchaseEntity.purchaseTable);
    String dlcIDField = _relationIDField(dlcEntity.dlcTable);
    String purchaseIDField = _relationIDField(purchaseEntity.purchaseTable);

    String sql = "DELETE FROM " + _forceDoubleQuotes(relationTable);

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(dlcIDField) + " = @dlcID AND " + _forceDoubleQuotes(purchaseIDField) + " = @purchaseID ", substitutionValues: {
      "dlcID" : dlcID,
      "purchaseID" : purchaseID,
    });

  }

  Future<dynamic> insertDLC() {

    String sql = "INSERT INTO " + _forceDoubleQuotes(dlcEntity.dlcTable) + " (" + _forceDoubleQuotes(dlcEntity.nameField) + ") ";

    return _connection.mappedResultsQuery(sql + " VALUES('') ");

  }

  Future<dynamic> insertPurchase() {

    String sql = "INSERT INTO " + _forceDoubleQuotes(purchaseEntity.purchaseTable) + " (" + _forceDoubleQuotes(purchaseEntity.descriptionField) + ") ";

    return _connection.mappedResultsQuery(sql + " VALUES('') ");

  }

  String _allQuery(String table) {

    return "SELECT * FROM " + _forceDoubleQuotes(table);

  }

  String _joinQuery(String leftTable, String rightTable, String leftTableID, String rightTableID, [String select = "Select * "]) {

    return select + " FROM \"" + leftTable + "\" JOIN \"" + rightTable + "\" ON \"" + leftTableID + "\" = \"" + rightTableID + "\" ";

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

  @override
  Future updateStringDLC(int ID, String fieldName, String newText) {

    String sql = "UPDATE " + _forceDoubleQuotes(dlcEntity.dlcTable);

    return _connection.mappedResultsQuery(sql + " SET " + _forceDoubleQuotes(fieldName) + " = @newText WHERE " + _forceDoubleQuotes(IDField) + " = @dlcID ", substitutionValues: {
      "newText" : newText,
      "dlcID" : ID,
    });

  }
  @override
  Future updateNumberDLC(int ID, String fieldName, int newNumber) {

    String sql = "UPDATE " + _forceDoubleQuotes(dlcEntity.dlcTable);

    return _connection.mappedResultsQuery(sql + " SET " + _forceDoubleQuotes(fieldName) + " = @newNumber WHERE " + _forceDoubleQuotes(IDField) + " = @dlcID ", substitutionValues: {
      "newNumber" : newNumber,
      "dlcID" : ID,
    });

  }

  @override
  Future updateDateDLC(int ID, String fieldName, DateTime newDate) {

    String sql = "UPDATE " + _forceDoubleQuotes(dlcEntity.dlcTable);

    return _connection.mappedResultsQuery(sql + " SET " + _forceDoubleQuotes(fieldName) + " = @newDate WHERE " + _forceDoubleQuotes(IDField) + " = @dlcID ", substitutionValues: {
      "newDate" : newDate,
      "dlcID" : ID,
    });

  }

  @override
  Future deleteGameDLC(int dlcID) {

    String sql = "UPDATE " + _forceDoubleQuotes(dlcEntity.dlcTable);

    return _connection.mappedResultsQuery(sql + " SET " + _forceDoubleQuotes(dlcEntity.baseGameField) + " = NULL WHERE " + _forceDoubleQuotes(IDField) + " = @dlcID ", substitutionValues: {
      "dlcID" : dlcID,
    });

  }

  @override
  Future insertGameDLC(int gameID, int dlcID) {

    String sql = "UPDATE " + _forceDoubleQuotes(dlcEntity.dlcTable);

    return _connection.mappedResultsQuery(sql + " SET " + _forceDoubleQuotes(dlcEntity.baseGameField) + " = @baseGameID WHERE " + _forceDoubleQuotes(IDField) + " = @dlcID ", substitutionValues: {
      "baseGameID" : gameID,
      "dlcID" : dlcID,
    });

  }

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