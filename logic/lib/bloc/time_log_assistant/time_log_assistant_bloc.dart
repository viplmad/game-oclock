import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:logic/model/model.dart'
    show GameLogErrorCode, GameLogRecalculationMode;
import 'package:logic/utils/datetime_extension.dart';
import 'package:logic/utils/duration_extension.dart';

import '../time_log_assistant_manager/time_log_assistant_manager.dart';
import 'time_log_assistant.dart';

class GameLogAssistantBloc
    extends Bloc<GameLogAssistantEvent, GameLogAssistantState> {
  GameLogAssistantBloc({required this.managerBloc})
      : super(GameLogAssistantState(DateTime.now(), DateTime.now())) {
    on<UpdateGameLogStartDate>(_mapUpdateStartDateToState);
    on<UpdateGameLogEndDate>(_mapUpdateEndDateToState);
    on<UpdateGameLogStartTime>(_mapUpdateStartTimeToState);
    on<UpdateGameLogEndTime>(_mapUpdateEndTimeToState);
    on<UpdateGameLogDuration>(_mapUpdateDurationToState);
    on<UpdateGameLogRecalculationMode>(_mapUpdateModeToState);
  }

  final GameLogAssistantManagerBloc managerBloc;

  void _mapUpdateStartDateToState(
    UpdateGameLogDate event,
    Emitter<GameLogAssistantState> emit,
  ) {
    final DateTime startDate = event.date;
    DateTime endDate = state.endDate;
    if (!_checkStartEnd(startDate, endDate)) {
      managerBloc.add(
        const WarnGameLogAssistantInvalid(
          GameLogErrorCode.startDateAfterEndDate,
          'Start date must be previous than end date',
        ),
      );
      return;
    }

    final TimeOfDay? startTime = state.startTime;
    TimeOfDay? endTime = state.endTime;
    Duration? duration = state.duration;
    if (startTime != null && endTime != null) {
      if (duration == null) {
        // Calculate duration for the first time
        duration = _calculateDuration(startDate, endDate, startTime, endTime);
      } else {
        // All data is filled -> must recalculate
        if (state.recalculationMode == GameLogRecalculationMode.duration) {
          // Recalculate duration
          duration = _calculateDuration(startDate, endDate, startTime, endTime);
        } else {
          // Recalculate end date and time
          (endDate, endTime) =
              _recalculateEndDateAndTime(startDate, startTime, duration);
        }
      }

      // Check afterwards because dates may have been recalulated
      if (!_checkStartEndWithTime(startDate, endDate, startTime, endTime)) {
        managerBloc.add(
          const WarnGameLogAssistantInvalid(
            GameLogErrorCode.startDateTimeAfterEndDateTime,
            'Start date and time must be previous than end date and time',
          ),
        );
        return;
      }
    }

    emit(
      GameLogAssistantState(
        event.date,
        endDate,
        state.startTime,
        endTime,
        duration,
        state.recalculationMode,
      ),
    );
  }

  void _mapUpdateEndDateToState(
    UpdateGameLogDate event,
    Emitter<GameLogAssistantState> emit,
  ) {
    DateTime startDate = state.startDate;
    final DateTime endDate = event.date;
    if (!_checkStartEnd(startDate, endDate)) {
      managerBloc.add(
        const WarnGameLogAssistantInvalid(
          GameLogErrorCode.startDateAfterEndDate,
          'Start date must be previous than end date',
        ),
      );
      return;
    }

    TimeOfDay? startTime = state.startTime;
    final TimeOfDay? endTime = state.endTime;
    Duration? duration = state.duration;
    if (startTime != null && endTime != null) {
      if (duration == null) {
        // Calculate duration for the first time
        duration = _calculateDuration(startDate, endDate, startTime, endTime);
      } else {
        // All data is filled -> must recalculate
        if (state.recalculationMode == GameLogRecalculationMode.duration) {
          // Recalculate duration
          duration = _calculateDuration(startDate, endDate, startTime, endTime);
        } else {
          // Recalculate start date and time
          (startDate, startTime) =
              _recalculateStartDateAndTime(endDate, endTime, duration);
        }
      }

      // Check afterwards because dates may have been recalulated
      if (!_checkStartEndWithTime(startDate, endDate, startTime, endTime)) {
        managerBloc.add(
          const WarnGameLogAssistantInvalid(
            GameLogErrorCode.startDateTimeAfterEndDateTime,
            'Start date and time must be previous than end date and time',
          ),
        );
        return;
      }
    }

    emit(
      GameLogAssistantState(
        startDate,
        event.date,
        startTime,
        state.endTime,
        duration,
        state.recalculationMode,
      ),
    );
  }

  void _mapUpdateStartTimeToState(
    UpdateGameLogStartTime event,
    Emitter<GameLogAssistantState> emit,
  ) {
    final TimeOfDay startTime = event.time;
    TimeOfDay? endTime = state.endTime;

    final DateTime startDate = state.startDate;
    DateTime endDate = state.endDate;
    Duration? duration = state.duration;
    if (endTime != null) {
      if (duration == null) {
        // Calculate duration for the first time
        duration = _calculateDuration(startDate, endDate, startTime, endTime);
      } else {
        // All data is filled -> must recalculate
        if (state.recalculationMode == GameLogRecalculationMode.duration) {
          // Recalculate duration
          duration = _calculateDuration(startDate, endDate, startTime, endTime);
        } else {
          // Recalculate end date and time
          (endDate, endTime) =
              _recalculateEndDateAndTime(startDate, startTime, duration);
        }
      }

      // Check afterwards because dates may have been recalulated
      if (!_checkStartEndWithTime(startDate, endDate, startTime, endTime)) {
        managerBloc.add(
          const WarnGameLogAssistantInvalid(
            GameLogErrorCode.startDateTimeAfterEndDateTime,
            'Start date and time must be previous than end date and time',
          ),
        );
        return;
      }
    } else if (endTime == null && duration != null) {
      // Missing endTime -> calculate end date and time
      (endDate, endTime) =
          _recalculateEndDateAndTime(startDate, startTime, duration);
    }

    emit(
      GameLogAssistantState(
        state.startDate,
        endDate,
        event.time,
        endTime,
        duration,
        state.recalculationMode,
      ),
    );
  }

  void _mapUpdateEndTimeToState(
    UpdateGameLogEndTime event,
    Emitter<GameLogAssistantState> emit,
  ) {
    TimeOfDay? startTime = state.startTime;
    final TimeOfDay endTime = event.time;

    DateTime startDate = state.startDate;
    final DateTime endDate = state.endDate;
    Duration? duration = state.duration;
    if (startTime != null) {
      if (duration == null) {
        // Calculate duration for the first time
        duration = _calculateDuration(startDate, endDate, startTime, endTime);
      } else {
        // All data is filled -> must recalculate
        if (state.recalculationMode == GameLogRecalculationMode.duration) {
          // Recalculate duration
          duration = _calculateDuration(startDate, endDate, startTime, endTime);
        } else {
          // Recalculate start date and time
          (startDate, startTime) =
              _recalculateStartDateAndTime(endDate, endTime, duration);
        }
      }

      // Check afterwards because dates may have been recalulated
      if (!_checkStartEndWithTime(startDate, endDate, startTime, endTime)) {
        managerBloc.add(
          const WarnGameLogAssistantInvalid(
            GameLogErrorCode.startDateTimeAfterEndDateTime,
            'Start date and time must be previous than end date and time',
          ),
        );
        return;
      }
    } else if (startTime == null && duration != null) {
      // Missing startTime -> calculate start date and time
      (startDate, startTime) =
          _recalculateStartDateAndTime(endDate, endTime, duration);
    }

    emit(
      GameLogAssistantState(
        startDate,
        state.endDate,
        startTime,
        event.time,
        duration,
        state.recalculationMode,
      ),
    );
  }

  void _mapUpdateDurationToState(
    UpdateGameLogDuration event,
    Emitter<GameLogAssistantState> emit,
  ) {
    final Duration duration = event.duration;
    if (duration.isZero() || duration.isNegative) {
      managerBloc.add(
        const WarnGameLogAssistantInvalid(
          GameLogErrorCode.durationEmptyOrNegative,
          'Duration must not be an empty span of time',
        ),
      );
      return;
    }

    DateTime startDate = state.startDate;
    DateTime endDate = state.endDate;
    TimeOfDay? startTime = state.startTime;
    TimeOfDay? endTime = state.endTime;
    if (startTime != null && endTime != null) {
      // All data is filled -> must recalculate
      // Recalculate end date and time
      (endDate, endTime) =
          _recalculateEndDateAndTime(startDate, startTime, duration);
    } else if (startTime == null && endTime != null) {
      // Missing startTime -> calculate start date and time
      (startDate, startTime) =
          _recalculateStartDateAndTime(endDate, endTime, duration);
    } else if (startTime != null && endTime == null) {
      // Missing endTime -> calculate end date and time
      (endDate, endTime) =
          _recalculateEndDateAndTime(startDate, startTime, duration);
    }

    emit(
      GameLogAssistantState(
        startDate,
        endDate,
        startTime,
        endTime,
        event.duration,
        state.recalculationMode,
      ),
    );
  }

  void _mapUpdateModeToState(
    UpdateGameLogRecalculationMode event,
    Emitter<GameLogAssistantState> emit,
  ) {
    emit(
      GameLogAssistantState(
        state.startDate,
        state.endDate,
        state.startTime,
        state.endTime,
        state.duration,
        event.mode,
      ),
    );
  }

  bool _checkStartEnd(DateTime startDate, DateTime endDate) =>
      startDate.isSameDay(endDate) || startDate.isBefore(endDate);

  bool _checkStartEndWithTime(
    DateTime startDate,
    DateTime endDate,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) {
    final DateTime startDateTime = startDate.withTime(startTime);
    final DateTime endDateTime = endDate.withTime(endTime);
    return endDateTime.isAfter(startDateTime);
  }

  Duration _calculateDuration(
    DateTime startDate,
    DateTime endDate,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) {
    final DateTime startDateTime = startDate.withTime(startTime);
    final DateTime endDateTime = endDate.withTime(endTime);

    return endDateTime.difference(startDateTime);
  }

  (DateTime, TimeOfDay) _recalculateStartDateAndTime(
    DateTime endDate,
    TimeOfDay endTime,
    Duration duration,
  ) {
    final DateTime endDateTime = endDate.withTime(endTime);

    final DateTime startDateTime = endDateTime.subtract(duration);
    return (startDateTime.toDate(), TimeOfDay.fromDateTime(startDateTime));
  }

  (DateTime, TimeOfDay) _recalculateEndDateAndTime(
    DateTime startDate,
    TimeOfDay startTime,
    Duration duration,
  ) {
    final DateTime startDateTime = startDate.withTime(startTime);

    final DateTime endDateTime = startDateTime.add(duration);
    return (endDateTime.toDate(), TimeOfDay.fromDateTime(endDateTime));
  }
}
