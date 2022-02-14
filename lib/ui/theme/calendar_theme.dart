import 'package:flutter/material.dart';

import 'game_theme.dart';

class CalendarTheme {
  CalendarTheme._();

  static Color? todayColour = Colors.yellow[800];
  static Color weekendColour = Colors.grey.withAlpha(50);
  static const Color selectedColour = GameTheme.primaryColour;
  static const Color finishedColour = GameTheme.playedStatusColour;
  static const Color playedColour = GameTheme.playingStatusColour;
  static const BoxShape shape = BoxShape.circle;
}
