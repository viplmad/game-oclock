import 'package:flutter/material.dart';
import 'package:game_oclock/l10n/app_localizations.dart';
import 'package:game_oclock/utils/duration_extension.dart';
import 'package:intl/intl.dart';

extension LocalizeContext on BuildContext {
  AppLocalizations localize() {
    return AppLocalizations.of(this)!;
  }
}

extension AppLocalizationsExtension on AppLocalizations {
  String formatDay(final DateTime date) {
    return DateFormat.d().format(date);
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
}
