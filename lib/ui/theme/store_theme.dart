import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show Store;

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';
import '../common/bar_data.dart';
import 'theme_utils.dart';

class StoreTheme {
  StoreTheme._();

  static const Color primaryColour = Colors.blueGrey;
  static const Color secondaryColour = Colors.grey;

  static ThemeData themeData(BuildContext context) {
    return ThemeUtils.themeByColours(context, primaryColour, secondaryColour);
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

  static Widget itemCard(
    BuildContext context,
    Store item,
    void Function()? Function(BuildContext, Store) onTap,
  ) {
    return ItemCard(
      title: itemTitle(item),
      hasImage: Store.hasImage,
      color: primaryColour,
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );
  }

  static Widget itemGrid(
    BuildContext context,
    Store item,
    void Function()? Function(BuildContext, Store) onTap,
  ) {
    return ItemGrid(
      title: itemTitle(item),
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );
  }

  static String itemTitle(Store item) {
    return item.name;
  }
}
