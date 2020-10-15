import 'package:flutter/material.dart';

import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/localisations/localisations.dart';


class StoreTheme {

  static const Color primaryColour = Colors.blueGrey;
  static const Color accentColour = Colors.grey;

  static ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData storeTheme = contextTheme.copyWith(
      primaryColor: primaryColour,
      accentColor: accentColour,
    );

    return storeTheme;

  }

  static BarData barData(BuildContext context) {

    return BarData(
      title: GameCollectionLocalisations.of(context).storesString,
      icon: Icons.store,
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