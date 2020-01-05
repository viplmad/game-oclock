import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
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
  Future<void> open() async {

    return await _connection.open();

  }

  @override
  Future<void> close() async {

    return await _connection.close();

  }

  @override
  Stream<List<Game>> getAllGames() {

    String sql = _allQuery(gameTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {
      List<Game> objectList = [];

      results.forEach( (Map<String, Map<String, dynamic>> result) {
        Game game = Game.fromDynamicMap(result[gameTable]);

        objectList.add(game);
      });

      return objectList;
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

    return _connection.mappedResultsQuery(sql + "WHERE + " + _forceDoubleQuotes(gameIDField) + " = @gameID ", substitutionValues: {
      "gameID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {
      List<Platform> objectList = [];

      results.forEach( (Map<String, Map<String, dynamic>> result) {
        Platform platform = Platform.fromDynamicMap(result[platformTable]);

        objectList.add(platform);
      });

      return objectList;
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

    return _connection.mappedResultsQuery(sql + "WHERE + " + _forceDoubleQuotes(gameIDField) + " = @gameID ", substitutionValues: {
      "gameID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {
      List<Purchase> objectList = [];

      results.forEach( (Map<String, Map<String, dynamic>> result) {
        Purchase purchase = Purchase.fromDynamicMap(result[purchaseTable]);

        objectList.add(purchase);
      });

      return objectList;
    });

  }

  @override
  Stream<List<DLC>> getDLCsFromGame(int ID) {

    String sql = "SELECT * ";

    sql += "FROM " + _forceDoubleQuotes(dlcTable) + " d JOIN " + _forceDoubleQuotes(gameTable)
        + " ON d." + _forceDoubleQuotes(baseGameField) + " = g." + _forceDoubleQuotes(IDField) + " ";

    return _connection.mappedResultsQuery(sql + "WHERE g." + _forceDoubleQuotes(IDField) + " = @gameID", substitutionValues: {
      "gameID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {
      List<DLC> objectList = [];

      results.forEach( (Map<String, Map<String, dynamic>> result) {
        DLC dlc = DLC.fromDynamicMap(result[purchaseTable]);

        objectList.add(dlc);
      });

      return objectList;
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
    
    return _connection.mappedResultsQuery(sql + "WHERE + " + _forceDoubleQuotes(gameIDField) + " = @gameID ", substitutionValues: {
      "gameID" : ID,
    }).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {
      List<Tag> objectList = [];

      results.forEach( (Map<String, Map<String, dynamic>> result) {
        Tag tag = Tag.fromDynamicMap(result[tagTable]);

        objectList.add(tag);
      });

      return objectList;
    });

  }

  @override
  Stream<List<PurchaseType>> getAllTypes() {

    String sql = _allQuery(typeTable);

    return _connection.mappedResultsQuery(sql).asStream().map( (List<Map<String, Map<String, dynamic>>> results) {
      List<PurchaseType> objectList = [];

      results.forEach( (Map<String, Map<String, dynamic>> result) {
        PurchaseType type = PurchaseType.fromDynamicMap(result[typeTable]);

        objectList.add(type);
      });

      return objectList;
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
      List<Purchase> objectList = [];

      results.forEach( (Map<String, Map<String, dynamic>> result) {
        Purchase purchase = Purchase.fromDynamicMap(result[purchaseTable]);

        objectList.add(purchase);
      });

      return objectList;
    });

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