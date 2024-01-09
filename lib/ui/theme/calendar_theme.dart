import 'package:flutter/material.dart';

import 'game_theme.dart';

class CalendarTheme {
  CalendarTheme._();

  static const Color todayColour = GameTheme.primaryColour;
  static const Color selectedColour = GameTheme.primaryColour;
  static const Color finishedColour = GameTheme.playedStatusColour;
  static const Color playedColour = GameTheme.playingStatusColour;
  static const BoxShape shape = BoxShape.circle;

  static const IconData firstIcon = Icons.first_page;
  static const IconData previousIcon = Icons.navigate_before;
  static const IconData nextIcon = Icons.navigate_next;
  static const IconData lastIcon = Icons.last_page;
  static const IconData changeStyleIcon = Icons.insert_chart_outlined_outlined;
}
