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
    final ListSearchDTO search,
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
    final ListSearchDTO search,
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
    final ListSearchDTO search,
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
    final ListSearchDTO search,
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
    final ListSearchDTO search,
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
    final ListSearchDTO search,
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

  Future<Map<int, int>> countDistinctMediasByReleaseDateYear(
    final ListSearchDTO search,
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
      ),
      q: quicksearch,
    );
    return convertAggrDateHistogramResult(_api.apiClient, response);
  }

  Future<Map<int, int>> countDistinctMediasByStartDateMonth(
    final ListSearchDTO search,
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
      ),
      q: quicksearch,
    );
    return convertAggrDateHistogramResult(_api.apiClient, response);
  }

  Future<Map<int, int>> countDistinctMediasByRating(
    final ListSearchDTO search,
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
      ),
      q: quicksearch,
    );
    return convertAggrDateHistogramResult(_api.apiClient, response);
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
