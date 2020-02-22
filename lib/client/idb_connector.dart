import 'package:meta/meta.dart';


abstract class IDBConnector {

  Future<dynamic> open();
  Future<dynamic> close();
  bool isOpen();
  bool isClosed();
  bool isUpdating();

  //#region CREATE
  Future<List<Map<String, Map<String, dynamic>>>> insertTable({@required String tableName, Map<String, dynamic> fieldAndValues, List<String> returningFields});
  Future<dynamic> insertRelation({@required String leftTableName, @required String rightTableName, @required int leftTableID, @required int rightTableID});
  //#endregion CREATE

  //#region READ
  Future<List<Map<String, Map<String, dynamic>>>> readTable({@required String tableName, List<String> selectFields, Map<String, dynamic> whereFieldsAndValues, List<String> sortFields, int limitResults});
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({@required String leftTableName, @required String rightTableName, @required bool leftResults, @required int relationID, List<String> selectFields, List<String> sortFields});
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({@required String primaryTable, @required String subordinateTable, @required String relationField, @required int relationID, bool primaryResults, List<String> selectFields, List<String> sortFields});
  Future<List<Map<String, Map<String, dynamic>>>> readTableSearch({@required String tableName, @required String searchField, @required String query, List<String> fieldNames, int limitResults});
  //#endregion READ

  //#region UPDATE
  Future<List<Map<String, Map<String, dynamic>>>> updateTable<T>({@required String tableName, @required int ID, @required String fieldName, @required T newValue, List<String> returningFields});
  //#endregion UPDATE

  //#region DELETE
  Future<dynamic> deleteTable({@required String tableName, @required int ID});
  Future<dynamic> deleteRelation({@required String leftTableName, @required String rightTableName, @required int leftID, @required int rightID});
  //#endregion DELETE

}