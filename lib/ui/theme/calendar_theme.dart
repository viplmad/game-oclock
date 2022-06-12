import 'package:flutter/material.dart';

import 'game_theme.dart';

class CalendarTheme {
  CalendarTheme._();

  static const Color todayColour = GameTheme.primaryColour;
  static const Color selectedColour = GameTheme.primaryColour;
  static const Color finishedColour = GameTheme.playedStatusColour;
  static const Color playedColour = GameTheme.playingStatusColour;
  static const BoxShape shape = BoxShape.circle;
}
