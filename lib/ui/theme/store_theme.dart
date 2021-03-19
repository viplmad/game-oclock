import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';


class StoreTheme {
  static const Color primaryColour = Colors.blueGrey;
  static const Color accentColour = Colors.grey;

  static ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData storeTheme = contextTheme.copyWith(
      primaryColor: primaryColour,
      accentColor: accentColour,
      colorScheme: contextTheme.colorScheme.copyWith(
        primary: primaryColour,
      ),
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

  static Widget itemCard(BuildContext context, Store item, void Function()? Function(BuildContext, Store) onTap, [void Function()? Function(BuildContext, Store)? onLongPress]) {

    return ItemCard(
      title: itemTitle(item),
      hasImage: item.hasImage,
      imageURL: item.image.url,
      onTap: onTap(context, item),
      onLongPress: onLongPress != null? onLongPress(context, item) : null,
    );

  }

  static Widget itemGrid(BuildContext context, Store item, void Function()? Function(BuildContext, Store) onTap) {

    return ItemGrid(
      title: itemTitle(item),
      hasImage: item.hasImage,
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );

  }

  static String itemTitle(Store item) {

    return item.name;

  }
}