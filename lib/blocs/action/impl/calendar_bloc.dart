import 'package:game_oclock/models/models.dart'
    show mediaIdField, startDateField;
import 'package:game_oclock/services/services.dart' show SessionService;
import 'package:game_oclock/utils/filter_utils.dart';
import 'package:game_oclock_client/api.dart';

import '../action.dart'
    show FunctionActionBloc, IdentityActionBloc, ProducerActionBloc;

class CalendarDaySelectBloc extends IdentityActionBloc<DateTime> {
  @override
  Future<DateTime> doAction(DateTime event, DateTime? lastData) async => event;
}

class CalendarDayFocusBloc extends IdentityActionBloc<DateTime> {
  @override
  Future<DateTime> doAction(DateTime event, DateTime? lastData) async => event;
}

class LastSessionGetBloc extends ProducerActionBloc<SessionDTO?> {
  LastSessionGetBloc({required this.service});

  final SessionService service;

  @override
  Future<SessionDTO?> doAction(void event, SessionDTO? lastData) async {
    final data = await service
        .search(
          ListSearchDTO(
            sort: List.unmodifiable(<SortDTO>[
              SortDTO(field: startDateField.value, order: OrderType.desc),
            ]),
            size: 1,
          ),
          null,
        )
        .then((pageResult) => pageResult.data);
    return data.isEmpty ? null : data.first;
  }
}

class LastGameSessionGetBloc extends ProducerActionBloc<SessionDTO?> {
  LastGameSessionGetBloc({required this.service, required this.gameId});

  final SessionService service;
  final String gameId;

  @override
  Future<SessionDTO?> doAction(void event, SessionDTO? lastData) async {
    final data = await service
        .searchForGame(
          gameId,
          ListSearchDTO(
            sort: List.unmodifiable(<SortDTO>[
              SortDTO(field: startDateField.value, order: OrderType.desc),
            ]),
            size: 1,
          ),
          null,
        )
        .then((pageResult) => pageResult.data);
    return data.isEmpty ? null : data.first;
  }
}

class CalendarYearDatesBloc
    extends FunctionActionBloc<DateTime, Set<DateTime>> {
  CalendarYearDatesBloc({required this.service})
    : cache = <int, Set<DateTime>>{};

  final SessionService service;
  final Map<int, Set<DateTime>> cache;

  @override
  Future<Set<DateTime>> doAction(
    DateTime event,
    Set<DateTime>? lastData,
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

  final SessionService service;
  final String gameId;
  final Map<int, Set<DateTime>> cache;

  @override
  Future<Set<DateTime>> doAction(
    DateTime event,
    Set<DateTime>? lastData,
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
            field: mediaIdField.value,
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

Future<Set<DateTime>> _searchSessionDates(
  SessionService service,
  ListSearchDTO search,
  String? quicksearch,
  FetchMode? mode,
) async {
  final dates = await service.searchDates(search, quicksearch, mode);
  return dates.toSet();
}
