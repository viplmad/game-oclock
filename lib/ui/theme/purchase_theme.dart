import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';
import '../common/bar_data.dart';


class PurchaseTheme {
  static const Color primaryColour = Colors.lightBlue;
  static const Color accentColour = Colors.lightBlueAccent;

  static ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData purchaseTheme = contextTheme.copyWith(
      primaryColor: primaryColour,
      accentColor: accentColour,
      colorScheme: contextTheme.colorScheme.copyWith(
        primary: primaryColour,
      ),
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

  static Widget itemCard(BuildContext context, Purchase item, void Function()? Function(BuildContext, Purchase) onTap) {

    return ItemCard(
      title: itemTitle(item),
      subtitle: _itemSubtitle(context, item),
      hasImage: item.hasImage,
      onTap: onTap(context, item),
    );

  }

  static String itemTitle(Purchase item) {

    return item.description;

  }

  static String _itemSubtitle(BuildContext context, Purchase item) {

    return GameCollectionLocalisations.of(context).euroString(item.price) + ' · ' + GameCollectionLocalisations.of(context).percentageString(item.discount * 100);

  }
}