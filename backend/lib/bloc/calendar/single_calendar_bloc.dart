import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/utils/datetime_extension.dart';

import 'package:backend/entity/entity.dart'
    show GameFinishEntity, GameID, GameTimeLogEntity;
import 'package:backend/model/model.dart' show GameFinish, GameTimeLog;
import 'package:backend/mapper/mapper.dart'
    show GameFinishMapper, GameTimeLogMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, GameFinishRepository, GameTimeLogRepository;
import 'package:backend/model/calendar_range.dart';
import 'package:backend/model/calendar_style.dart';

import '../bloc_utils.dart';
import '../item_relation_manager/item_relation_manager.dart';
import 'single_calendar.dart';
import 'range_list_utils.dart';

class SingleCalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  SingleCalendarBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required this.timeLogManagerBloc,
    required this.finishDateManagerBloc,
  })  : id = GameID(itemId),
        gameTimeLogRepository = collectionRepository.gameTimeLogRepository,
        gameFinishRepository = collectionRepository.gameFinishRepository,
        super(CalendarLoading()) {
    on<LoadSingleCalendar>(_mapLoadToState);
    on<UpdateSelectedDate>(_mapUpdateSelectedDateToState);
    on<UpdateCalendarRange>(_mapUpdateRangeToState);
    on<UpdateCalendarStyle>(_mapUpdateStyleToState);
    on<UpdateSelectedDateFirst>(_mapUpdateSelectedDateFirstToState);
    on<UpdateSelectedDateLast>(_mapUpdateSelectedDateLastToState);
    on<UpdateSelectedDatePrevious>(_mapUpdateSelectedDatePreviousToState);
    on<UpdateSelectedDateNext>(_mapUpdateSelectedDateNextToState);
    on<UpdateSingleCalendar>(_mapUpdateToState);

    timeLogManagerSubscription =
        timeLogManagerBloc.stream.listen(mapTimeLogManagerStateToEvent);
    finishDateManagerSubscription =
        finishDateManagerBloc.stream.listen(mapFinishDateManagerStateToEvent);
  }

  final GameID id;
  final GameTimeLogRepository gameTimeLogRepository;
  final GameFinishRepository gameFinishRepository;
  final GameRelationManagerBloc<GameTimeLog> timeLogManagerBloc;
  final GameRelationManagerBloc<GameFinish> finishDateManagerBloc;
  late final StreamSubscription<ItemRelationManagerState>
      timeLogManagerSubscription;
  late final StreamSubscription<ItemRelationManagerState>
      finishDateManagerSubscription;

  Future<void> _checkConnection(Emitter<CalendarState> emit) async {
    await BlocUtils.checkConnection<CalendarState, CalendarNotLoaded>(
      gameTimeLogRepository,
      emit,
      (final String error) => CalendarNotLoaded(error),
    );
  }

  void _mapLoadToState(
    LoadSingleCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    await _checkConnection(emit);

    emit(
      CalendarLoading(),
    );

    try {
      final List<GameTimeLog> timeLogs = await getReadAllTimeLogsStream();
      final List<GameFinish> finishDates = await getReadAllFinishDatesStream();

      final Set<DateTime> logDates = timeLogs.fold(
        SplayTreeSet<DateTime>(),
        (Set<DateTime> previousDates, GameTimeLog log) =>
            previousDates..add(log.dateTime),
      );

      DateTime selectedDate = DateTime.now();
      if (logDates.isNotEmpty) {
        selectedDate = logDates.last;
      }

      const CalendarRange range = CalendarRange.day;
      final List<GameTimeLog> selectedTimeLogs =
          _selectedTimeLogsInRange(timeLogs, selectedDate, range);

      final Duration selectedTotalTime =
          RangeListUtils.getTotalTime(selectedTimeLogs);

      final bool isSelectedDateFinish =
          _isSelectedDateFinish(finishDates, selectedDate);

      emit(
        SingleCalendarLoaded(
          timeLogs,
          logDates,
          finishDates,
          selectedDate,
          selectedTimeLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
        ),
      );
    } catch (e) {
      emit(
        CalendarNotLoaded(e.toString()),
      );
    }
  }

  void _mapUpdateSelectedDateToState(
    UpdateSelectedDate event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs =
          (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      final DateTime previousSelectedDate =
          (state as SingleCalendarLoaded).selectedDate;

      List<GameTimeLog> selectedTimeLogs;
      Duration selectedTotalTime;
      if (RangeListUtils.doesNewDateNeedRecalculation(
        event.date,
        previousSelectedDate,
        range,
      )) {
        selectedTimeLogs =
            _selectedTimeLogsInRange(timeLogs, event.date, range);

        selectedTotalTime = RangeListUtils.getTotalTime(selectedTimeLogs);
      } else {
        selectedTimeLogs = (state as SingleCalendarLoaded).selectedTimeLogs;
        selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;
      }

      final bool isSelectedDateFinish =
          _isSelectedDateFinish(finishDates, event.date);

      emit(
        SingleCalendarLoaded(
          timeLogs,
          logDates,
          finishDates,
          event.date,
          selectedTimeLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
          style,
        ),
      );
    }
  }

  void _mapUpdateSelectedDateFirstToState(
    UpdateSelectedDateFirst event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;

      if (logDates.isNotEmpty) {
        final DateTime firstDate = logDates.first;

        add(UpdateSelectedDate(firstDate));
      }
    }
  }

  void _mapUpdateSelectedDateLastToState(
    UpdateSelectedDateLast event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;

      if (logDates.isNotEmpty) {
        final DateTime lastDate = logDates.last;

        add(UpdateSelectedDate(lastDate));
      }
    }
  }

  void _mapUpdateSelectedDatePreviousToState(
    UpdateSelectedDatePrevious event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;
      final CalendarRange range = (state as SingleCalendarLoaded).range;

      final DateTime previousDate =
          RangeListUtils.getPreviousDateWithLogs(logDates, selectedDate, range);

      add(UpdateSelectedDate(previousDate));
    }
  }

  void _mapUpdateSelectedDateNextToState(
    UpdateSelectedDateNext event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;
      final CalendarRange range = (state as SingleCalendarLoaded).range;

      final DateTime nextDate =
          RangeListUtils.getNextDateWithLogs(logDates, selectedDate, range);

      add(UpdateSelectedDate(nextDate));
    }
  }

  void _mapUpdateRangeToState(
    UpdateCalendarRange event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs =
          (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;
      final bool isSelectedDateFinish =
          (state as SingleCalendarLoaded).isSelectedDateFinish;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      final CalendarRange previousRange = (state as SingleCalendarLoaded).range;

      if (event.range != previousRange) {
        final List<GameTimeLog> selectedTimeLogs =
            _selectedTimeLogsInRange(timeLogs, selectedDate, event.range);

        final Duration selectedTotalTime =
            RangeListUtils.getTotalTime(selectedTimeLogs);

        emit(
          SingleCalendarLoaded(
            timeLogs,
            logDates,
            finishDates,
            selectedDate,
            selectedTimeLogs,
            isSelectedDateFinish,
            selectedTotalTime,
            event.range,
            style,
          ),
        );
      }
    }
  }

  void _mapUpdateStyleToState(
    UpdateCalendarStyle event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs =
          (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;
      final List<GameTimeLog> selectedTimeLogs =
          (state as SingleCalendarLoaded).selectedTimeLogs;
      final bool isSelectedDateFinish =
          (state as SingleCalendarLoaded).isSelectedDateFinish;
      final Duration selectedTotalTime =
          (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as SingleCalendarLoaded).range;

      final int rotatingIndex =
          ((state as SingleCalendarLoaded).style.index + 1) %
              CalendarStyle.values.length;
      final CalendarStyle updatedStyle =
          CalendarStyle.values.elementAt(rotatingIndex);

      emit(
        SingleCalendarLoaded(
          timeLogs,
          logDates,
          finishDates,
          selectedDate,
          selectedTimeLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
          updatedStyle,
        ),
      );
    }
  }

  void _mapUpdateToState(
    UpdateSingleCalendar event,
    Emitter<CalendarState> emit,
  ) {
    emit(
      SingleCalendarLoaded(
        event.timeLogs,
        event.logDates,
        event.finishDates,
        event.selectedDate,
        event.selectedTimeLogs,
        event.isSelectedDateFinish,
        event.selectedTotalTime,
        event.range,
        event.style,
      ),
    );
  }

  void mapTimeLogManagerStateToEvent(ItemRelationManagerState managerState) {
    if (managerState is ItemRelationAdded<GameTimeLog>) {
      _mapAddedTimeLogToEvent(managerState);
    } else if (managerState is ItemRelationDeleted<GameTimeLog>) {
      _mapDeletedTimeLogToEvent(managerState);
    }
  }

  void mapFinishDateManagerStateToEvent(ItemRelationManagerState managerState) {
    if (managerState is ItemRelationAdded<GameFinish>) {
      _mapAddedFinishDateToEvent(managerState);
    } else if (managerState is ItemRelationDeleted<GameFinish>) {
      _mapDeletedFinishDateToEvent(managerState);
    }
  }

  void _mapAddedTimeLogToEvent(ItemRelationAdded<GameTimeLog> managerState) {
    if (state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs =
          (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      List<GameTimeLog> selectedTimeLogs =
          (state as SingleCalendarLoaded).selectedTimeLogs;
      final bool isSelectedDateFinish =
          (state as SingleCalendarLoaded).isSelectedDateFinish;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;

      final GameTimeLog addedGameLog = managerState.otherItem;

      if (timeLogs.isEmpty) {
        selectedDate = addedGameLog.dateTime;
      }

      final List<GameTimeLog> updatedTimeLogs = List<GameTimeLog>.from(timeLogs)
        ..add(addedGameLog);
      final Set<DateTime> updatedLogDates =
          SplayTreeSet<DateTime>.from(logDates)..add(addedGameLog.dateTime);

      Duration selectedTotalTime =
          (state as SingleCalendarLoaded).selectedTotalTime;
      if (range == CalendarRange.day &&
          addedGameLog.dateTime.isSameDay(selectedDate)) {
        selectedTimeLogs = List<GameTimeLog>.from(selectedTimeLogs)
          ..add(addedGameLog);
        selectedTimeLogs.sort();

        selectedTotalTime = selectedTotalTime + addedGameLog.time;
      } else if (range == CalendarRange.week &&
          addedGameLog.dateTime.isInWeekOf(selectedDate)) {
        final int weekIndex = addedGameLog.dateTime.weekday - 1;
        final GameTimeLog dayTimeLog = selectedTimeLogs.elementAt(weekIndex);
        selectedTimeLogs[weekIndex] = GameTimeLog(
          dateTime: dayTimeLog.dateTime,
          time: dayTimeLog.time + addedGameLog.time,
        );

        selectedTotalTime = selectedTotalTime + addedGameLog.time;
      } else if (range == CalendarRange.month &&
          addedGameLog.dateTime.isInMonthAndYearOf(selectedDate)) {
        final int monthIndex = addedGameLog.dateTime.day - 1;
        final GameTimeLog dayTimeLog = selectedTimeLogs.elementAt(monthIndex);
        selectedTimeLogs[monthIndex] = GameTimeLog(
          dateTime: dayTimeLog.dateTime,
          time: dayTimeLog.time + addedGameLog.time,
        );

        selectedTotalTime = selectedTotalTime + addedGameLog.time;
      } else if (range == CalendarRange.year &&
          addedGameLog.dateTime.isInYearOf(selectedDate)) {
        final int yearIndex = addedGameLog.dateTime.month - 1;
        final GameTimeLog monthTimeLog = selectedTimeLogs.elementAt(yearIndex);
        selectedTimeLogs[yearIndex] = GameTimeLog(
          dateTime: monthTimeLog.dateTime,
          time: monthTimeLog.time + addedGameLog.time,
        );

        selectedTotalTime = selectedTotalTime + addedGameLog.time;
      }

      add(
        UpdateSingleCalendar(
          updatedTimeLogs,
          updatedLogDates,
          finishDates,
          selectedDate,
          selectedTimeLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
          style,
        ),
      );
    }
  }

  void _mapDeletedTimeLogToEvent(
    ItemRelationDeleted<GameTimeLog> managerState,
  ) {
    if (state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs =
          (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      List<GameTimeLog> selectedTimeLogs =
          (state as SingleCalendarLoaded).selectedTimeLogs;
      final bool isSelectedDateFinish =
          (state as SingleCalendarLoaded).isSelectedDateFinish;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;

      final GameTimeLog deletedGameLog = managerState.otherItem;

      final List<GameTimeLog> updatedTimeLogs = timeLogs
          .where((GameTimeLog log) => log.dateTime != deletedGameLog.dateTime)
          .toList(growable: false);

      if (!updatedTimeLogs.any(
        (GameTimeLog log) => log.dateTime.isSameDay(deletedGameLog.dateTime),
      )) {
        logDates.removeWhere(
          (DateTime date) => date.isSameDay(deletedGameLog.dateTime),
        );
      }

      if (updatedTimeLogs.isEmpty) {
        selectedDate = DateTime.now();
      }

      Duration selectedTotalTime =
          (state as SingleCalendarLoaded).selectedTotalTime;
      if (range == CalendarRange.day &&
          deletedGameLog.dateTime.isSameDay(selectedDate)) {
        selectedTimeLogs = selectedTimeLogs
            .where(
              (GameTimeLog log) =>
                  !log.dateTime.isSameDay(deletedGameLog.dateTime),
            )
            .toList(growable: false);

        selectedTotalTime = selectedTotalTime - deletedGameLog.time;
      } else if (range == CalendarRange.week &&
          deletedGameLog.dateTime.isInWeekOf(selectedDate)) {
        final int weekIndex = deletedGameLog.dateTime.weekday - 1;
        final GameTimeLog dayTimeLog = selectedTimeLogs.elementAt(weekIndex);
        selectedTimeLogs[weekIndex] = GameTimeLog(
          dateTime: dayTimeLog.dateTime,
          time: dayTimeLog.time - deletedGameLog.time,
        );

        selectedTotalTime = selectedTotalTime - deletedGameLog.time;
      } else if (range == CalendarRange.month &&
          deletedGameLog.dateTime.isInMonthAndYearOf(selectedDate)) {
        final int monthIndex = deletedGameLog.dateTime.day - 1;
        final GameTimeLog dayTimeLog = selectedTimeLogs.elementAt(monthIndex);
        selectedTimeLogs[monthIndex] = GameTimeLog(
          dateTime: dayTimeLog.dateTime,
          time: dayTimeLog.time - deletedGameLog.time,
        );

        selectedTotalTime = selectedTotalTime - deletedGameLog.time;
      } else if (range == CalendarRange.year &&
          deletedGameLog.dateTime.isInYearOf(selectedDate)) {
        final int yearIndex = deletedGameLog.dateTime.month - 1;
        final GameTimeLog monthTimeLog = selectedTimeLogs.elementAt(yearIndex);
        selectedTimeLogs[yearIndex] = GameTimeLog(
          dateTime: monthTimeLog.dateTime,
          time: monthTimeLog.time - deletedGameLog.time,
        );

        selectedTotalTime = selectedTotalTime - deletedGameLog.time;
      }

      add(
        UpdateSingleCalendar(
          updatedTimeLogs,
          logDates,
          finishDates,
          selectedDate,
          selectedTimeLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
          style,
        ),
      );
    }
  }

  void _mapAddedFinishDateToEvent(ItemRelationAdded<GameFinish> managerState) {
    if (state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs =
          (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;
      final List<GameTimeLog> selectedTimeLogs =
          (state as SingleCalendarLoaded).selectedTimeLogs;
      final Duration selectedTotalTime =
          (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      bool isSelectedDateFinish =
          (state as SingleCalendarLoaded).isSelectedDateFinish;

      final List<GameFinish> updatedFinishDates =
          List<GameFinish>.from(finishDates)..add(managerState.otherItem);

      isSelectedDateFinish = isSelectedDateFinish ||
          managerState.otherItem.dateTime.isSameDay(selectedDate);

      add(
        UpdateSingleCalendar(
          timeLogs,
          logDates,
          updatedFinishDates,
          selectedDate,
          selectedTimeLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
          style,
        ),
      );
    }
  }

  void _mapDeletedFinishDateToEvent(
    ItemRelationDeleted<GameFinish> managerState,
  ) {
    if (state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs =
          (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;
      final List<GameTimeLog> selectedTimeLogs =
          (state as SingleCalendarLoaded).selectedTimeLogs;
      final Duration selectedTotalTime =
          (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      bool isSelectedDateFinish =
          (state as SingleCalendarLoaded).isSelectedDateFinish;

      final List<GameFinish> updatedFinishDates = finishDates
          .where(
            (GameFinish finish) =>
                !finish.dateTime.isSameDay(managerState.otherItem.dateTime),
          )
          .toList(growable: false);

      isSelectedDateFinish = !(isSelectedDateFinish &&
          managerState.otherItem.dateTime.isSameDay(selectedDate));

      add(
        UpdateSingleCalendar(
          timeLogs,
          logDates,
          updatedFinishDates,
          selectedDate,
          selectedTimeLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
          style,
        ),
      );
    }
  }

  List<GameTimeLog> _selectedTimeLogsInRange(
    List<GameTimeLog> timeLogs,
    DateTime selectedDate,
    CalendarRange range,
  ) {
    final List<GameTimeLog> selectedTimeLogs =
        RangeListUtils.createTimeLogListByRange(timeLogs, selectedDate, range);
    return selectedTimeLogs..sort();
  }

  bool _isSelectedDateFinish(
    List<GameFinish> finishDates,
    DateTime selectedDate,
  ) {
    return finishDates
        .any((GameFinish finish) => finish.dateTime.isSameDay(selectedDate));
  }

  @override
  Future<void> close() {
    timeLogManagerSubscription.cancel();
    finishDateManagerSubscription.cancel();
    return super.close();
  }

  @protected
  Future<List<GameTimeLog>> getReadAllTimeLogsStream() {
    final Future<List<GameTimeLogEntity>> entityListFuture =
        gameTimeLogRepository.findAllFromGame(id);
    return GameTimeLogMapper.futureEntityListToModelList(entityListFuture);
  }

  @protected
  Future<List<GameFinish>> getReadAllFinishDatesStream() {
    final Future<List<GameFinishEntity>> entityListFuture =
        gameFinishRepository.findAllFromGame(id);
    return GameFinishMapper.futureEntityListToModelList(entityListFuture);
  }
}
