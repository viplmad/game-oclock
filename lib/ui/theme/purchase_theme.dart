import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show Purchase;

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';
import '../common/bar_data.dart';
import 'theme_utils.dart';

class PurchaseTheme {
  PurchaseTheme._();

  static const Color primaryColour = Colors.lightBlue;
  static const Color secondaryColour = Colors.lightBlueAccent;

  static ThemeData themeData(BuildContext context) {
    return ThemeUtils.themeByColours(context, primaryColour, secondaryColour);
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

  static Widget itemCard(
    BuildContext context,
    Purchase item,
    void Function()? Function(BuildContext, Purchase) onTap,
  ) {
    return ItemCard(
      title: itemTitle(item),
      subtitle: _itemSubtitle(context, item),
      hasImage: Purchase.hasImage,
      color: primaryColour,
      onTap: onTap(context, item),
    );
  }

  static String itemTitle(Purchase item) {
    return item.description;
  }

  static String _itemSubtitle(BuildContext context, Purchase item) {
    return '${GameCollectionLocalisations.of(context).formatEuro(item.price)} · ${GameCollectionLocalisations.of(context).formatPercentage(item.discount * 100)}';
  }
}
