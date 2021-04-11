import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';


class PlatformTheme {
  static const Color primaryColour = Colors.black87;
  static const Color accentColour = Colors.black12;

  static const Color physicalTypeColour = Colors.blueAccent;
  static const Color digitalTypeColour = Colors.deepPurpleAccent;

  static const List<Color> typeColours = <Color>[
    physicalTypeColour,
    digitalTypeColour,
  ];

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

  static BarData barData(BuildContext context) {

    return BarData(
      title: GameCollectionLocalisations.of(context).platformsString,
      icon: Icons.phonelink,
      color: primaryColour,
    );

  }

  static List<String> views(BuildContext context) {

    return <String>[
      GameCollectionLocalisations.of(context).mainViewString,
      GameCollectionLocalisations.of(context).lastCreatedViewString,
    ];

  }

  static Widget itemCard(BuildContext context, Platform item, void Function()? Function(BuildContext, Platform) onTap, [void Function()? Function(BuildContext, Platform)? onLongPress]) {

    return ItemCard(
      title: itemTitle(item),
      hasImage: item.hasImage,
      imageURL: item.image.url,
      onTap: onTap(context, item),
      onLongPress: onLongPress != null? onLongPress(context, item) : null,
    );

  }

  static Widget itemGrid(BuildContext context, Platform item, void Function()? Function(BuildContext, Platform) onTap) {

    return ItemGrid(
      title: itemTitle(item),
      hasImage: item.hasImage,
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );

  }

  static String itemTitle(Platform item) {

    return item.name;

  }
}