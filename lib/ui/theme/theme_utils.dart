import 'package:flutter/material.dart';

class ThemeUtils {
  ThemeUtils._();

  static ThemeData themeByColours(BuildContext context, Color primary, Color secondary) {
    final ThemeData contextTheme = Theme.of(context);
    final ThemeData gameTheme = contextTheme.copyWith(
      primaryColor: primary,
      toggleableActiveColor: secondary,
      colorScheme: contextTheme.colorScheme.copyWith(
        primary: primary,
        secondary: secondary,
      ),
    );

    return gameTheme;
  }
}