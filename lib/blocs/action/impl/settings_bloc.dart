import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show DateLocaleConfig;
import 'package:game_oclock/services/services.dart' show SettingsService;

import '../action.dart' show ConsumerActionBloc, ProducerActionBloc;

class ThemeModeGetBloc extends ProducerActionBloc<ThemeMode?> {
  ThemeModeGetBloc({required this.service});

  final SettingsService service;

  @override
  Future<ThemeMode?> doAction(final void event, final ThemeMode? lastData) =>
      service.getCurrentTheme();
}

class ThemeModeSaveBloc extends ConsumerActionBloc<ThemeMode?> {
  ThemeModeSaveBloc({required this.service});

  final SettingsService service;

  @override
  Future<void> doAction(final ThemeMode? event, final void lastData) =>
      event == null
      ? service.removeCurrentTheme()
      : service.saveCurrentTheme(event);
}

class LocaleGetBloc extends ProducerActionBloc<Locale?> {
  LocaleGetBloc({required this.service});

  final SettingsService service;

  @override
  Future<Locale?> doAction(final void event, final Locale? lastData) =>
      service.getCurrentLocale();
}

class LocaleSaveBloc extends ConsumerActionBloc<Locale?> {
  LocaleSaveBloc({required this.service});

  final SettingsService service;

  @override
  Future<void> doAction(final Locale? event, final void lastData) =>
      event == null
      ? service.removeCurrentLocale()
      : service.saveCurrentLocale(event);
}

class DateLocaleConfigGetBloc extends ProducerActionBloc<DateLocaleConfig?> {
  DateLocaleConfigGetBloc({required this.service});

  final SettingsService service;

  @override
  Future<DateLocaleConfig?> doAction(
    final void event,
    final DateLocaleConfig? lastData,
  ) => service.getCurrentDateConfig();
}

class DateLocaleConfigSaveBloc extends ConsumerActionBloc<DateLocaleConfig?> {
  DateLocaleConfigSaveBloc({required this.service});

  final SettingsService service;

  @override
  Future<void> doAction(final DateLocaleConfig? event, final void lastData) =>
      event == null
      ? service.removeCurrentDateConfig()
      : service.saveCurrentDateConfig(event);
}
