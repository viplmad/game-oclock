import 'package:flutter/material.dart';

import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/localisations/localisations.dart';


class PurchaseTheme {

  static const Color primaryColour = Colors.lightBlue;
  static const Color accentColour = Colors.lightBlueAccent;

  static ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData purchaseTheme = contextTheme.copyWith(
      primaryColor: primaryColour,
      accentColor: accentColour,
    );

    return purchaseTheme;

  }

  static BarData barData(BuildContext context) {

    return BarData(
      title: GameCollectionLocalisations.of(context).purchasesString,
      icon: Icons.local_grocery_store,
      color: primaryColour,
    );

  }

  static List<String> views(BuildContext context) {

    return <String>[
      GameCollectionLocalisations.of(context).mainViewString,
      GameCollectionLocalisations.of(context).lastCreatedViewString,
      GameCollectionLocalisations.of(context).pendingViewString,
      GameCollectionLocalisations.of(context).lastPurchasedViewString,
      GameCollectionLocalisations.of(context).yearInReviewViewString,
    ];

  }

}