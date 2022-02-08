import 'package:meta/meta.dart';
import 'package:query/query.dart';

import 'package:backend/connector/connector.dart' show ItemConnector;

import 'repository_utils.dart';


abstract class BaseRepository {
  const BaseRepository(this.itemConnector, {
    required this.recordName,
  });

  @protected
  final ItemConnector itemConnector;
  @protected
  final String recordName;

  @nonVirtual
  Future<Object?> open() => itemConnector.open();
  @nonVirtual
  Future<Object?> close() => itemConnector.close();

  @nonVirtual
  bool isOpen() => itemConnector.isOpen();
  @nonVirtual
  bool isClosed() => itemConnector.isClosed();

  @nonVirtual
  void reconnect() => itemConnector.reconnect();

  @nonVirtual
  Future<Map<String, Object?>> readItemRaw({required Query query}) {

    return itemConnector.execute(query)
      .asStream().map( (List<Map<String, Map<String, Object?>>> results) {
        final Map<String, Object?> map = RepositoryUtils.combineMaps(results.first, recordName);

        return map;
      }).first;

  }
}