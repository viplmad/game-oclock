import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show DateLocaleConfig;
import 'package:game_oclock/services/services.dart' show SettingsService;

import '../action.dart' show ConsumerActionBloc, ProducerActionBloc;

class ThemeModeGetBloc extends ProducerActionBloc<ThemeMode> {
  ThemeModeGetBloc({required this.service});

  final SettingsService service;

  @override
  Future<ThemeMode> doAction(void event, ThemeMode? lastData) =>
      service.getCurrentTheme();
}

class ThemeModeSaveBloc extends ConsumerActionBloc<ThemeMode?> {
  ThemeModeSaveBloc({required this.service});

  final SettingsService service;

  @override
  Future<void> doAction(ThemeMode? event, void lastData) => event == null
      ? service.removeCurrentTheme()
      : service.saveCurrentTheme(event);
}

class LocaleGetBloc extends ProducerActionBloc<Locale> {
  LocaleGetBloc({required this.service});

  final SettingsService service;

  @override
  Future<Locale> doAction(void event, Locale? lastData) =>
      service.getCurrentLocale();
}

class LocaleSaveBloc extends ConsumerActionBloc<Locale?> {
  LocaleSaveBloc({required this.service});

  final SettingsService service;

  @override
  Future<void> doAction(Locale? event, void lastData) => event == null
      ? service.removeCurrentLocale()
      : service.saveCurrentLocale(event);
}

class DateLocaleConfigGetBloc extends ProducerActionBloc<DateLocaleConfig> {
  DateLocaleConfigGetBloc({required this.service});

  final SettingsService service;

  @override
  Future<DateLocaleConfig> doAction(void event, DateLocaleConfig? lastData) =>
      service.getCurrentDateConfig();
}

class DateLocaleConfigSaveBloc extends ConsumerActionBloc<DateLocaleConfig?> {
  DateLocaleConfigSaveBloc({required this.service});

  final SettingsService service;

  @override
  Future<void> doAction(DateLocaleConfig? event, void lastData) => event == null
      ? service.removeCurrentDateConfig()
      : service.saveCurrentDateConfig(event);
}
