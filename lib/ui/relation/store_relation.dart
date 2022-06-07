import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show PurchaseTheme;
import 'relation.dart';

class StorePurchaseRelationList extends _StoreRelationList<Purchase> {
  const StorePurchaseRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          hasImage: Purchase.hasImage,
          detailRouteName: purchaseDetailRoute,
          searchRouteName: purchaseSearchRoute,
          localSearchRouteName: purchaseLocalSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, Purchase item) =>
      PurchaseTheme.itemCard(context, item, onTap);
}

abstract class _StoreRelationList<W extends Item> extends ItemRelationList<
    Store, W, StoreRelationBloc<W>, StoreRelationManagerBloc<W>> {
  const _StoreRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
    super.limitHeight = true,
    super.isSingleList = false,
    required super.hasImage,
    super.detailRouteName = '',
    required super.searchRouteName,
    required super.localSearchRouteName,
  }) : super(key: key);
}
