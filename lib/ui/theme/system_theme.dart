import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import '../common/item_view.dart';


class SystemTheme {
  static Widget itemCard(BuildContext context, System item, void Function()? Function(BuildContext, System) onTap, [void Function()? Function(BuildContext, System)? onLongPress]) {

    return ItemCard(
      title: _getTitle(item),
      subtitle: _getSubtitle(item),
      hasImage: item.hasImage,
      imageURL: item.image.url,
      onTap: onTap(context, item),
      onLongPress: onLongPress != null? onLongPress(context, item) : null,
    );

  }

  static Widget itemGrid(BuildContext context, System item, void Function()? Function(BuildContext, System) onTap) {

    return ItemGrid(
      title: _getTitle(item),
      hasImage: item.hasImage,
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );

  }

  static String _getTitle(System item) {

    return item.name;

  }

  static String _getSubtitle(System item) {

    return item.manufacturer?? '';

  }
}