import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const MaterialColor _primarySwatch = Colors.red;
  static const Color _secondaryColour = Colors.redAccent;

  static ThemeData themeData(Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      primarySwatch: _primarySwatch,
      indicatorColor: Colors.white,
      toggleableActiveColor: _secondaryColour,
      colorScheme: ColorScheme.fromSwatch(
        brightness: brightness,
        primarySwatch: _primarySwatch,
      ).copyWith(
        secondary: _secondaryColour,
      ),
    );
  }
}
