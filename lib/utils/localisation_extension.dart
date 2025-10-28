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
  String day(final DateTime date) {
    return DateFormat.d().format(date);
  }

  String duration(final Duration duration) {
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
