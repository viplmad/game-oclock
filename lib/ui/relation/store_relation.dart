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
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<Purchase>)? trailingBuilder,
  }) : super(
    key: key,
    relationName: relationName,
    relationTypeName: relationTypeName,
    trailingBuilder: trailingBuilder,
    detailRouteName: purchaseDetailRoute,
    searchRouteName: purchaseSearchRoute,
    localSearchRouteName: purchaseLocalSearchRoute,
  );

  @override
  Widget cardBuilder(BuildContext context, Purchase item) => PurchaseTheme.itemCard(context, item, onTap);
}

abstract class _StoreRelationList<W extends Item> extends ItemRelationList<Store, W, StoreRelationBloc<W>, StoreRelationManagerBloc<W>> {
  const _StoreRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<W>)? trailingBuilder,
    bool limitHeight = true,
    bool isSingleList = false,
    String detailRouteName = '',
    required String searchRouteName,
    required String localSearchRouteName,
  }) : super(
    key: key,
    relationName: relationName,
    relationTypeName: relationTypeName,
    trailingBuilder: trailingBuilder,
    limitHeight: limitHeight,
    isSingleList: isSingleList,
    detailRouteName: detailRouteName,
    searchRouteName: searchRouteName,
    localSearchRouteName: localSearchRouteName,
  );
}