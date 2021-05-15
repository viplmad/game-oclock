abstract class ISQLConnector {
  Future<dynamic> open();
  Future<dynamic> close();
  bool isOpen();
  bool isClosed();
  bool isUpdating();

  void reconnect();

  //#region CREATE
  Future<List<Map<String, Map<String, dynamic>>>> insertRecord({required String tableName, required Map<String, dynamic> fieldsAndValues, String? idField});
  //#endregion CREATE

  //#region READ
  Future<List<Map<String, Map<String, dynamic>>>> readTable({required String tableName, required Map<String, Type> selectFields, List<dynamic>? tableArguments, Map<String, dynamic>? whereFieldsAndValues, List<String>? sortFields, int? limitResults});
  Future<List<Map<String, Map<String, dynamic>>>> readJoinTable({required String leftTable, required String rightTable, required String leftTableId, required String rightTableId, required Map<String, Type> leftSelectFields, required Map<String, Type> rightSelectFields, required String where, Map<String, dynamic>? fieldsAndValues, List<String>? sortFields});
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({required String tableName, required String relationTable, required String relationField, required int relationId, required Map<String, Type> selectFields, List<String>? sortFields});
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({required String primaryTable, required String subordinateTable, required String relationField, required int relationId, bool primaryResults = false, required Map<String, Type> selectFields, List<String>? sortFields});
  Future<List<Map<String, Map<String, dynamic>>>> readTableSearch({required String tableName, required String searchField, required String query, Map<String, Type>? fields, required int limitResults});
  //#endregion READ

  //#region UPDATE
  Future<dynamic> updateTable<T>({required String tableName, required Map<String, dynamic> whereFieldsAndValues, required Map<String, dynamic> fieldsAndValues});
  //#endregion UPDATE

  //#region DELETE
  Future<dynamic> deleteRecord({required String tableName, required Map<String, dynamic> whereFieldsAndValues});
  //#endregion DELETE
}