import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart'
    show DLCTheme, GameTheme, StoreTheme, PurchaseTypeTheme;
import 'relation.dart';

class PurchaseStoreRelationList extends _PurchaseRelationList<Store> {
  const PurchaseStoreRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          isSingleList: true,
          hasImage: Store.hasImage,
          detailRouteName: storeDetailRoute,
          searchRouteName: storeSearchRoute,
          localSearchRouteName: storeLocalSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, Store item) =>
      StoreTheme.itemCard(context, item, onTap);
}

class PurchaseGameRelationList extends _PurchaseRelationList<Game> {
  const PurchaseGameRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          hasImage: Game.hasImage,
          detailRouteName: gameDetailRoute,
          searchRouteName: gameSearchRoute,
          localSearchRouteName: gameLocalSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, Game item) =>
      GameTheme.itemCard(context, item, onTap);
}

class PurchaseDLCRelationList extends _PurchaseRelationList<DLC> {
  const PurchaseDLCRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          hasImage: DLC.hasImage,
          detailRouteName: dlcDetailRoute,
          searchRouteName: dlcSearchRoute,
          localSearchRouteName: dlcLocalSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, DLC item) =>
      DLCTheme.itemCard(context, item, onTap);
}

class PurchaseTypeRelationList extends _PurchaseRelationList<PurchaseType> {
  const PurchaseTypeRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          hasImage: PurchaseType.hasImage,
          searchRouteName: purchaseTypeSearchRoute,
          localSearchRouteName: purchaseTypeLocalSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, PurchaseType item) =>
      PurchaseTypeTheme.itemCard(context, item, onTap);
}

abstract class _PurchaseRelationList<W extends Item> extends ItemRelationList<
    Purchase, W, PurchaseRelationBloc<W>, PurchaseRelationManagerBloc<W>> {
  const _PurchaseRelationList({
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
