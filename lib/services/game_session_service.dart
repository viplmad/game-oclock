import 'package:game_oclock/models/models.dart'
    show AggregateGroupSearch, AggregateSearch;
import 'package:game_oclock_client/api.dart';

import 'utils.dart';

class GameSessionService {
  final MediaSessionsApi _api;

  GameSessionService(final ApiClient apiClient)
    : _api = MediaSessionsApi(apiClient);

  Future<PageResultDTO<SessionDTO>> search(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getSessions(search, q: quicksearch);
  }

  Future<int> count(
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateSessionsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: 'media_id',
          kind: AggregateMetricType.count,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<PageResultDTO<SessionDTO>> searchForGame(
    final String gameId,
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getMediaSessions(gameId, search, q: quicksearch);
  }

  Future<int> countForGame(
    final String gameId,
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateMediaSessionsWithHttpInfo(
      gameId,
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: 'media_id',
          kind: AggregateMetricType.count,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<Duration> sumTimeForGame(
    final String gameId,
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateMediaSessionsWithHttpInfo(
      gameId,
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'time', kind: AggregateMetricType.sum),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToDuration(_api.apiClient, response);
  }

  Future<Duration> sumTime(
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateSessionsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'time', kind: AggregateMetricType.sum),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToDuration(_api.apiClient, response);
  }

  Future<int> countDistinctMedias(
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateSessionsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: 'media_id',
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<int> countDistinctFirstTimeMedias(
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateFirstSessionsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: 'media_id',
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<int> countDistinctDevices(
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateSessionsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: 'device_id',
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<
    List<
      AggregateGroupResultDTO<
        int,
        List<AggregateGroupResultDTO<String, Duration>>
      >
    >
  >
  sumTimeByMonthThenMedia(
    final AggregateGroupSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(field: 'time', kind: AggregateMetricType.sum),
        group: AggregateGroupDTO(
          field: 'start_date',
          kind: AggregateGroupType.dateHistogram,
          interval: DateHistogramInterval.month,
        ),
        subgroup: AggregateGroupDTO(
          field: 'media_id',
          kind: AggregateGroupType.field,
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
    );
    return convertAggrGroupIntByStringDuration(_api.apiClient, response);
  }

  Future<List<AggregateGroupResultDTO<int, int>>>
  countDistinctMediasByReleaseDateYear(
    final AggregateGroupSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: 'media_id',
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        group: AggregateGroupDTO(
          field: 'media_release_date',
          kind: AggregateGroupType.dateHistogram,
          interval: DateHistogramInterval.year,
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
    );
    return convertAggrGroupIntByInt(_api.apiClient, response);
  }

  Future<List<AggregateGroupResultDTO<int, int>>>
  countDistinctMediasByStartDateMonth(
    final AggregateGroupSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: 'media_id',
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        group: AggregateGroupDTO(
          field: 'start_date',
          kind: AggregateGroupType.dateHistogram,
          interval: DateHistogramInterval.month,
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
    );
    return convertAggrGroupIntByInt(_api.apiClient, response);
  }

  Future<List<AggregateGroupResultDTO<int, int>>> countDistinctMediasByRating(
    final AggregateGroupSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: 'media_id',
          kind: AggregateMetricType.count,
          distinct: true,
        ),
        group: AggregateGroupDTO(
          field: 'media_rating',
          kind: AggregateGroupType.field,
          defaultValue: '-1',
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
    );
    return convertAggrGroupIntByInt(_api.apiClient, response);
  }

  Future<List<AggregateGroupResultDTO<String, Duration>>> sumTimeByMedia(
    final AggregateGroupSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: 'time',
          kind: AggregateMetricType.sum,
          distinct: true,
        ),
        group: AggregateGroupDTO(
          field: 'media_id',
          kind: AggregateGroupType.field,
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
    );
    return convertAggrGroupStringByDuration(_api.apiClient, response);
  }

  Future<List<AggregateGroupResultDTO<String, Duration>>> sumTimeByDevice(
    final AggregateGroupSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateGroupSessionsWithHttpInfo(
      AggregateGroupSearchDTO(
        aggr: AggregateMetricDTO(
          field: 'time',
          kind: AggregateMetricType.sum,
          distinct: true,
        ),
        group: AggregateGroupDTO(
          field: 'device_id',
          kind: AggregateGroupType.field,
          defaultValue: '00000000-0000-0000-0000-000000000000',
        ),
        filter: search.filter,
        sort: search.sort,
        size: search.size,
      ),
      q: quicksearch,
    );
    return convertAggrGroupStringByDuration(_api.apiClient, response);
  }

  Future<PageResultDTO<SessionStreakDTO>> searchStreaks(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getSessionStreaks(search, q: quicksearch);
  }

  Future<SessionDTO> get(final String gameId, final DateTime startDate) async {
    return _api.getMediaSession(gameId, DateTimeDTO(datetime: startDate));
  }

  Future<void> create(final String gameId, final NewSessionDTO session) async {
    return _api.createMediaSession(gameId, session);
  }
}
