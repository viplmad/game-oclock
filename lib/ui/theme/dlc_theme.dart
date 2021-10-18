import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';
import '../common/bar_data.dart';


class DLCTheme {
  DLCTheme._();

  static const Color primaryColour = Colors.deepPurple;
  static const Color secondaryColour = Colors.deepPurpleAccent;

  static ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData dlcTheme = contextTheme.copyWith(
      primaryColor: primaryColour,
      colorScheme: contextTheme.colorScheme.copyWith(
        primary: primaryColour,
        secondary: secondaryColour,
      ),
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

  static Widget itemCard(BuildContext context, DLC item, void Function()? Function(BuildContext, DLC) onTap) {

    return ItemCard(
      title: itemTitle(item),
      hasImage: item.hasImage,
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );

  }

  static Widget itemGrid(BuildContext context, DLC item, void Function()? Function(BuildContext, DLC) onTap) {

    return ItemGrid(
      title: itemTitle(item),
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );

  }

  static String itemTitle(DLC item) {

    return item.name;

  }
}