import 'package:flutter/material.dart';

bool isThemeDark(BuildContext context) {
  return isDark(Theme.of(context).brightness);
}

bool isDark(Brightness brightness) {
  return brightness == Brightness.dark;
}
