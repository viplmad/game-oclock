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
  Future<List<Map<String, Map<String, dynamic>>>> readTable({required String tableName, required Map<String, Type> selectFieldsAndTypes, Map<String, dynamic>? whereFieldsAndValues, List<String>? orderFields, int? limit});
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({required String tableName, required String relationTable, required String idField, required String joinField, required Map<String, Type> selectFieldsAndTypes, required Map<String, dynamic> whereFieldsAndValues, List<String>? orderFields});
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({required String primaryTable, required String subordinateTable, required String idField, required String joinField, bool primaryResults = false, required Map<String, Type> selectFieldsAndTypes, required Map<String, dynamic> whereFieldsAndValues, List<String>? orderFields});
  Future<List<Map<String, Map<String, dynamic>>>> readJoinTable({required String leftTable, required String rightTable, required String leftTableIdField, required String rightTableIdField, required Map<String, Type> leftSelectFields, required Map<String, Type> rightSelectFields, required String where, List<String>? orderFields});
  Future<List<Map<String, Map<String, dynamic>>>> readTableSearch({required String tableName, required Map<String, Type> selectFieldsAndTypes, required String searchField, required String query, required int limit});
  //#endregion READ

  //#region UPDATE
  Future<dynamic> updateTable<T>({required String tableName, required Map<String, dynamic> setFieldsAndValues, required Map<String, dynamic> whereFieldsAndValues});
  //#endregion UPDATE

  //#region DELETE
  Future<dynamic> deleteRecord({required String tableName, required Map<String, dynamic> whereFieldsAndValues});
  //#endregion DELETE
}