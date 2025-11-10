import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show DateLocaleConfig;

import 'shared_preferences_repository.dart';

class SettingsService {
  const SettingsService(this.repository);

  final SharedPreferencesRepository repository;

  Future<ThemeMode?> getCurrentTheme() {
    return repository.get(
      _buildCurrentThemeKey(),
      (final value) => parseThemeMode(value),
    );
  }

  Future<void> saveCurrentTheme(final ThemeMode theme) {
    return repository.set(
      _buildCurrentThemeKey(),
      theme,
      (final value) => themeModeToString(value),
    );
  }

  Future<void> removeCurrentTheme() {
    return repository.remove(_buildCurrentThemeKey());
  }

  Future<Locale?> getCurrentLocale() {
    return repository.get(
      _buildCurrentLocaleKey(),
      (final value) => parseLocale(value),
    );
  }

  Future<void> saveCurrentLocale(final Locale locale) {
    return repository.set(
      _buildCurrentLocaleKey(),
      locale,
      (final value) => localeToString(value),
    );
  }

  Future<void> removeCurrentLocale() {
    return repository.remove(_buildCurrentLocaleKey());
  }

  Future<DateLocaleConfig?> getCurrentDateConfig() {
    return repository.get(
      _buildCurrentDateConfigKey(),
      (final value) => DateLocaleConfig.fromJson(json.decode(value)),
    );
  }

  Future<void> saveCurrentDateConfig(final DateLocaleConfig dateConfig) {
    return repository.set(
      _buildCurrentDateConfigKey(),
      dateConfig,
      (final value) => json.encode(value.toJson()),
    );
  }

  Future<void> removeCurrentDateConfig() {
    return repository.remove(_buildCurrentDateConfigKey());
  }

  String _buildKey() => 'settings';
  String _buildCurrentThemeKey() => '${_buildKey()}#theme#current';
  String _buildCurrentLocaleKey() => '${_buildKey()}#locale#current';
  String _buildCurrentDateConfigKey() => '${_buildKey()}#date-config#current';
}

ThemeMode parseThemeMode(final String value) =>
    ThemeMode.values.firstWhere((final element) => element.name == value);

String themeModeToString(final ThemeMode value) => value.name;

Locale parseLocale(final String value) => Locale(value);

String localeToString(final Locale value) => value.languageCode;
