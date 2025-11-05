import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show DateLocaleConfig;

import '../action.dart' show IdentityActionBloc;

class DateLocaleConfigBloc extends IdentityActionBloc<DateLocaleConfig> {
  @override
  Future<DateLocaleConfig> doAction(
    final DateLocaleConfig event,
    final DateLocaleConfig? lastData,
  ) async => event;
}

class ThemeModeBloc extends IdentityActionBloc<ThemeMode?> {
  @override
  Future<ThemeMode?> doAction(
    final ThemeMode? event,
    final ThemeMode? lastData,
  ) async => event;
}

class LocaleBloc extends IdentityActionBloc<Locale?> {
  @override
  Future<Locale?> doAction(final Locale? event, final Locale? lastData) async =>
      event;
}
