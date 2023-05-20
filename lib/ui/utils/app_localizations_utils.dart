import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:logic/utils/datetime_extension.dart';
import 'package:logic/utils/duration_extension.dart';

class AppLocalizationsUtils {
  const AppLocalizationsUtils();

  static List<String>? _daysOfWeekAbbr;

  static List<String> daysOfWeekAbbr() {
    if (_daysOfWeekAbbr != null) {
      return _daysOfWeekAbbr!;
    }

    final DateTime monday = DateTime.now().atMondayOfWeek();
    _daysOfWeekAbbr = List<String>.generate(
      DateTime.daysPerWeek,
      (int index) {
        return DateFormat.E().format(monday.addDays(index));
      },
    );
    return _daysOfWeekAbbr!;
  }

  static List<String>? _monthsAbbr;

  static List<String> monthsAbbr() {
    if (_monthsAbbr != null) {
      return _monthsAbbr!;
    }

    final DateTime firstDay = DateTime.now().atFirstDayOfYear();
    _monthsAbbr = List<String>.generate(
      DateTime.monthsPerYear,
      (int index) {
        return DateFormat.MMM().format(firstDay.addMonths(index));
      },
    );
    return _monthsAbbr!;
  }

  static String formatWeekday(DateTime date) {
    return DateFormat.EEEE().format(date);
  }

  static String formatDay(DateTime date) {
    return DateFormat.d().format(date);
  }

  static String formatMonth(DateTime date) {
    return DateFormat.MMMM().format(date);
  }

  static String formatDate(DateTime date) {
    return DateFormat('d/M/y').format(date); // Fix date format because I can ;)
  }

  static String formatDuration(BuildContext context, Duration duration) {
    if (duration.isZero()) {
      return '0';
    }

    final int hours = duration.inHours;
    final int minutes = duration.extractNormalisedMinutes();

    final String hoursString = AppLocalizations.of(context)!.hoursAbbr(hours);

    final String minutesString =
        AppLocalizations.of(context)!.minutesAbbr(minutes);

    if (hours == 0) {
      return minutesString;
    } else if (minutes == 0) {
      return hoursString;
    }

    return '$hoursString $minutesString';
  }
}
