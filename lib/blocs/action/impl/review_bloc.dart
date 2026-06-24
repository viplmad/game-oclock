import 'dart:async';
import 'package:game_oclock/models/models.dart'
    show
        AggregateGroupSearch,
        AggregateSearch,
        DeviceWithTime,
        MediaWithTime,
        ReviewStartEnd;
import 'package:game_oclock/services/services.dart'
    show DeviceService, GameService, GameSessionService;
import 'package:game_oclock/utils/duration_extension.dart';
import 'package:game_oclock/utils/filter_utils.dart';
import 'package:game_oclock_client/api.dart';

import '../action.dart' show FunctionActionBloc, IdentityActionBloc;

class ReviewYearSelectBloc extends IdentityActionBloc<int?> {
  @override
  Future<int?> doAction(final int? event, final int? lastData) async => event;
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
        calculateOnCurrentYear(event.start),
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
        calculateOnCurrentYear(event.start),
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
        calculateOnCurrentYear(event.start),
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
        calculateOnCurrentYear(event.start),
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
    AggregateSearch(
      filter: buildStartDateBetweenFilters(event.start, event.end),
    ),
    null,
    calculateOnCurrentYear(event.start),
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
        calculateOnCurrentYear(event.start),
      );
}

class ReviewTotalDevicesGetBloc
    extends FunctionActionBloc<ReviewStartEnd, int> {
  ReviewTotalDevicesGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<int> doAction(final ReviewStartEnd event, final int? lastData) =>
      service.countDistinctDevices(
        AggregateSearch(
          filter: List.unmodifiable(<FilterDTO>[
            ...buildStartDateBetweenFilters(event.start, event.end),
          ]),
        ),
        null,
        calculateOnCurrentYear(event.start),
      );
}

class ReviewMostUsedDeviceGetBloc
    extends FunctionActionBloc<ReviewStartEnd, DeviceWithTime?> {
  ReviewMostUsedDeviceGetBloc({
    required this.service,
    required this.deviceService,
  });

  final GameSessionService service;
  final DeviceService deviceService;

  @override
  Future<DeviceWithTime?> doAction(
    final ReviewStartEnd event,
    final DeviceWithTime? lastData,
  ) async {
    final aggr = await service
        .sumTimeByDevice(
          AggregateGroupSearch(
            filter: buildStartDateBetweenFilters(event.start, event.end),
            sort: List.unmodifiable(<AggregateGroupSortDTO>[
              AggregateGroupSortDTO(
                // Sort by time
                field: AggregateGroupSortType.metric,
                order: OrderType.desc,
              ),
            ]),
            size: 1,
          ),
          null,
          calculateOnCurrentYear(event.start),
        )
        .then(_removeZeroDurationEntries)
        .then((final result) => result.firstOrNull);
    if (aggr == null) {
      return null;
    }
    final device = await deviceService.get(aggr.key);
    return DeviceWithTime(device: device, time: aggr.value);
  }
}

class ReviewLongestSessionGetBloc
    extends FunctionActionBloc<ReviewStartEnd, MediaSessionDTO?> {
  ReviewLongestSessionGetBloc({
    required this.service,
    required this.gameService,
  });

  final GameSessionService service;
  final GameService gameService;

  @override
  Future<MediaSessionDTO?> doAction(
    final ReviewStartEnd event,
    final MediaSessionDTO? lastData,
  ) async {
    final longestSessions = await service
        .search(
          ListSearchDTO(
            filter: buildStartDateBetweenFilters(event.start, event.end),
            sort: List.unmodifiable(<SortDTO>[
              SortDTO(field: 'time', order: OrderType.desc),
            ]),
            size: 1,
          ),
          null,
          // no mode, not so demanding query
        )
        .then((final pageResult) => pageResult.data);
    if (longestSessions.isEmpty) {
      return null;
    }
    final longestSession = longestSessions.first;
    final media = await gameService.get(longestSession.mediaId);
    return MediaSessionDTO(media: media, session: longestSession);
  }
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
        calculateOnCurrentYear(event.start),
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
      sort: List.unmodifiable(<AggregateGroupSortDTO>[
        AggregateGroupSortDTO(
          // Sort by count
          field: AggregateGroupSortType.metric,
          order: OrderType.asc,
        ),
      ]),
    ),
    null,
    calculateOnCurrentYear(event.start),
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
      sort: List.unmodifiable(<AggregateGroupSortDTO>[
        AggregateGroupSortDTO(
          // Sort by count
          field: AggregateGroupSortType.metric,
          order: OrderType.asc,
        ),
      ]),
    ),
    null,
    calculateOnCurrentYear(event.start),
  );
}

class ReviewTotalTimeGroupByMonthThenMediaGetBloc
    extends
        FunctionActionBloc<
          ReviewStartEnd,
          List<
            AggregateGroupResultDTO<
              int,
              List<AggregateGroupResultDTO<String, Duration>>
            >
          >
        > {
  ReviewTotalTimeGroupByMonthThenMediaGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<
    List<
      AggregateGroupResultDTO<
        int,
        List<AggregateGroupResultDTO<String, Duration>>
      >
    >
  >
  doAction(
    final ReviewStartEnd event,
    final List<
      AggregateGroupResultDTO<
        int,
        List<AggregateGroupResultDTO<String, Duration>>
      >
    >?
    lastData,
  ) => service.sumTimeByStartDateMonthThenMedia(
    AggregateGroupSearch(
      filter: buildStartDateBetweenFilters(event.start, event.end),
      sort: List.unmodifiable(<AggregateGroupSortDTO>[
        AggregateGroupSortDTO(
          // Sort first by month
          field: AggregateGroupSortType.group,
          order: OrderType.asc,
        ),
        AggregateGroupSortDTO(
          // Then by time
          field: AggregateGroupSortType.metric,
          order: OrderType.desc,
        ),
      ]),
    ),
    null,
    calculateOnCurrentYear(event.start),
  );
}

class ReviewTop5MediasByTotalTimeListBloc
    extends FunctionActionBloc<ReviewStartEnd, List<MediaWithTime>> {
  ReviewTop5MediasByTotalTimeListBloc({
    required this.service,
    required this.gameService,
  });

  final GameSessionService service;
  final GameService gameService;

  @override
  Future<List<MediaWithTime>> doAction(
    final ReviewStartEnd event,
    final List<MediaWithTime>? lastData,
  ) async {
    final aggr = await service
        .sumTimeByMedia(
          AggregateGroupSearch(
            filter: buildStartDateBetweenFilters(event.start, event.end),
            sort: List.unmodifiable(<AggregateGroupSortDTO>[
              AggregateGroupSortDTO(
                // Sort by time
                field: AggregateGroupSortType.metric,
                order: OrderType.desc,
              ),
            ]),
            size: 5,
          ),
          null,
          calculateOnCurrentYear(event.start),
        )
        .then(_removeZeroDurationEntries);
    final search = await gameService.search(
      ListSearchDTO(
        filter: List.unmodifiable(<FilterDTO>[
          FilterDTO(
            field: 'id',
            operator_: OperatorType.in_,
            value: SearchValue(
              values: aggr.map((final el) => el.key).toList(growable: false),
            ),
            chainOperator: ChainOperatorType.and,
          ),
        ]),
        size: 5,
      ),
      null,
    );
    return aggr
        .map(
          (final el) => MediaWithTime(
            media: search.data.firstWhere((final m) => m.media.id == el.key),
            time: el.value,
          ),
        )
        .toList(growable: false);
  }
}

class ReviewTotalMediasGroupByRatingGetBloc
    extends
        FunctionActionBloc<
          ReviewStartEnd,
          List<AggregateGroupResultDTO<int, int>>
        > {
  ReviewTotalMediasGroupByRatingGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<List<AggregateGroupResultDTO<int, int>>> doAction(
    final ReviewStartEnd event,
    final List<AggregateGroupResultDTO<int, int>>? lastData,
  ) => service.countDistinctMediasByRating(
    AggregateGroupSearch(
      filter: buildStartDateBetweenFilters(event.start, event.end),
      sort: List.unmodifiable(<AggregateGroupSortDTO>[
        AggregateGroupSortDTO(
          // Sort by rating
          field: AggregateGroupSortType.group,
          order: OrderType.asc,
        ),
      ]),
    ),
    null,
    calculateOnCurrentYear(event.start),
  );
}

class ReviewTotalMediasGroupByGenreGetBloc
    extends
        FunctionActionBloc<
          ReviewStartEnd,
          List<AggregateGroupResultDTO<String, int>>
        > {
  ReviewTotalMediasGroupByGenreGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<List<AggregateGroupResultDTO<String, int>>> doAction(
    final ReviewStartEnd event,
    final List<AggregateGroupResultDTO<String, int>>? lastData,
  ) => service.countDistinctMediasByGenre(
    AggregateGroupSearch(
      filter: buildStartDateBetweenFilters(event.start, event.end),
      sort: List.unmodifiable(<AggregateGroupSortDTO>[
        AggregateGroupSortDTO(
          // Sort by count
          field: AggregateGroupSortType.metric,
          order: OrderType.desc,
        ),
      ]),
      size: 6,
    ),
    null,
    calculateOnCurrentYear(event.start),
  );
}

class ReviewTotalFinishedMediasGroupByMonthGetBloc
    extends
        FunctionActionBloc<
          ReviewStartEnd,
          List<AggregateGroupResultDTO<int, int>>
        > {
  ReviewTotalFinishedMediasGroupByMonthGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<List<AggregateGroupResultDTO<int, int>>> doAction(
    final ReviewStartEnd event,
    final List<AggregateGroupResultDTO<int, int>>? lastData,
  ) => service.countDistinctMediasByStartDateMonth(
    AggregateGroupSearch(
      filter: List.unmodifiable(<FilterDTO>[
        buildFinishedFilter(),
        ...buildStartDateBetweenFilters(event.start, event.end),
      ]),
      sort: List.unmodifiable(<AggregateGroupSortDTO>[
        AggregateGroupSortDTO(
          // Sort by month
          field: AggregateGroupSortType.group,
          order: OrderType.asc,
        ),
      ]),
    ),
    null,
    calculateOnCurrentYear(event.start),
  );
}

class ReviewTotalTimeGroupByWeekdayGetBloc
    extends
        FunctionActionBloc<
          ReviewStartEnd,
          List<AggregateGroupResultDTO<int, Duration>>
        > {
  ReviewTotalTimeGroupByWeekdayGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<List<AggregateGroupResultDTO<int, Duration>>> doAction(
    final ReviewStartEnd event,
    final List<AggregateGroupResultDTO<int, Duration>>? lastData,
  ) => service.sumTimeByStartDateWeekday(
    AggregateGroupSearch(
      filter: buildStartDateBetweenFilters(event.start, event.end),
      sort: List.unmodifiable(<AggregateGroupSortDTO>[
        AggregateGroupSortDTO(
          // Sort by weekday
          field: AggregateGroupSortType.group,
          order: OrderType.asc,
        ),
      ]),
    ),
    null,
    calculateOnCurrentYear(event.start),
  );
}

class ReviewTotalTimeGroupByHourGetBloc
    extends
        FunctionActionBloc<
          ReviewStartEnd,
          List<AggregateGroupResultDTO<int, Duration>>
        > {
  ReviewTotalTimeGroupByHourGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<List<AggregateGroupResultDTO<int, Duration>>> doAction(
    final ReviewStartEnd event,
    final List<AggregateGroupResultDTO<int, Duration>>? lastData,
  ) => service.sumTimeByStartDateHour(
    AggregateGroupSearch(
      filter: buildStartDateBetweenFilters(event.start, event.end),
      sort: List.unmodifiable(<AggregateGroupSortDTO>[
        AggregateGroupSortDTO(
          // Sort by hour
          field: AggregateGroupSortType.group,
          order: OrderType.asc,
        ),
      ]),
    ),
    null,
    calculateOnCurrentYear(event.start),
  );
}

List<AggregateGroupResultDTO<String, Duration>> _removeZeroDurationEntries(
  final List<AggregateGroupResultDTO<String, Duration>> value,
) => value
    .where((final element) => !element.value.isZero())
    .toList(growable: false);
