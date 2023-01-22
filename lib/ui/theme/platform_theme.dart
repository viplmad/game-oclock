import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart'
    show PlatformDTO, PlatformAvailableDTO;

import 'package:backend/model/model.dart' show PlatformView;

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';
import '../common/bar_data.dart';
import 'theme_utils.dart';

class PlatformTheme {
  PlatformTheme._();

  static const bool hasImage = true;

  static const Color primaryColour = Colors.black87;
  static const Color secondaryColour = Colors.black12;

  static const Color physicalTypeColour = Colors.blueAccent;
  static const Color digitalTypeColour = Colors.deepPurpleAccent;

  static const List<Color> typeColours = <Color>[
    physicalTypeColour,
    digitalTypeColour,
  ];

  static ThemeData themeData(BuildContext context) {
    return ThemeUtils.themeByColours(context, primaryColour, secondaryColour);
  }

  static BarData barData(BuildContext context) {
    return BarData(
      title: GameCollectionLocalisations.of(context).platformsString,
      icon: Icons.phonelink,
      color: primaryColour,
    );
  }

  static List<String> views(BuildContext context) {
    return PlatformView.values.map<String>((PlatformView view) {
      switch (view) {
        case PlatformView.main:
          return GameCollectionLocalisations.of(context).mainViewString;
        case PlatformView.lastAdded:
          return GameCollectionLocalisations.of(context).lastAddedViewString;
        case PlatformView.lastUpdated:
          return GameCollectionLocalisations.of(context).lastUpdatedViewString;
      }
    }).toList(growable: false);
  }

  static Widget itemCard(
    BuildContext context,
    PlatformDTO item,
    void Function()? Function(BuildContext, PlatformDTO) onTap,
  ) {
    return ItemCard(
      title: itemTitle(item),
      hasImage: PlatformTheme.hasImage,
      imageURL: item.iconUrl,
      onTap: onTap(context, item),
    );
  }

  static Widget itemAvailableCard(
    BuildContext context,
    PlatformAvailableDTO item,
    void Function()? Function(BuildContext, PlatformAvailableDTO) onTap,
  ) {
    return ItemCard(
      title: itemTitle(item),
      subtitle: GameCollectionLocalisations.of(context)
          .formatDate(item.availableDate),
      hasImage: PlatformTheme.hasImage,
      imageURL: item.iconUrl,
      onTap: onTap(context, item),
    );
  }

  static Widget itemGrid(
    BuildContext context,
    PlatformDTO item,
    void Function()? Function(BuildContext, PlatformDTO) onTap,
  ) {
    return ItemGrid(
      title: itemTitle(item),
      imageURL: item.iconUrl,
      onTap: onTap(context, item),
    );
  }

  static String itemTitle(PlatformDTO item) {
    return item.name;
  }
}
