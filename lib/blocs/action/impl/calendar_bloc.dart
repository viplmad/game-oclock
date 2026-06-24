import 'package:game_oclock/services/services.dart' show GameSessionService;
import 'package:game_oclock/utils/date_time_extension.dart';
import 'package:game_oclock/utils/filter_utils.dart';
import 'package:game_oclock_client/api.dart';

import '../action.dart'
    show FunctionActionBloc, IdentityActionBloc, ProducerActionBloc;

class CalendarDaySelectBloc extends IdentityActionBloc<DateTime> {
  @override
  Future<DateTime> doAction(
    final DateTime event,
    final DateTime? lastData,
  ) async => event;
}

class CalendarDayFocusBloc extends IdentityActionBloc<DateTime> {
  @override
  Future<DateTime> doAction(
    final DateTime event,
    final DateTime? lastData,
  ) async => event;
}

class LastSessionGetBloc extends ProducerActionBloc<SessionDTO?> {
  LastSessionGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<SessionDTO?> doAction(
    final void event,
    final SessionDTO? lastData,
  ) async {
    final data = await service
        .search(
          ListSearchDTO(
            sort: List.unmodifiable(<SortDTO>[
              SortDTO(field: 'start_date', order: OrderType.desc),
            ]),
            size: 1,
          ),
          null,
        )
        .then((final pageResult) => pageResult.data);
    return data.isEmpty ? null : data.first;
  }
}

class LastGameSessionGetBloc extends ProducerActionBloc<SessionDTO?> {
  LastGameSessionGetBloc({required this.service, required this.gameId});

  final GameSessionService service;
  final String gameId;

  @override
  Future<SessionDTO?> doAction(
    final void event,
    final SessionDTO? lastData,
  ) async {
    final data = await service
        .searchForGame(
          gameId,
          ListSearchDTO(
            sort: List.unmodifiable(<SortDTO>[
              SortDTO(field: 'start_date', order: OrderType.desc),
            ]),
            size: 1,
          ),
          null,
        )
        .then((final pageResult) => pageResult.data);
    return data.isEmpty ? null : data.first;
  }
}

class CalendarYearDatesBloc
    extends FunctionActionBloc<DateTime, Set<DateTime>> {
  CalendarYearDatesBloc({required this.service})
    : cache = <int, Set<DateTime>>{};

  final GameSessionService service;
  final Map<int, Set<DateTime>> cache;

  @override
  Future<Set<DateTime>> doAction(
    final DateTime event,
    final Set<DateTime>? lastData,
  ) async {
    final year = event.year;
    if (cache.containsKey(year)) {
      return Future.value(cache[year]);
    }

    final start = DateTime(year);
    final end = DateTime(year + 1);
    final dates = await _searchSessionDates(
      service,
      ListSearchDTO(filter: buildStartDateBetweenFilters(start, end)),
      null,
      calculateOnCurrentYear(start),
    );

    cache[year] = dates;
    return dates;
  }
}

class CalendarGameYearDatesBloc
    extends FunctionActionBloc<DateTime, Set<DateTime>> {
  CalendarGameYearDatesBloc({required this.service, required this.gameId})
    : cache = <int, Set<DateTime>>{};

  final GameSessionService service;
  final String gameId;
  final Map<int, Set<DateTime>> cache;

  @override
  Future<Set<DateTime>> doAction(
    final DateTime event,
    final Set<DateTime>? lastData,
  ) async {
    final year = event.year;
    if (cache.containsKey(year)) {
      return Future.value(cache[year]);
    }

    final start = DateTime(year);
    final end = DateTime(year + 1);
    final dates = await _searchSessionDates(
      service,
      ListSearchDTO(
        filter: List.unmodifiable(<FilterDTO>[
          FilterDTO(
            field: 'media_id',
            operator_: OperatorType.eq,
            value: SearchValue(value: gameId),
            chainOperator: ChainOperatorType.and,
          ),
          ...buildStartDateBetweenFilters(start, end),
        ]),
      ),
      null,
      calculateOnCurrentYear(start),
    );

    cache[year] = dates;
    return dates;
  }
}

// TODO use something else than streak endpoint
Future<Set<DateTime>> _searchSessionDates(
  final GameSessionService service,
  final ListSearchDTO search,
  final String? quicksearch,
  final FetchMode? mode,
) async {
  final streaks = await service
      .searchStreaks(search, quicksearch, mode)
      .then((final pageResult) => pageResult.data);
  return streaks
      .map(
        (final s) => List.generate(
          s.days,
          (final days) => s.startDate.addDays(days),
          growable: false,
        ),
      )
      .expand((final d) => d)
      .toSet();
}
