import 'package:backend/connector/connector.dart' show ItemConnector;

import 'base_repository.dart';

class StatisticsRepository extends BaseRepository {
  const StatisticsRepository(
    ItemConnector itemConnector, {
    required String recordName,
  }) : super(itemConnector, recordName: recordName);
}
