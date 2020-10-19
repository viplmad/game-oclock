import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';


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

  static Widget itemCard(BuildContext context, DLC item, void Function() Function(BuildContext, DLC) onTap) {

    return ItemCard(
      title: itemTitle(item),
      hasImage: item.hasImage,
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );

  }

  static Widget itemGrid(BuildContext context, DLC item, void Function() Function(BuildContext, DLC) onTap) {

    return ItemGrid(
      title: itemTitle(item),
      hasImage: item.hasImage,
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );

  }

  static String itemTitle(DLC item) {

    return item.name;

  }
}