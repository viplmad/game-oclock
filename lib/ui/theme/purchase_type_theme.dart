import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import '../common/item_view.dart';


class PurchaseTypeTheme {
  static Widget itemCard(BuildContext context, PurchaseType item, void Function()? Function(BuildContext, PurchaseType) onTap) {

    return ItemCard(
      title: _getTitle(item),
      hasImage: item.hasImage,
      onTap: onTap(context, item),
    );

  }

  static Widget itemGrid(BuildContext context, PurchaseType item, void Function()? Function(BuildContext, PurchaseType) onTap) {

    return ItemGrid(
      title: _getTitle(item),
      hasImage: item.hasImage,
      onTap: onTap(context, item),
    );

  }

  static String _getTitle(PurchaseType item) {

    return item.name;

  }
}