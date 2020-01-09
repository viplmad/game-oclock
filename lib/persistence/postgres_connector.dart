import 'dart:async';
import 'dart:io' as io;
import 'package:game_collection/entity/game.dart' as gameEntity;
import 'package:postgres/postgres.dart';

import 'db_conector.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/game.dart';
import 'package:game_collection/entity/dlc.dart';
import 'package:game_collection/entity/type.dart';
import 'package:game_collection/entity/purchase.dart';
import 'package:game_collection/entity/platform.dart';
import 'package:game_collection/entity/store.dart';
import 'package:game_collection/entity/system.dart';
import 'package:game_collection/entity/tag.dart';

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
  Stream<List<Game>> getAllGames() {

    String sql = _allQuery(gameTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Game.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Platform>> getPlatformsFromGame(int ID) {

    String relationTable = _relationTable(gameTable, platformTable);
    String gameIDField = _relationIDField(gameTable);
    String platformIDField = _relationIDField(platformTable);

    String sql = _joinQuery(
        platformTable,
        relationTable,
        IDField,
        platformIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(gameIDField) + " = @gameID ", substitutionValues: {
      "gameID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Platform.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Purchase>> getPurchasesFromGame(int ID) {

    String relationTable = _relationTable(gameTable, purchaseTable);
    String gameIDField = _relationIDField(gameTable);
    String purchaseIDField = _relationIDField(purchaseTable);

    String sql = _joinQuery(
        purchaseTable,
        relationTable,
        IDField,
        purchaseIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(gameIDField) + " = @gameID ", substitutionValues: {
      "gameID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Purchase.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<DLC>> getDLCsFromGame(int ID) {

    String sql = "SELECT * ";

    sql += "FROM " + _forceDoubleQuotes(dlcTable) + " d JOIN " + _forceDoubleQuotes(gameTable) + " g "
        + " ON d." + _forceDoubleQuotes(baseGameField) + " = g." + _forceDoubleQuotes(IDField) + " ";

    return _connection.mappedResultsQuery(sql + " WHERE g." + _forceDoubleQuotes(IDField) + " = @gameID", substitutionValues: {
      "gameID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return DLC.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Tag>> getTagsFromGame(int ID) {

    String relationTable = _relationTable(gameTable, tagTable);
    String gameIDField = _relationIDField(gameTable);
    String tagIDField = _relationIDField(tagTable);

    String sql = _joinQuery(
        tagTable,
        relationTable,
        IDField,
        tagIDField
    );
    
    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(gameIDField) + " = @gameID ", substitutionValues: {
      "gameID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Tag.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<DLC>> getAllDLCs() {

    String sql = _allQuery(dlcTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return DLC.fromDynamicMapList(results);

    });

  }

  @override
  Stream<Game> getBaseGameFromDLC(int baseGameID) {

    String sql = _allQuery(gameTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(IDField) + " = @baseGameID ", substitutionValues: {
      "baseGameID" : baseGameID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {
      Game baseGame;

      baseGame = Game.fromDynamicMap(results[0][gameTable]);

      return baseGame;
    });

  }

  @override
  Stream<List<Purchase>> getPurchasesFromDLC(int ID) {

    String relationTable = _relationTable(dlcTable, purchaseTable);
    String purchaseIDField = _relationIDField(purchaseTable);
    String dlcIDField = _relationIDField(dlcTable);

    String sql = _joinQuery(
        purchaseTable,
        relationTable,
        IDField,
        purchaseIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(dlcIDField) + " = @dlcID ", substitutionValues: {
      "dlcID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Purchase.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Platform>> getAllPlatforms() {

    String sql = _allQuery(platformTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Platform.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Game>> getGamesFromPlatform(int ID) {

    String relationTable = _relationTable(gameTable, platformTable);
    String gameIDField = _relationIDField(gameTable);
    String platformIDField = _relationIDField(platformTable);

    String sql = _joinQuery(
        gameTable,
        relationTable,
        IDField,
        gameIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(platformIDField) + " = @platformID ", substitutionValues: {
      "platformID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Game.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<System>> getSystemsFromPlatform(int ID) {

    String relationTable = _relationTable(platformTable, systemTable);
    String platformIDField = _relationIDField(platformTable);
    String systemIDField = _relationIDField(systemTable);

    String sql = _joinQuery(
        systemTable,
        relationTable,
        IDField,
        systemIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(platformIDField) + " = @platformID ", substitutionValues: {
      "platformID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return System.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Purchase>> getAllPurchases() {

    String sql = _allQuery(purchaseTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Purchase.fromDynamicMapList(results);

    });

  }

  @override
  Stream<Store> getStoreFromPurchase(int storeID) {

    String sql = _allQuery(storeTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(IDField) + " = @storeID ", substitutionValues: {
      "storeID" : storeID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {
      Store purchaseStore;

      if(results.isEmpty) {
        purchaseStore = Store(ID: -1);
      } else {
        purchaseStore = Store.fromDynamicMap(results[0][storeTable]);
      }

      return purchaseStore;
    });

  }

  @override
  Stream<List<Game>> getGamesFromPurchase(int ID) {

    String relationTable = _relationTable(gameTable, purchaseTable);
    String gameIDField = _relationIDField(gameTable);
    String purchaseIDField = _relationIDField(purchaseTable);

    String sql = _joinQuery(
        gameTable,
        relationTable,
        IDField,
        gameIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(purchaseIDField) + " = @purchaseID ", substitutionValues: {
      "purchaseID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Game.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<DLC>> getDLCsFromPurchase(int ID) {

    String relationTable = _relationTable(dlcTable, purchaseTable);
    String purchaseIDField = _relationIDField(purchaseTable);
    String dlcIDField = _relationIDField(dlcTable);

    String sql = _joinQuery(
        dlcTable,
        relationTable,
        IDField,
        dlcIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(purchaseIDField) + " = @purchaseID ", substitutionValues: {
      "purchaseID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return DLC.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<PurchaseType>> getTypesFromPurchase(int ID) {

    String relationTable = _relationTable(purchaseTable, typeTable);
    String purchaseIDField = _relationIDField(purchaseTable);
    String typeIDField = _relationIDField(typeTable);

    String sql = _joinQuery(
        typeTable,
        relationTable,
        IDField,
        typeIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(purchaseIDField) + " = @purchaseID ", substitutionValues: {
      "purchaseID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return PurchaseType.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Store>> getAllStores() {

    String sql = _allQuery(storeTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Store.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Purchase>> getPurchasesFromStore(int ID) {

    String sql = "SELECT * ";

    sql += "FROM " + _forceDoubleQuotes(purchaseTable) + " p JOIN " + _forceDoubleQuotes(storeTable) + " s "
        + " ON p." + _forceDoubleQuotes(storeField) + " = s." + _forceDoubleQuotes(IDField) + " ";

    return _connection.mappedResultsQuery(sql + " WHERE s." + _forceDoubleQuotes(IDField) + " = @storeID", substitutionValues: {
      "storeID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Purchase.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<System>> getAllSystems() {

    String sql = _allQuery(systemTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return System.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Platform>> getPlatformsFromSystem(int ID) {

    String relationTable = _relationTable(platformTable, systemTable);
    String platformIDField = _relationIDField(platformTable);
    String systemIDField = _relationIDField(systemTable);

    String sql = _joinQuery(
        platformTable,
        relationTable,
        IDField,
        platformIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(systemIDField) + " = @systemID ", substitutionValues: {
      "systemID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Platform.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Tag>> getAllTags() {

    String sql = _allQuery(tagTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Tag.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Game>> getGamesFromTag(int ID) {

    String relationTable = _relationTable(gameTable, tagTable);
    String gameIDField = _relationIDField(gameTable);
    String tagIDField = _relationIDField(tagTable);

    String sql = _joinQuery(
        gameTable,
        relationTable,
        IDField,
        gameIDField
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(tagIDField) + " = @tagID ", substitutionValues: {
      "tagID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Game.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<PurchaseType>> getAllTypes() {

    String sql = _allQuery(typeTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return PurchaseType.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Purchase>> getPurchasesFromType(int ID) {

    String relationTable = _relationTable(purchaseTable, typeTable);
    String purchaseIDField = _relationIDField(purchaseTable);
    String typeIDField = _relationIDField(typeTable);

    String sql = _joinQuery(
        purchaseTable,
        relationTable,
        IDField,
        purchaseIDField
    );

    return _connection.mappedResultsQuery(sql + "WHERE " + _forceDoubleQuotes(typeIDField) + " = @typeID ", substitutionValues: {
      "typeID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Purchase.fromDynamicMapList(results);

    });

  }

  @override
  Stream<List<Game>> getGamesWithName(String nameQuery) {

    nameQuery = "%" + nameQuery + "%";

    String sql = _allQuery(gameTable);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(gameEntity.nameField) + " ILIKE @nameQuery ", substitutionValues: {
      "nameQuery" : nameQuery,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {

      return Game.fromDynamicMapList(results);

    });

  }

  @override
  Future<dynamic> updateDescriptionPurchase(int ID, String newText) {

    String sql = "UPDATE " + _forceDoubleQuotes(purchaseTable);

    return _connection.mappedResultsQuery(sql + " SET " + _forceDoubleQuotes(descriptionField) + " = @newText WHERE " + _forceDoubleQuotes(IDField) + " = @purchaseID ", substitutionValues: {
      "newText" : newText,
      "purchaseID" : ID,
    });

  }

  @override
  Future<dynamic> insertGamePurchase(int gameID, int purchaseID) {

    String relationTable = _relationTable(gameTable, purchaseTable);

    String sql = "INSERT INTO " + _forceDoubleQuotes(relationTable);

    return _connection.mappedResultsQuery(sql + " VALUES(@gameID, @purchaseID) ", substitutionValues: {
      "gameID" : gameID,
      "purchaseID" : purchaseID,
    });

  }

  Future<dynamic> deleteGamePurchase(int gameID, int purchaseID) {

    String relationTable = _relationTable(gameTable, purchaseTable);
    String gameIDField = _relationIDField(gameTable);
    String purchaseIDField = _relationIDField(purchaseTable);

    String sql = "DELETE FROM " + _forceDoubleQuotes(relationTable);

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(gameIDField) + " = @gameID AND " + _forceDoubleQuotes(purchaseIDField) + " = @purchaseID ", substitutionValues: {
      "gameID" : gameID,
      "purchaseID" : purchaseID,
    });

  }

  Future<dynamic> insertPurchase() {

    String sql = "INSERT INTO " + _forceDoubleQuotes(purchaseTable) + " (" + _forceDoubleQuotes(descriptionField) + ") ";

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