import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show DateLocaleConfig;

import '../action.dart' show ActionFinal, ActionSuccess, FunctionActionBloc;

class DateLocaleConfigBloc
    extends FunctionActionBloc<DateLocaleConfig, DateLocaleConfig> {
  @override
  Future<ActionFinal<DateLocaleConfig, DateLocaleConfig>> doAction(
    final DateLocaleConfig event,
    final DateLocaleConfig? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}

class ThemeModeBloc extends FunctionActionBloc<ThemeMode, ThemeMode> {
  @override
  Future<ActionFinal<ThemeMode, ThemeMode>> doAction(
    final ThemeMode event,
    final ThemeMode? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}

class LocaleBloc extends FunctionActionBloc<Locale, Locale> {
  @override
  Future<ActionFinal<Locale, Locale>> doAction(
    final Locale event,
    final Locale? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
