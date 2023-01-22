import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart' show DLCDTO, DLCAvailableDTO;

import 'package:backend/model/model.dart' show DLCView;

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
    return DLCView.values.map<String>((DLCView view) {
      switch (view) {
        case DLCView.main:
          return GameCollectionLocalisations.of(context).mainViewString;
        case DLCView.lastAdded:
          return GameCollectionLocalisations.of(context).lastAddedViewString;
        case DLCView.lastUpdated:
          return GameCollectionLocalisations.of(context).lastUpdatedViewString;
        case DLCView.lastFinished:
          return GameCollectionLocalisations.of(context).lastFinishedViewString;
      }
    }).toList(growable: false);
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
