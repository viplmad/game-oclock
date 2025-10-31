import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show DateLocaleConfig;

import '../action.dart' show ActionFinal, ActionSuccess, IdentityActionBloc;

class DateLocaleConfigBloc extends IdentityActionBloc<DateLocaleConfig> {
  @override
  Future<ActionFinal<DateLocaleConfig, DateLocaleConfig>> doAction(
    final DateLocaleConfig event,
    final DateLocaleConfig? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}

class ThemeModeBloc extends IdentityActionBloc<ThemeMode?> {
  @override
  Future<ActionFinal<ThemeMode?, ThemeMode?>> doAction(
    final ThemeMode? event,
    final ThemeMode? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}

class LocaleBloc extends IdentityActionBloc<Locale?> {
  @override
  Future<ActionFinal<Locale?, Locale?>> doAction(
    final Locale? event,
    final Locale? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
