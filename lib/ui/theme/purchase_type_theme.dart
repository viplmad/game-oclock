import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import '../common/item_view.dart';

class PurchaseTypeTheme {
  PurchaseTypeTheme._();

  static Widget itemCard(
    BuildContext context,
    PurchaseType item,
    void Function()? Function(BuildContext, PurchaseType) onTap,
  ) {
    return ItemCard(
      title: _itemTitle(item),
      hasImage: item.hasImage,
      onTap: onTap(context, item),
    );
  }

  static String _itemTitle(PurchaseType item) {
    return item.name;
  }
}
