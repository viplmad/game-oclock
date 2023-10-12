import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_collection_client/api.dart' show TagDTO;

import 'package:logic/model/model.dart' show TagView;

import 'package:game_oclock/ui/common/item_view.dart';
import 'package:game_oclock/ui/utils/theme_utils.dart';

class TagTheme {
  TagTheme._();

  static const bool hasImage = false;

  static const Color primaryColour = Colors.black87;
  static const Color secondaryColour = Colors.black12;

  static ThemeData themeData(BuildContext context) {
    return ThemeUtils.themeByColours(context, primaryColour, secondaryColour);
  }

  static List<String> views(BuildContext context) {
    return TagView.values
        .map<String>((TagView view) => _viewString(context, view))
        .toList(growable: false);
  }

  static String _viewString(BuildContext context, TagView view) {
    switch (view) {
      case TagView.main:
        return AppLocalizations.of(context)!.mainViewString;
      case TagView.lastAdded:
        return AppLocalizations.of(context)!.lastAddedViewString;
      case TagView.lastUpdated:
        return AppLocalizations.of(context)!.lastUpdatedViewString;
    }
  }

  static Widget itemCard(
    BuildContext context,
    TagDTO item,
    void Function()? Function(BuildContext, TagDTO) onTap,
  ) {
    return ItemCard(
      title: itemTitle(item),
      hasImage: TagTheme.hasImage,
      onTap: onTap(context, item),
    );
  }

  static Widget itemTile(
    BuildContext context,
    TagDTO item,
    void Function()? Function(BuildContext, TagDTO) onTap,
  ) {
    return ListTile(
      title: Text(itemTitle(item)),
      onTap: onTap(context, item),
    );
  }

  static String itemTitle(TagDTO item) {
    return item.name;
  }
}
