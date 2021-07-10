import 'package:query/query.dart';


abstract class ItemConnector {
  Future<dynamic> open();
  Future<dynamic> close();
  bool isOpen();
  bool isClosed();
  bool isUpdating();

  void reconnect();

  Future<List<Map<String, Map<String, dynamic>>>> execute(Query query);
}