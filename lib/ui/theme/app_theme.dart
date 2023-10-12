import 'package:flutter/material.dart';

import 'package:game_oclock/ui/utils/theme_utils.dart';

class AppTheme {
  AppTheme._();

  static const MaterialColor _primarySwatch = Colors.red;
  static const Color _secondaryColour = Colors.redAccent;

  static ThemeData themeData(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primarySwatch: _primarySwatch,
      indicatorColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch(
        brightness: brightness,
        primarySwatch: _primarySwatch,
      ).copyWith(
        secondary: _secondaryColour,
      ),
      cardTheme: CardTheme(
        surfaceTintColor: defaultSurfaceTintColor(brightness),
      ),
    );
  }

  static Color defaultThemeSurfaceTintColor(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return defaultSurfaceTintColor(brightness);
  }

  static Color defaultSurfaceTintColor(Brightness brightness) {
    return ThemeUtils.isDark(brightness) ? Colors.grey[800]! : Colors.white;
  }
}
