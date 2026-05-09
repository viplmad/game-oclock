import 'package:game_oclock_client/api.dart';
import 'package:http/http.dart';

Future<int> convertAggrMetricResultToInt(
  final ApiClient apiClient,
  final Response response,
) async {
  return await apiClient.deserializeAsync(
        await decodeBodyBytes(response),
        'int',
      )
      as int;
}

Future<Duration> convertAggrMetricResultToDuration(
  final ApiClient apiClient,
  final Response response,
) async {
  return await apiClient.deserializeAsync(
        await decodeBodyBytes(response),
        'Duration',
      )
      as Duration;
}

Future<Map<int, int>> convertAggrDateHistogramResult(
  final ApiClient apiClient,
  final Response response,
) async {
  return Map<String, int>.from(
    await apiClient.deserializeAsync(
      await decodeBodyBytes(response),
      'Map<String, int>',
    ),
  ).map(
    (final key, final val) =>
        MapEntry(apiClient.deserializeAsync(key, 'int') as int, val),
  );
}
