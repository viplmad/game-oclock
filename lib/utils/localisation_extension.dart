import 'package:flutter/material.dart';
import 'package:game_oclock/l10n/app_localizations.dart';
import 'package:game_oclock/utils/duration_extension.dart';
import 'package:game_oclock_client/api.dart';
import 'package:intl/intl.dart';

extension LocalizeContext on BuildContext {
  AppLocalizations localize() {
    return AppLocalizations.of(this)!;
  }
}

extension AppLocalizationsExtension on AppLocalizations {
  String formatHour(final int hour) {
    return hour.toString().padLeft(2, '0');
  }

  String formatPercentage(final double value) {
    return NumberFormat.decimalPercentPattern(decimalDigits: 0).format(value);
  }

  String formatDay(final DateTime date) {
    return DateFormat.d().format(date);
  }

  String formatDayMonth(final DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  String formatLocale(final Locale locale) {
    if (locale == const Locale('en')) {
      return englishLabel;
    }

    return locale.toLanguageTag();
  }

  String formatDuration(final Duration duration) {
    if (duration.isZero()) {
      return '0';
    }

    final int hours = duration.inHours;
    final int minutes = duration.extractNormalisedMinutes();

    final String hoursString = hoursAbbr(hours);

    final String minutesString = minutesAbbr(minutes);

    if (hours == 0) {
      return minutesString;
    } else if (minutes == 0) {
      return hoursString;
    }

    return '$hoursString $minutesString';
  }

  String monthAbbr(final int month) {
    return DateFormat.MMM().format(DateTime(2000, month, 1));
  }

  String weekdayAbbr(final int weekday) {
    // 2024 starts on monday == isoweekday 1
    return DateFormat.E().format(DateTime(2024, DateTime.january, weekday));
  }

  String genreLabel(final String slug) {
    return switch (slug) {
      'platform' => genrePlatformLabel,
      'puzzle' => genrePuzzleLabel,
      'adventure' => genreAdventureLabel,
      'indie' => genreIndieLabel,
      'strategy' => genreStrategyLabel,
      'role-playing-rpg' => genreRolePlayingRPGLabel,
      'shooter' => genreShooterLabel,
      _ => slug,
    };
  }

  String filterValueLabel(final FilterDTO filter, final String field) {
    return switch (filter.operator_) {
      OperatorType.eq => equalChipLabel(
        field,
        _buildFilterValueLabel(filter.value!),
      ),
      OperatorType.notEq => notEqualChipLabel(
        field,
        _buildFilterValueLabel(filter.value!),
      ),
      OperatorType.gt => greaterThanChipLabel(
        field,
        _buildFilterValueLabel(filter.value!),
      ),
      OperatorType.gte => greaterThanEqualChipLabel(
        field,
        _buildFilterValueLabel(filter.value!),
      ),
      OperatorType.lt => lessThanChipLabel(
        field,
        _buildFilterValueLabel(filter.value!),
      ),
      OperatorType.lte => lessThanEqualChipLabel(
        field,
        _buildFilterValueLabel(filter.value!),
      ),
      OperatorType.in_ => inChipLabel(
        field,
        _buildFilterValuesLabel(filter.value!),
      ),
      OperatorType.notIn => notInChipLabel(
        field,
        _buildFilterValuesLabel(filter.value!),
      ),
      OperatorType.startsWith => startsWithChipLabel(
        field,
        _buildFilterValueLabel(filter.value!),
      ),
      OperatorType.notStartsWith => notStartsWithChipLabel(
        field,
        _buildFilterValueLabel(filter.value!),
      ),
      OperatorType.endsWith => endsWithChipLabel(
        field,
        _buildFilterValueLabel(filter.value!),
      ),
      OperatorType.notEndsWith => notEndsWithChipLabel(
        field,
        _buildFilterValueLabel(filter.value!),
      ),
      OperatorType.contains => containsChipLabel(
        field,
        _buildFilterValueLabel(filter.value!),
      ),
      OperatorType.notContains => notContainsChipLabel(
        field,
        _buildFilterValueLabel(filter.value!),
      ),
      OperatorType.null_ => nullChipLabel(field),
      OperatorType.notNull => notNullChipLabel(field),
      _ => '?',
    };
  }

  String _buildFilterValueLabel(final SearchValue value) {
    return value.value == null ? nullLabel : quote(value.value!);
  }

  String _buildFilterValuesLabel(final SearchValue value) {
    return (value.values ?? []).map((final val) => quote(val)).join(', ');
  }
}
