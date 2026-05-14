import 'package:game_oclock/models/models.dart'
    show AggregateGroupSearch, AggregateSearch, ReviewStartEnd;
import 'package:game_oclock/services/services.dart' show GameSessionService;
import 'package:game_oclock/utils/date_time_extension.dart';
import 'package:game_oclock_client/api.dart';

import '../action.dart' show FunctionActionBloc, IdentityActionBloc;

class ReviewYearSelectBloc extends IdentityActionBloc<int?> {
  @override
  Future<int?> doAction(final int? event, final int? lastData) async => event;
}

class ReviewTotalTimeGetBloc
    extends FunctionActionBloc<ReviewStartEnd, Duration> {
  ReviewTotalTimeGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<Duration> doAction(
    final ReviewStartEnd event,
    final Duration? lastData,
  ) => service.sumTime(
    AggregateSearch(
      filter: buildStartDateBetweenFilters(event.start, event.end),
    ),
    null,
  );
}

class ReviewTotalSessionsGetBloc
    extends FunctionActionBloc<ReviewStartEnd, int> {
  ReviewTotalSessionsGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<int> doAction(final ReviewStartEnd event, final int? lastData) =>
      service.count(
        AggregateSearch(
          filter: buildStartDateBetweenFilters(event.start, event.end),
        ),
        null,
      );
}

class ReviewTotalMediasGetBloc extends FunctionActionBloc<ReviewStartEnd, int> {
  ReviewTotalMediasGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<int> doAction(final ReviewStartEnd event, final int? lastData) =>
      service.countDistinctMedias(
        AggregateSearch(
          filter: buildStartDateBetweenFilters(event.start, event.end),
        ),
        null,
      );
}

class ReviewTotalFirstMediasGetBloc
    extends FunctionActionBloc<ReviewStartEnd, int> {
  ReviewTotalFirstMediasGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<int> doAction(final ReviewStartEnd event, final int? lastData) =>
      service.countDistinctFirstTimeMedias(
        AggregateSearch(
          filter: buildStartDateBetweenFilters(event.start, event.end),
        ),
        null,
      );
}

class ReviewTotalFinishedMediasGetBloc
    extends FunctionActionBloc<ReviewStartEnd, int> {
  ReviewTotalFinishedMediasGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<int> doAction(final ReviewStartEnd event, final int? lastData) =>
      service.countDistinctMedias(
        AggregateSearch(
          filter: List.unmodifiable(<FilterDTO>[
            buildFinishedFilter(),
            ...buildStartDateBetweenFilters(event.start, event.end),
          ]),
        ),
        null,
      );
}

class ReviewTotalFirstFinishedMediasGetBloc
    extends FunctionActionBloc<ReviewStartEnd, int> {
  ReviewTotalFirstFinishedMediasGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<int> doAction(final ReviewStartEnd event, final int? lastData) =>
      service.countDistinctFirstTimeMedias(
        AggregateSearch(
          filter: List.unmodifiable(<FilterDTO>[
            buildFinishedFilter(),
            ...buildStartDateBetweenFilters(event.start, event.end),
          ]),
        ),
        null,
      );
}

class ReviewLongestSessionGetBloc
    extends FunctionActionBloc<ReviewStartEnd, SessionDTO> {
  ReviewLongestSessionGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<SessionDTO> doAction(
    final ReviewStartEnd event,
    final SessionDTO? lastData,
  ) => service
      .search(
        ListSearchDTO(
          filter: buildStartDateBetweenFilters(event.start, event.end),
          sort: List.unmodifiable(<SortDTO>[
            SortDTO(field: 'time', order: OrderType.desc),
          ]),
          size: 1,
        ),
        null,
      )
      .then((final pageResult) => pageResult.data.first);
}

class ReviewLongestStreakGetBloc
    extends FunctionActionBloc<ReviewStartEnd, SessionStreakDTO> {
  ReviewLongestStreakGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<SessionStreakDTO> doAction(
    final ReviewStartEnd event,
    final SessionStreakDTO? lastData,
  ) => service
      .searchStreaks(
        ListSearchDTO(
          filter: buildStartDateBetweenFilters(event.start, event.end),
          size: 1,
        ),
        null,
      )
      .then((final pageResult) => pageResult.data.first);
}

class ReviewTotalMediasGroupByReleaseDateYearGetBloc
    extends
        FunctionActionBloc<
          ReviewStartEnd,
          List<AggregateGroupResultDTO<int, int>>
        > {
  ReviewTotalMediasGroupByReleaseDateYearGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<List<AggregateGroupResultDTO<int, int>>> doAction(
    final ReviewStartEnd event,
    final List<AggregateGroupResultDTO<int, int>>? lastData,
  ) => service.countDistinctMediasByReleaseDateYear(
    AggregateGroupSearch(
      filter: buildStartDateBetweenFilters(event.start, event.end),
      sort: AggregateGroupSortDTO(
        field: AggregateGroupSortType.metric,
        order: OrderType.asc,
      ),
    ),
    null,
  );
}

class ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc
    extends
        FunctionActionBloc<
          ReviewStartEnd,
          List<AggregateGroupResultDTO<int, int>>
        > {
  ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc({
    required this.service,
  });

  final GameSessionService service;

  @override
  Future<List<AggregateGroupResultDTO<int, int>>> doAction(
    final ReviewStartEnd event,
    final List<AggregateGroupResultDTO<int, int>>? lastData,
  ) => service.countDistinctMediasByReleaseDateYear(
    AggregateGroupSearch(
      filter: List.unmodifiable(<FilterDTO>[
        buildFinishedFilter(),
        ...buildStartDateBetweenFilters(event.start, event.end),
      ]),
      sort: AggregateGroupSortDTO(
        field: AggregateGroupSortType.metric,
        order: OrderType.asc,
      ),
    ),
    null,
  );
}

class ReviewTop5MediasByTotalTimeListBloc
    extends
        FunctionActionBloc<
          ReviewStartEnd,
          List<AggregateGroupResultDTO<String, Duration>>
        > {
  ReviewTop5MediasByTotalTimeListBloc({required this.service});

  final GameSessionService service;

  @override
  Future<List<AggregateGroupResultDTO<String, Duration>>> doAction(
    final ReviewStartEnd event,
    final List<AggregateGroupResultDTO<String, Duration>>? lastData,
  ) => service.sumTimeByMedia(
    AggregateGroupSearch(
      filter: buildStartDateBetweenFilters(event.start, event.end),
      sort: AggregateGroupSortDTO(
        field: AggregateGroupSortType.metric,
        order: OrderType.desc,
      ),
      size: 5,
    ),
    null,
  );
}

List<FilterDTO> buildStartDateBetweenFilters(
  final DateTime startDate,
  final DateTime endDate,
) {
  return List.unmodifiable(<FilterDTO>[
    FilterDTO(
      field: 'start_date',
      operator_: OperatorType.gte,
      value: SearchValue(value: startDate.toIso8601WithTzString()),
      chainOperator: ChainOperatorType.and,
    ),
    FilterDTO(
      field: 'start_date',
      operator_: OperatorType.lt,
      value: SearchValue(value: endDate.toIso8601WithTzString()),
      chainOperator: ChainOperatorType.and,
    ),
  ]);
}

FilterDTO buildFinishedFilter() {
  return FilterDTO(
    field: 'finished_status',
    operator_: OperatorType.eq,
    value: SearchValue(value: MediaStatus.completed.toJson()),
    chainOperator: ChainOperatorType.and,
  );
}
