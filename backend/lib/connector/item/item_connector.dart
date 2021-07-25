import 'package:query/query.dart';

export '../provider_instance.dart';


abstract class ItemConnector {
  Future<Object?> open();
  Future<Object?> close();
  bool isOpen();
  bool isClosed();
  bool isUpdating();

  void reconnect();

  Future<List<Map<String, Map<String, Object?>>>> execute(Query query);
}