import 'package:backend/query/query.dart';

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
  Future<List<Map<String, Map<String, dynamic>>>> read({required String tableName, required Map<String, Type> selectFieldsAndTypes, Query? whereQuery, List<String>? orderFields, int? limit});
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({required String tableName, required String relationTable, required String idField, required String joinField, required Map<String, Type> selectFieldsAndTypes, required Query whereQuery, List<String>? orderFields, int? limit});
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({required String primaryTable, required String subordinateTable, required String idField, required String joinField, bool primaryResults = false, required Map<String, Type> selectFieldsAndTypes, required Query whereQuery, List<String>? orderFields, int? limit});
  Future<List<Map<String, Map<String, dynamic>>>> readJoin({required String leftTable, required String rightTable, required String leftTableIdField, required String rightTableIdField, required Map<String, Type> leftSelectFields, required Map<String, Type> rightSelectFields, required Query whereQuery, List<String>? orderFields, int? limit});
  //#endregion READ

  //#region UPDATE
  Future<dynamic> update({required String tableName, required Map<String, dynamic> setFieldsAndValues, required Query whereQuery});
  //#endregion UPDATE

  //#region DELETE
  Future<dynamic> delete({required String tableName, required Query whereQuery});
  //#endregion DELETE
}