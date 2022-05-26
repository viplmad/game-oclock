import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show GameTag;

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';
import 'theme_utils.dart';

class GameTagTheme {
  GameTagTheme._();

  static const Color primaryColour = Colors.black87;
  static const Color secondaryColour = Colors.black12;

  static ThemeData themeData(BuildContext context) {
    return ThemeUtils.themeByColours(context, primaryColour, secondaryColour);
  }

  static List<String> views(BuildContext context) {
    return <String>[
      GameCollectionLocalisations.of(context).mainViewString,
      GameCollectionLocalisations.of(context).lastCreatedViewString,
    ];
  }

  static Widget itemCard(
    BuildContext context,
    GameTag item,
    void Function()? Function(BuildContext, GameTag) onTap,
  ) {
    return ItemCard(
      title: itemTitle(item),
      hasImage: GameTag.hasImage,
      onTap: onTap(context, item),
    );
  }

  static Widget itemTile(
    BuildContext context,
    GameTag item,
    void Function()? Function(BuildContext, GameTag) onTap,
  ) {
    return ListTile(
      title: Text(itemTitle(item)),
      onTap: onTap(context, item),
    );
  }

  static String itemTitle(GameTag item) {
    return item.name;
  }
}
