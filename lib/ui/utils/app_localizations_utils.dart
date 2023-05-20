import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:logic/utils/datetime_extension.dart';
import 'package:logic/utils/duration_extension.dart';

class AppLocalizationsUtils {
  const AppLocalizationsUtils();

  static String formatWeekday(DateTime date) {
    return DateFormat.EEEE().format(date);
  }

  static String formatDay(DateTime date) {
    return DateFormat.d().format(date);
  }

  static String formatMonth(DateTime date) {
    return DateFormat.MMMM().format(date);
  }

  static List<String> daysOfWeekAbbr() {
    final DateTime monday = DateTime.now().atMondayOfWeek();
    return List<String>.generate(
      DateTime.daysPerWeek,
      (int index) {
        return DateFormat.E().format(monday.addDays(index));
      },
    );
  }

  static List<String> monthsAbbr() {
    final DateTime firstDay = DateTime.now().atFirstDayOfYear();
    return List<String>.generate(
      DateTime.monthsPerYear,
      (int index) {
        return DateFormat.MMM().format(firstDay.addMonths(index));
      },
    );
  }

  static String formatDuration(BuildContext context, Duration duration) {
    if (duration.isZero()) {
      return '0';
    }

    final int hours = duration.inHours;
    final int minutes = duration.extractNormalisedMinutes();

    final String hoursAbbr = AppLocalizations.of(context)!.hoursAbbr(hours);
    final String hourString = '$hours $hoursAbbr';

    final String minuteAbbr = AppLocalizations.of(context)!.minutesAbbr;
    final String minuteString = '$minutes $minuteAbbr';

    if (hours == 0) {
      return minuteString;
    } else if (minutes == 0) {
      return hourString;
    }

    return '$hourString $minuteString';
  }
}
