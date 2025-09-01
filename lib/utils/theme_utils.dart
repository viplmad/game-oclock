import 'package:flutter/material.dart';

bool isThemeDark(final BuildContext context) {
  return isDark(Theme.of(context).brightness);
}

bool isDark(final Brightness brightness) {
  return brightness == Brightness.dark;
}
