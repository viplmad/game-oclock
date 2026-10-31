import 'package:game_oclock/models/models.dart'
    show
        AggregateGroupSearch,
        AggregateSearch,
        deviceIdField,
        mediaGenreField,
        mediaIdField,
        mediaRatingField,
        mediaReleaseDateField,
        startDateField,
        timeField;
import 'package:game_oclock/utils/date_time_extension.dart';
import 'package:game_oclock_client/api.dart';

import 'utils.dart';

class SessionService {
  final MediaSessionsApi _api;

  SessionService(ApiClient apiClient) : _api = MediaSessionsApi(apiClient);

  Future<PageResultDTO<SessionDTO>> search(
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getSessions(search, q: quicksearch);
  }

  Future<int> count(
    AggregateSearch search,
    String? quicksearch, [
    FetchMode? mode,
  ]) async {
    final response = await _api.aggregateSessionsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: mediaIdField.value,
          kind: AggregateMetricType.count,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
      mode: mode,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<PageResultDTO<SessionDTO>> searchForGame(
    String gameId,
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getMediaSessions(gameId, search, q: quicksearch);
  }

  Future<int> countForGame(
    String gameId,
    AggregateSearch search,
    String? quicksearch,
  ) async {
    final response = await _api.aggregateMediaSessionsWithHttpInfo(
      gameId,
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: mediaIdField.value,
          kind: AggregateMetricType.count,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<Duration> sumTimeForGame(
    String gameId,
    AggregateSearch search,
    String? quicksearch,
  ) async {
    final response = await _api.aggregateMediaSessionsWithHttpInfo(
      gameId,
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: timeField.value,
          kind: AggregateMetricType.sum,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToDuration(_api.apiClient, response);
  }

  Future<Duration> sumTime(
    AggregateSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final response = await _api.aggregateSessionsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: timeField.value,
          kind: AggregateMetricType.sum,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
      mode: mode,
    );
    return convertAggrMetricResultToDuration(_api.apiClient, response);
  }

  Future<int> countDistinctMedias(
    AggregateSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final response = await _api.aggregateSessionsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: mediaIdField.value,
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
      mode: mode,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<int> countDistinctFirstTimeMedias(
    AggregateSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final response = await _api.aggregateFirstSessionsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: mediaIdField.value,
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
      mode: mode,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<int> countDistinctDevices(
    AggregateSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final response = await _api.aggregateSessionsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: deviceIdField.value,
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
      mode: mode,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<List<AggregateGroupResultDTO<int, Duration>>>
  sumTimeByStartDateWeekday(
    AggregateGroupSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: timeField.value,
          kind: AggregateMetricType.sum,
        ),
        group: AggregateGroupDTO(
          field: startDateField.value,
          kind: AggregateGroupType.dateHistogram,
          interval: DateHistogramInterval.weekday,
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
      mode: mode,
    );
    return convertAggrGroupIntByDuration(_api.apiClient, response);
  }

  Future<List<AggregateGroupResultDTO<int, Duration>>> sumTimeByStartDateHour(
    AggregateGroupSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: timeField.value,
          kind: AggregateMetricType.sum,
        ),
        group: AggregateGroupDTO(
          field: startDateField.value,
          kind: AggregateGroupType.dateHistogram,
          interval: DateHistogramInterval.hour,
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
      mode: mode,
    );
    return convertAggrGroupIntByDuration(_api.apiClient, response);
  }

  Future<
    List<
      AggregateGroupResultDTO<
        int,
        List<AggregateGroupResultDTO<String, Duration>>
      >
    >
  >
  sumTimeByStartDateMonthThenMedia(
    AggregateGroupSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: timeField.value,
          kind: AggregateMetricType.sum,
        ),
        group: AggregateGroupDTO(
          field: startDateField.value,
          kind: AggregateGroupType.dateHistogram,
          interval: DateHistogramInterval.month,
        ),
        subgroup: AggregateGroupDTO(
          field: mediaIdField.value,
          kind: AggregateGroupType.field,
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
      mode: mode,
    );
    return convertAggrGroupIntByStringDuration(_api.apiClient, response);
  }

  Future<List<AggregateGroupResultDTO<int, int>>>
  countDistinctMediasByReleaseDateYear(
    AggregateGroupSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final defaultValue = DateTime(1970);
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: mediaIdField.value,
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        group: AggregateGroupDTO(
          field: mediaReleaseDateField.value,
          kind: AggregateGroupType.dateHistogram,
          interval: DateHistogramInterval.year,
          defaultValue: defaultValue.toIso8601WithTzString(),
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
      mode: mode,
    );
    final data = await convertAggrGroupIntByInt(_api.apiClient, response);
    return data
        .takeWhile((val) => val.key != defaultValue.year)
        .toList(growable: false);
  }

  Future<List<AggregateGroupResultDTO<int, int>>>
  countDistinctMediasByStartDateMonth(
    AggregateGroupSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: mediaIdField.value,
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        group: AggregateGroupDTO(
          field: startDateField.value,
          kind: AggregateGroupType.dateHistogram,
          interval: DateHistogramInterval.month,
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
      mode: mode,
    );
    return convertAggrGroupIntByInt(_api.apiClient, response);
  }

  Future<List<AggregateGroupResultDTO<int, int>>> countDistinctMediasByRating(
    AggregateGroupSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: mediaIdField.value,
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        group: AggregateGroupDTO(
          field: mediaRatingField.value,
          kind: AggregateGroupType.field,
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
      mode: mode,
    );
    return convertAggrGroupIntByInt(_api.apiClient, response);
  }

  Future<List<AggregateGroupResultDTO<String, int>>> countDistinctMediasByGenre(
    AggregateGroupSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: mediaIdField.value,
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        group: AggregateGroupDTO(
          field: mediaGenreField.value,
          kind: AggregateGroupType.field,
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
      mode: mode,
    );
    return convertAggrGroupStringByInt(_api.apiClient, response);
  }

  Future<List<AggregateGroupResultDTO<String, Duration>>> sumTimeByMedia(
    AggregateGroupSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: timeField.value,
          kind: AggregateMetricType.sum,
          distinct: true,
        ),
        group: AggregateGroupDTO(
          field: mediaIdField.value,
          kind: AggregateGroupType.field,
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
      mode: mode,
    );
    return convertAggrGroupStringByDuration(_api.apiClient, response);
  }

  Future<List<AggregateGroupResultDTO<String, Duration>>> sumTimeByDevice(
    AggregateGroupSearch search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    final defaultValue = '00000000-0000-0000-0000-000000000000';
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: timeField.value,
          kind: AggregateMetricType.sum,
          distinct: true,
        ),
        group: AggregateGroupDTO(
          field: deviceIdField.value,
          kind: AggregateGroupType.field,
          defaultValue: defaultValue,
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
      mode: mode,
    );
    final data = await convertAggrGroupStringByDuration(
      _api.apiClient,
      response,
    );
    return data
        .takeWhile((val) => val.key != defaultValue)
        .toList(growable: false);
  }

  Future<PageResultDTO<SessionStreakDTO>> searchStreaks(
    ListSearchDTO search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    return _api.getSessionStreaks(search, q: quicksearch, mode: mode);
  }

  Future<List<DateTime>> searchDates(
    ListSearchDTO search,
    String? quicksearch,
    FetchMode? mode,
  ) async {
    return _api.getSessionDates(search, q: quicksearch, mode: mode);
  }

  Future<SessionDTO> get(String gameId, DateTime startDate) async {
    return _api.getMediaSession(gameId, DateTimeDTO(datetime: startDate));
  }

  Future<void> create(String gameId, NewSessionDTO session) async {
    return _api.createMediaSession(gameId, session);
  }
}
