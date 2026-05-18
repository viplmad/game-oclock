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
import 'package:game_oclock/utils/date_time_extension.dart';
import 'package:game_oclock/utils/duration_extension.dart';
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
            sort: AggregateGroupSortDTO(
              field: AggregateGroupSortType.metric,
              order: OrderType.desc,
            ),
            size: 1,
          ),
          null,
        )
        .then(removeZeroDurationEntries)
        .then((final result) => result.first);
    if (aggr.key == '00000000-0000-0000-0000-000000000000') {
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
            sort: AggregateGroupSortDTO(
              field: AggregateGroupSortType.metric,
              order: OrderType.desc,
            ),
            size: 5,
          ),
          null,
        )
        .then(removeZeroDurationEntries);
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

List<AggregateGroupResultDTO<String, Duration>> removeZeroDurationEntries(
  final List<AggregateGroupResultDTO<String, Duration>> value,
) => value
    .where((final element) => !element.value.isZero())
    .toList(growable: false);
