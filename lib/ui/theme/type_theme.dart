import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import '../common/item_view.dart';


class TypeTheme {

  static Widget itemCard(BuildContext context, PurchaseType item, void Function() Function(BuildContext, PurchaseType) onTap) {

    return ItemCard(
      title: _getTitle(item),
      onTap: onTap(context, item),
    );

  }

  static Widget itemGrid(BuildContext context, PurchaseType item, void Function() Function(BuildContext, PurchaseType) onTap) {

    return ItemGrid(
      title: _getTitle(item),
      onTap: onTap(context, item),
    );

  }

  static String _getTitle(PurchaseType item) {

    return item.name;

  }

}