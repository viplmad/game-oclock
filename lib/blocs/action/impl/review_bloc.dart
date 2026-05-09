import 'package:game_oclock/models/models.dart' show ReviewStartEnd;
import 'package:game_oclock/services/services.dart' show GameSessionService;
import 'package:game_oclock/utils/date_time_extension.dart';
import 'package:game_oclock_client/api.dart';

import '../action.dart' show FunctionActionBloc, IdentityActionBloc;

class ReviewYearSelectBloc extends IdentityActionBloc<int?> {
  @override
  Future<int?> doAction(final int? event, final int? lastData) async => event;
}

class ReviewTotalSessionsGetBloc
    extends FunctionActionBloc<ReviewStartEnd, int> {
  ReviewTotalSessionsGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<int> doAction(final ReviewStartEnd event, final int? lastData) =>
      service.count(
        ListSearchDTO(
          filter: buildStartDateBetweenFilters(event.start, event.end),
        ),
        null,
      );
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
    ListSearchDTO(filter: buildStartDateBetweenFilters(event.start, event.end)),
    null,
  );
}

class ReviewTotalMediasGetBloc extends FunctionActionBloc<ReviewStartEnd, int> {
  ReviewTotalMediasGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<int> doAction(final ReviewStartEnd event, final int? lastData) =>
      service.countDistinctMedias(
        ListSearchDTO(
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
        ListSearchDTO(
          filter: buildStartDateBetweenFilters(event.start, event.end),
        ),
        null,
      );
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
      .then((final streaks) => streaks.data.first);
}

class ReviewTotalMediasGroupByReleaseDateYearGetBloc
    extends FunctionActionBloc<ReviewStartEnd, Map<int, int>> {
  ReviewTotalMediasGroupByReleaseDateYearGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<Map<int, int>> doAction(
    final ReviewStartEnd event,
    final Map<int, int>? lastData,
  ) => service.countDistinctMediasByReleaseDateYear(
    ListSearchDTO(filter: buildStartDateBetweenFilters(event.start, event.end)),
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
