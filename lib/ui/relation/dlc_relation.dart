import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme, PurchaseTheme;
import 'relation.dart';

class DLCGameRelationList extends _DLCRelationList<Game> {
  const DLCGameRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          isSingleList: true,
          hasImage: Game.hasImage,
          detailRouteName: gameDetailRoute,
          searchRouteName: gameSearchRoute,
          localSearchRouteName: gameLocalSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, Game item) =>
      GameTheme.itemCard(context, item, onTap);
}

class DLCPurchaseRelationList extends _DLCRelationList<Purchase> {
  const DLCPurchaseRelationList({
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

abstract class _DLCRelationList<W extends Item> extends ItemRelationList<DLC, W,
    DLCRelationBloc<W>, DLCRelationManagerBloc<W>> {
  const _DLCRelationList({
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
