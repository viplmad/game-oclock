import 'package:flutter/material.dart';

import 'package:game_oclock/ui/utils/theme_utils.dart';

class AppTheme {
  AppTheme._();

  static const MaterialColor _primarySwatch = Colors.red;
  static const Color _secondaryColour = Colors.redAccent;

  static const IconData linkIcon = Icons.link;
  static const IconData unlinkIcon = Icons.link_off;
  static const IconData acceptIcon = Icons.send;
  static const IconData copyIcon = Icons.content_copy;
  static const IconData showIcon = Icons.visibility_off;
  static const IconData hideIcon = Icons.visibility;
  static const IconData goIcon = Icons.arrow_forward;
  static const IconData addIcon = Icons.add;
  static const IconData closeIcon = Icons.close;
  static const IconData editIcon = Icons.edit;
  static const IconData deleteIcon = Icons.delete;
  static const IconData searchIcon = Icons.search;
  static const IconData clearIcon = Icons.clear;
  static const IconData changeViewIcon = Icons.view_carousel_outlined;
  static const IconData changeStyleIcon = Icons.grid_on;
  static const IconData changeRangeIcon = Icons.date_range_outlined;
  static const IconData calendarIcon = Icons.calendar_month_outlined;
  static const IconData uploadIcon = Icons.upload_file;
  static const IconData replaceUploadIcon = Icons.restore_page_outlined;

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
