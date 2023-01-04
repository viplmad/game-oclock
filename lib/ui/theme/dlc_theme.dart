import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart' show DLCDTO, DLCAvailableDTO;

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';
import '../common/bar_data.dart';
import 'theme_utils.dart';

class DLCTheme {
  DLCTheme._();

  static const bool hasImage = true;

  static const Color primaryColour = Colors.deepPurple;
  static const Color secondaryColour = Colors.deepPurpleAccent;

  static ThemeData themeData(BuildContext context) {
    return ThemeUtils.themeByColours(context, primaryColour, secondaryColour);
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

  static Widget itemCard(
    BuildContext context,
    DLCDTO item,
    void Function()? Function(BuildContext, DLCDTO) onTap,
  ) {
    return ItemCard(
      title: itemTitle(item),
      hasImage: DLCTheme.hasImage,
      imageURL: item.coverUrl,
      onTap: onTap(context, item),
    );
  }

  static Widget itemAvailableCard(
    BuildContext context,
    DLCAvailableDTO item,
    void Function()? Function(BuildContext, DLCAvailableDTO) onTap,
  ) {
    return ItemCard(
      title: itemTitle(item),
      subtitle: GameCollectionLocalisations.of(context)
          .formatDate(item.availableDate),
      hasImage: DLCTheme.hasImage,
      imageURL: item.coverUrl,
      onTap: onTap(context, item),
    );
  }

  static Widget itemGrid(
    BuildContext context,
    DLCDTO item,
    void Function()? Function(BuildContext, DLCDTO) onTap,
  ) {
    return ItemGrid(
      title: itemTitle(item),
      imageURL: item.coverUrl,
      onTap: onTap(context, item),
    );
  }

  static String itemTitle(DLCDTO item) {
    return item.name;
  }
}
