import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:logic/model/model.dart' show GameLogRecalculationMode;
import 'package:logic/utils/time_of_day_extension.dart';

import 'time_log_assistant.dart';

class GameLogAssistantBloc
    extends Bloc<GameLogAssistantEvent, GameLogAssistantState> {
  GameLogAssistantBloc() : super(GameLogAssistantState(DateTime.now())) {
    on<UpdateGameLogDate>(_mapUpdateDateToState);
    on<UpdateGameLogStartTime>(_mapUpdateStartTimeToState);
    on<UpdateGameLogEndTime>(_mapUpdateEndTimeToState);
    on<UpdateGameLogDuration>(_mapUpdateDurationToState);
    on<UpdateGameLogRecalculationMode>(_mapUpdateModeToState);
  }

  void _mapUpdateDateToState(
    UpdateGameLogDate event,
    Emitter<GameLogAssistantState> emit,
  ) {
    emit(
      GameLogAssistantState(
        event.date,
        state.startTime,
        state.endTime,
        state.duration,
        state.recalculationMode,
      ),
    );
  }

  void _mapUpdateStartTimeToState(
    UpdateGameLogStartTime event,
    Emitter<GameLogAssistantState> emit,
  ) {
    final TimeOfDay startTime = event.startTime;

    TimeOfDay? endTime = state.endTime;
    Duration? duration = state.duration;
    if (endTime == null && duration != null) {
      endTime = startTime.add(duration);
    } else if (endTime != null && duration == null) {
      duration = _differenceStartEnd(startTime, endTime);
    } else if (endTime != null && duration != null) {
      final GameLogRecalculationMode recalculationMode =
          state.recalculationMode;
      if (recalculationMode == GameLogRecalculationMode.duration) {
        duration = _differenceStartEnd(startTime, endTime);
      } else if (recalculationMode == GameLogRecalculationMode.time) {
        endTime = startTime.add(duration);
      }
    }

    emit(
      GameLogAssistantState(
        state.date,
        event.startTime,
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
    final TimeOfDay endTime = event.endTime;

    TimeOfDay? startTime = state.startTime;
    Duration? duration = state.duration;
    if (startTime == null && duration != null) {
      startTime = endTime.subtract(duration);
    } else if (startTime != null && duration == null) {
      duration = _differenceStartEnd(startTime, endTime);
    } else if (startTime != null && duration != null) {
      final GameLogRecalculationMode recalculationMode =
          state.recalculationMode;
      if (recalculationMode == GameLogRecalculationMode.duration) {
        duration = _differenceStartEnd(startTime, endTime);
      } else if (recalculationMode == GameLogRecalculationMode.time) {
        startTime = endTime.subtract(duration);
      }
    }

    emit(
      GameLogAssistantState(
        state.date,
        startTime,
        event.endTime,
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

    TimeOfDay? startTime = state.startTime;
    TimeOfDay? endTime = state.endTime;
    if (startTime == null && endTime != null) {
      startTime = endTime.subtract(duration);
    } else if ((startTime != null && endTime == null) ||
        (startTime != null && endTime != null)) {
      endTime = startTime.add(duration);
    }

    emit(
      GameLogAssistantState(
        state.date,
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
