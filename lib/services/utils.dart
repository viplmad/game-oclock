import 'package:game_oclock_client/api.dart';
import 'package:http/http.dart';

Future<int> convertAggrMetricResultToInt(
  ApiClient apiClient,
  Response response,
) async {
  return await apiClient.deserializeAsync(
    await decodeBodyBytes(response),
    'int',
  ) as int;
}

Future<Duration> convertAggrMetricResultToDuration(
  ApiClient apiClient,
  Response response,
) async {
  return await apiClient.deserializeAsync(
    await decodeBodyBytes(response),
    'Duration',
  ) as Duration;
}

Future<List<AggregateGroupResultIntIntDTO>> convertAggrGroupIntByInt(
  ApiClient apiClient,
  Response response,
) async {
  return (await apiClient.deserializeAsync(
    await decodeBodyBytes(response),
    'List<AggregateGroupResultIntIntDTO>',
  ) as List).cast<AggregateGroupResultIntIntDTO>().toList(growable: false);
}

Future<List<AggregateGroupResultStringIntDTO>> convertAggrGroupStringByInt(
  ApiClient apiClient,
  Response response,
) async {
  return (await apiClient.deserializeAsync(
    await decodeBodyBytes(response),
    'List<AggregateGroupResultStringIntDTO>',
  ) as List).cast<AggregateGroupResultStringIntDTO>().toList(growable: false);
}

Future<List<AggregateGroupResultIntStringDurationDTO>>
convertAggrGroupIntByStringDuration(
  ApiClient apiClient,
  Response response,
) async {
  return (await apiClient.deserializeAsync(
    await decodeBodyBytes(response),
    'List<AggregateGroupResultIntStringDurationDTO>',
  ) as List).cast<AggregateGroupResultIntStringDurationDTO>().toList(
    growable: false,
  );
}

Future<List<AggregateGroupResultStringDurationDTO>>
convertAggrGroupStringByDuration(ApiClient apiClient, Response response) async {
  return (await apiClient.deserializeAsync(
    await decodeBodyBytes(response),
    'List<AggregateGroupResultStringDurationDTO>',
  ) as List).cast<AggregateGroupResultStringDurationDTO>().toList(
    growable: false,
  );
}

Future<List<AggregateGroupResultIntDurationDTO>> convertAggrGroupIntByDuration(
  ApiClient apiClient,
  Response response,
) async {
  return (await apiClient.deserializeAsync(
    await decodeBodyBytes(response),
    'List<AggregateGroupResultIntDurationDTO>',
  ) as List).cast<AggregateGroupResultIntDurationDTO>().toList(growable: false);
}
