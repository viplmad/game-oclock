import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';
import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';


class SystemTheme {
  static Widget itemCard(BuildContext context, System item, void Function()? Function(BuildContext, System) onTap) {

    return ItemCard(
      title: _itemTitle(item),
      subtitle: _itemSubtitle(item),
      hasImage: item.hasImage,
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );

  }

  static Widget itemGrid(BuildContext context, System item, void Function()? Function(BuildContext, System) onTap) {

    return ItemGrid(
      title: _itemTitle(item),
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );

  }

  static String _itemTitle(System item) {

    return item.name;

  }

  static String _itemSubtitle(System item) {

    return GameCollectionLocalisations.manufacturerString(item.manufacturer);

  }
}