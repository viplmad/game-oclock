import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';


class GameTagTheme {
  static const Color primaryColour = Colors.black87;
  static const Color accentColour = Colors.black12;

  static ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData platformTheme = contextTheme.copyWith(
      primaryColor: primaryColour,
      accentColor: accentColour,
      colorScheme: contextTheme.colorScheme.copyWith(
        primary: primaryColour,
      ),
    );

    return platformTheme;

  }

  static List<String> views(BuildContext context) {

    return <String>[
      GameCollectionLocalisations.of(context).mainViewString,
      GameCollectionLocalisations.of(context).lastCreatedViewString,
    ];

  }

  static Widget itemCard(BuildContext context, GameTag item, void Function()? Function(BuildContext, GameTag) onTap) {

    return ItemCard(
      title: itemTitle(item),
      hasImage: item.hasImage,
      onTap: onTap(context, item),
    );

  }

  static Widget itemTile(BuildContext context, GameTag item, void Function()? Function(BuildContext, GameTag) onTap) {

    return ListTile(
      title: Text(itemTitle(item)),
      onTap: onTap(context, item),
    );

  }

  static String itemTitle(GameTag item) {

    return item.name;

  }
}