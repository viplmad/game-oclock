import 'package:flutter/material.dart';
import 'package:game_oclock/l10n/app_localizations.dart';

extension LocalizeContext on BuildContext {
  AppLocalizations localize() {
    return AppLocalizations.of(this)!;
  }
}
