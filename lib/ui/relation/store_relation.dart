import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'relation.dart';


class StorePurchaseRelationList extends _StoreRelationList<Purchase> {
  const StorePurchaseRelationList({
    Key key,
    @required String relationName,
    @required String relationTypeName,
    List<Widget> Function(List<Purchase>) trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = purchaseDetailRoute;

  @override
  final String searchRouteName = purchaseSearchRoute;

  @override
  final String localSearchRouteName = purchaseLocalSearchRoute;

  @override
  Widget cardBuilder(BuildContext context, Purchase item) => PurchaseTheme.itemCard(context, item, onTap);
}

abstract class _StoreRelationList<W extends CollectionItem> extends ItemRelationList<Store, W, StoreRelationBloc<W>, StoreRelationManagerBloc<W>> {
  const _StoreRelationList({
    Key key,
    @required String relationName,
    @required String relationTypeName,
    List<Widget> Function(List<W>) trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);
}