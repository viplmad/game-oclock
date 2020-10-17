import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import '../common/item_view.dart';


class SystemTheme {

  static Widget itemCard(BuildContext context, System item, void Function() Function(BuildContext, System) onTap) {

    return ItemCard(
      title: _getTitle(item),
      subtitle: _getSubtitle(item),
      imageURL: item.iconURL?? '',
      onTap: onTap(context, item),
    );

  }

  static Widget itemGrid(BuildContext context, System item, void Function() Function(BuildContext, System) onTap) {

    return ItemGrid(
      title: _getTitle(item),
      imageURL: item.iconURL?? '',
      onTap: onTap(context, item),
    );

  }

  static String _getTitle(System item) {

    return item.name;

  }

  static String _getSubtitle(System item) {

    return item.manufacturer;

  }

}