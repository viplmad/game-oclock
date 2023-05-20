import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_collection_client/api.dart'
    show DLCDTO, DLCWithFinishDTO, DLCAvailableDTO;

import 'package:logic/model/model.dart' show DLCView;

import 'package:game_collection/ui/common/item_view.dart';
import 'package:game_collection/ui/common/bar_data.dart';
import 'package:game_collection/ui/utils/theme_utils.dart';

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
      title: AppLocalizations.of(context)!.dlcsString,
      icon: Icons.widgets,
      color: primaryColour,
    );
  }

  static List<String> views(BuildContext context) {
    return DLCView.values
        .map<String>((DLCView view) => _viewString(context, view))
        .toList(growable: false);
  }

  static String _viewString(BuildContext context, DLCView view) {
    switch (view) {
      case DLCView.main:
        return AppLocalizations.of(context)!.mainViewString;
      case DLCView.lastAdded:
        return AppLocalizations.of(context)!.lastAddedViewString;
      case DLCView.lastUpdated:
        return AppLocalizations.of(context)!.lastUpdatedViewString;
      case DLCView.lastFinished:
        return AppLocalizations.of(context)!.lastFinishedViewString;
    }
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

  static Widget itemCardFinish(
    BuildContext context,
    DLCWithFinishDTO item,
    void Function()? Function(BuildContext, DLCDTO) onTap,
  ) {
    return ItemCard(
      title: itemTitle(item),
      subtitle:
          MaterialLocalizations.of(context).formatCompactDate(item.finishDate),
      hasImage: DLCTheme.hasImage,
      imageURL: item.coverUrl,
      onTap: onTap(context, item),
    );
  }

  static Widget itemCardAvailable(
    BuildContext context,
    DLCAvailableDTO item,
    void Function()? Function(BuildContext, DLCAvailableDTO) onTap,
  ) {
    return ItemCard(
      title: itemTitle(item),
      subtitle: MaterialLocalizations.of(context)
          .formatCompactDate(item.availableDate),
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
