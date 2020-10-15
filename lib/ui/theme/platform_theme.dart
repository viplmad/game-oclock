import 'package:flutter/material.dart';

import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/localisations/localisations.dart';


class PlatformTheme {

  static const Color primaryColour = Colors.black87;
  static const Color accentColour = Colors.black12;

  static const List<Color> typeColours = [
    Colors.blueAccent,
    Colors.deepPurpleAccent,
  ];

  static ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData platformTheme = contextTheme.copyWith(
      primaryColor: primaryColour,
      accentColor: accentColour,
    );

    return platformTheme;

  }

  static BarData barData(BuildContext context) {

    return BarData(
      title: GameCollectionLocalisations.of(context).platformsString,
      icon: Icons.phonelink,
      color: primaryColour,
    );

  }

  static List<String> views(BuildContext context) {

    return <String>[
      GameCollectionLocalisations.of(context).mainViewString,
      GameCollectionLocalisations.of(context).lastCreatedViewString,
    ];

  }

}