import 'package:flutter/material.dart';

import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/localisations/localisations.dart';


class DLCTheme {

  static const Color primaryColour = Colors.deepPurple;
  static const Color accentColour = Colors.deepPurpleAccent;

  static ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData dlcTheme = contextTheme.copyWith(
      primaryColor: primaryColour,
      accentColor: accentColour,
    );

    return dlcTheme;

  }

  static BarData barData(BuildContext context) {

    return BarData(
      title: GameCollectionLocalisations.of(context).dlcsString,
      icon: Icons.widgets,
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