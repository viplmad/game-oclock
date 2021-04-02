abstract class ISQLConnector {
  Future<dynamic> open();
  Future<dynamic> close();
  bool isOpen();
  bool isClosed();
  bool isUpdating();

  void reconnect();

  //#region CREATE
  Future<List<Map<String, Map<String, dynamic>>>> insertRecord({required String tableName, required Map<String, dynamic> fieldsAndValues, List<String>? returningFields});
  Future<dynamic> insertRelation({required String leftTableName, required String rightTableName, required int leftTableId, required int rightTableId});
  //#endregion CREATE

  //#region READ
  Future<List<Map<String, Map<String, dynamic>>>> readTable({required String tableName, List<String>? selectFields, List<dynamic>? tableArguments, Map<String, dynamic>? fieldsAndValues, List<String>? sortFields, int? limitResults});
  Future<List<Map<String, Map<String, dynamic>>>> readJoinTable({required String leftTable, required String rightTable, required String leftTableId, required String rightTableId, required List<String> leftSelectFields, required List<String> rightSelectFields, required String where, Map<String, dynamic>? fieldsAndValues, List<String>? sortFields});
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({required String leftTableName, required String rightTableName, required bool leftResults, required int relationId, List<String>? selectFields, List<String>? sortFields});
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({required String primaryTable, required String subordinateTable, required String relationField, required int relationId, bool primaryResults = false, List<String>? selectFields, List<String>? sortFields});
  Future<List<Map<String, Map<String, dynamic>>>> readTableSearch({required String tableName, required String searchField, required String query, List<String>? fieldNames, required int limitResults});
  //#endregion READ

  //#region UPDATE
  Future<dynamic> updateTable<T>({required String tableName, required Map<String, dynamic> fieldsAndValues, required String fieldName, required T newValue});
  //#endregion UPDATE

  //#region DELETE
  Future<dynamic> deleteTable({required String tableName, required Map<String, dynamic> fieldsAndValues});
  Future<dynamic> deleteRelation({required String leftTableName, required String rightTableName, required int leftId, required int rightId});
  //#endregion DELETE
}