import 'package:flutter/material.dart';
import 'package:game_oclock/l10n/app_localizations.dart';
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

  String monthYear(final DateTime date) {
    return DateFormat.yMMMM().format(date);
  }
}
