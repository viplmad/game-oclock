import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:backend/utils/time_of_day_extension.dart';

import 'time_log_assistant.dart';

class TimeLogAssistantBloc
    extends Bloc<TimeLogAssistantEvent, TimeLogAssistantState> {
  TimeLogAssistantBloc() : super(TimeLogAssistantState(DateTime.now())) {
    on<UpdateTimeLogDate>(_mapUpdateDateToState);
    on<UpdateTimeLogStartTime>(_mapUpdateStartTimeToState);
    on<UpdateTimeLogEndTime>(_mapUpdateEndTimeToState);
    on<UpdateTimeLogDuration>(_mapUpdateDurationToState);
    on<UpdateTimeLogRecalculationMode>(_mapUpdateModeToState);
  }

  void _mapUpdateDateToState(
    UpdateTimeLogDate event,
    Emitter<TimeLogAssistantState> emit,
  ) {
    emit(
      TimeLogAssistantState(
        event.date,
        state.startTime,
        state.endTime,
        state.duration,
        state.recalculationMode,
      ),
    );
  }

  void _mapUpdateStartTimeToState(
    UpdateTimeLogStartTime event,
    Emitter<TimeLogAssistantState> emit,
  ) {
    final TimeOfDay startTime = event.startTime;

    TimeOfDay? endTime = state.endTime;
    Duration? duration = state.duration;
    if (endTime == null && duration != null) {
      endTime = startTime.add(duration);
    } else if (endTime != null && duration == null) {
      duration = _differenceStartEnd(startTime, endTime);
    } else if (endTime != null && duration != null) {
      final TimeLogRecalculationMode recalculationMode =
          state.recalculationMode;
      if (recalculationMode == TimeLogRecalculationMode.duration) {
        duration = _differenceStartEnd(startTime, endTime);
      } else if (recalculationMode == TimeLogRecalculationMode.time) {
        endTime = startTime.add(duration);
      }
    }

    emit(
      TimeLogAssistantState(
        state.date,
        event.startTime,
        endTime,
        duration,
        state.recalculationMode,
      ),
    );
  }

  void _mapUpdateEndTimeToState(
    UpdateTimeLogEndTime event,
    Emitter<TimeLogAssistantState> emit,
  ) {
    final TimeOfDay endTime = event.endTime;

    TimeOfDay? startTime = state.startTime;
    Duration? duration = state.duration;
    if (startTime == null && duration != null) {
      startTime = endTime.subtract(duration);
    } else if (startTime != null && duration == null) {
      duration = _differenceStartEnd(startTime, endTime);
    } else if (startTime != null && duration != null) {
      final TimeLogRecalculationMode recalculationMode =
          state.recalculationMode;
      if (recalculationMode == TimeLogRecalculationMode.duration) {
        duration = _differenceStartEnd(startTime, endTime);
      } else if (recalculationMode == TimeLogRecalculationMode.time) {
        startTime = endTime.subtract(duration);
      }
    }

    emit(
      TimeLogAssistantState(
        state.date,
        startTime,
        event.endTime,
        duration,
        state.recalculationMode,
      ),
    );
  }

  void _mapUpdateDurationToState(
    UpdateTimeLogDuration event,
    Emitter<TimeLogAssistantState> emit,
  ) {
    final Duration duration = event.duration;

    TimeOfDay? startTime = state.startTime;
    TimeOfDay? endTime = state.endTime;
    if (startTime == null && endTime != null) {
      startTime = endTime.subtract(duration);
    } else if ((startTime != null && endTime == null) ||
        (startTime != null && endTime != null)) {
      endTime = startTime.add(duration);
    }

    emit(
      TimeLogAssistantState(
        state.date,
        startTime,
        endTime,
        event.duration,
        state.recalculationMode,
      ),
    );
  }

  void _mapUpdateModeToState(
    UpdateTimeLogRecalculationMode event,
    Emitter<TimeLogAssistantState> emit,
  ) {
    emit(
      TimeLogAssistantState(
        state.date,
        state.startTime,
        state.endTime,
        state.duration,
        event.mode,
      ),
    );
  }

  static Duration _differenceStartEnd(TimeOfDay startTime, TimeOfDay endTime) {
    if (endTime.hour == 0 && endTime.minute == 0) {
      const TimeOfDay endOfDay = TimeOfDay(hour: 23, minute: 59);
      final Duration differenceToEndOfDay = endOfDay.difference(startTime);
      return Duration(minutes: differenceToEndOfDay.inMinutes + 1);
    }

    return endTime.difference(startTime);
  }
}
