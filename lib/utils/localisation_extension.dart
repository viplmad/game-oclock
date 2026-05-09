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

  String formatTz(final DateTime date) {
    final offset = date.timeZoneOffset;
    final hours = offset.inHours > 0
        ? offset.inHours
        : 1; // For fixing divide by 0

    if (!offset.isNegative) {
      return '+${offset.inHours.toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}';
    } else {
      return '-${(-offset.inHours).toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}';
    }
  }

  String toISOString(final DateTime date) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(date) + formatTz(date);
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
}
