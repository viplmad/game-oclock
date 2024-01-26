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
        background: _defaultBackgroundColor(brightness),
      ),
      cardTheme: CardTheme(
        surfaceTintColor: _defaultSurfaceTintColor(brightness),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: _defaultBackgroundColor(brightness),
        surfaceTintColor: _defaultSurfaceTintColor(brightness),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          surfaceTintColor: MaterialStatePropertyAll<Color?>(
            _defaultSurfaceTintColor(brightness),
          ),
        ),
      ),
    );
  }

  static Color defaultThemeSurfaceTintColor(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return _defaultSurfaceTintColor(brightness);
  }

  static Color defaultBackgroundColor(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return _defaultBackgroundColor(brightness);
  }

  static Color defaultThemeTextColor(BuildContext context) {
    return ThemeUtils.isThemeDark(context) ? Colors.white : Colors.black87;
  }

  static Color defaultThemeTextColorReverse(BuildContext context) {
    return ThemeUtils.isThemeDark(context) ? Colors.black87 : Colors.white;
  }

  static Color _defaultSurfaceTintColor(Brightness brightness) {
    return ThemeUtils.isDark(brightness) ? Colors.grey[800]! : Colors.white;
  }

  static Color _defaultBackgroundColor(Brightness brightness) {
    return ThemeUtils.isDark(brightness)
        ? Colors.grey[700]!
        : Colors.grey[300]!;
  }
}
