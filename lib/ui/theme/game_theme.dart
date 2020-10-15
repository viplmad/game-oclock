import 'package:flutter/material.dart';

import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/localisations/localisations.dart';


class GameTheme {

  static const Color primaryColour = Colors.red;
  static const Color accentColour = Colors.redAccent;

  static const List<Color> statusColours = <Color>[
    Colors.grey,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
  ];

  static ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData gameTheme = contextTheme.copyWith(
      primaryColor: primaryColour,
      accentColor: accentColour,
    );

    return gameTheme;

  }

  static BarData barData(BuildContext context) {

    return BarData(
      title: GameCollectionLocalisations.of(context).gamesString,
      icon: Icons.videogame_asset,
      color: primaryColour,
    );

  }

  static BarData allTabData(BuildContext context) {

    return BarData(
      title: GameCollectionLocalisations.of(context).allString,
      icon: Icons.done_all,
    );

  }

  static BarData ownedTabData(BuildContext context) {

    return BarData(
      title: GameCollectionLocalisations.of(context).ownedString,
      icon: Icons.videogame_asset,
    );

  }

  static BarData romsTabData(BuildContext context) {

    return BarData(
      title: GameCollectionLocalisations.of(context).romsString,
      icon: Icons.file_download,
    );

  }

  static List<String> views(BuildContext context) {

    return <String>[
      GameCollectionLocalisations.of(context).mainViewString,
      GameCollectionLocalisations.of(context).lastCreatedViewString,
      GameCollectionLocalisations.of(context).playingViewString,
      GameCollectionLocalisations.of(context).nextUpViewString,
      GameCollectionLocalisations.of(context).lastFinishedViewString,
      GameCollectionLocalisations.of(context).yearInReviewViewString,
    ];

  }

}