import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import '../common/item_view.dart';


class GameTagTheme {
  static Widget itemCard(BuildContext context, GameTag item, void Function()? Function(BuildContext, GameTag) onTap) {

    return ItemCard(
      title: _getTitle(item),
      hasImage: item.hasImage,
      onTap: onTap(context, item),
    );

  }

  static Widget itemGrid(BuildContext context, GameTag item, void Function()? Function(BuildContext, GameTag) onTap) {

    return ItemGrid(
      title: _getTitle(item),
      hasImage: item.hasImage,
      onTap: onTap(context, item),
    );

  }

  static String _getTitle(GameTag item) {

    return item.name;

  }
}