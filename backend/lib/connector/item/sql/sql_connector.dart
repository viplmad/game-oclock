import 'package:backend/query/query.dart';
import 'package:backend/query/fields.dart';

abstract class SQLConnector {
  Future<dynamic> open();
  Future<dynamic> close();
  bool isOpen();
  bool isClosed();
  bool isUpdating();

  void reconnect();

  //#region CREATE
  Future<List<Map<String, Map<String, dynamic>>>> create({required String tableName, required Map<String, dynamic> insertFieldsAndValues, String? returningField});
  //#endregion CREATE

  //#region READ
  Future<List<Map<String, Map<String, dynamic>>>> read({required String tableName, required Fields selectFields, Query? whereQuery, List<String>? orderFields, int? limit});
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({required String tableName, required String relationTable, required String idField, required String joinField, required Fields selectFields, required Query whereQuery, List<String>? orderFields, int? limit});
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({required String primaryTable, required String subordinateTable, required String idField, required String joinField, bool primaryResults = false, required Fields selectFields, required Query whereQuery, List<String>? orderFields, int? limit});
  Future<List<Map<String, Map<String, dynamic>>>> readJoin({required String leftTable, required String rightTable, required String leftTableIdField, required String rightTableIdField, required Fields leftSelectFields, required Fields rightSelectFields, required Query whereQuery, List<String>? orderFields, int? limit});
  Future<List<Map<String, Map<String, dynamic>>>> readFunction({required String functionName, required List<dynamic> arguments, required Fields selectFields, int? limit});
  //#endregion READ

  //#region UPDATE
  Future<dynamic> update({required String tableName, required Map<String, dynamic> setFieldsAndValues, required Query whereQuery});
  //#endregion UPDATE

  //#region DELETE
  Future<dynamic> delete({required String tableName, required Query whereQuery});
  //#endregion DELETE
}