import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import '../common/item_view.dart';


class TagTheme {
  static Widget itemCard(BuildContext context, Tag item, void Function() Function(BuildContext, Tag) onTap) {

    return ItemCard(
      title: _getTitle(item),
      hasImage: item.hasImage,
      onTap: onTap(context, item),
    );

  }

  static Widget itemGrid(BuildContext context, Tag item, void Function() Function(BuildContext, Tag) onTap) {

    return ItemGrid(
      title: _getTitle(item),
      hasImage: item.hasImage,
      onTap: onTap(context, item),
    );

  }

  static String _getTitle(Tag item) {

    return item.name;

  }
}