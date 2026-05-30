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

Future<List<AggregateGroupResultIntIntDTO>> convertAggrGroupIntByInt(
  final ApiClient apiClient,
  final Response response,
) async {
  return (await apiClient.deserializeAsync(
            await decodeBodyBytes(response),
            'List<AggregateGroupResultIntIntDTO>',
          )
          as List)
      .cast<AggregateGroupResultIntIntDTO>()
      .toList(growable: false);
}

Future<List<AggregateGroupResultIntStringDurationDTO>>
convertAggrGroupIntByStringDuration(
  final ApiClient apiClient,
  final Response response,
) async {
  return (await apiClient.deserializeAsync(
            await decodeBodyBytes(response),
            'List<AggregateGroupResultIntStringDurationDTO>',
          )
          as List)
      .cast<AggregateGroupResultIntStringDurationDTO>()
      .toList(growable: false);
}

Future<List<AggregateGroupResultStringDurationDTO>>
convertAggrGroupStringByDuration(
  final ApiClient apiClient,
  final Response response,
) async {
  return (await apiClient.deserializeAsync(
            await decodeBodyBytes(response),
            'List<AggregateGroupResultStringDurationDTO>',
          )
          as List)
      .cast<AggregateGroupResultStringDurationDTO>()
      .toList(growable: false);
}
