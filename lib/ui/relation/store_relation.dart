import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';

import '../route_constants.dart';
import 'relation.dart';


class StorePurchaseRelationList extends StoreRelationList<Purchase> {
  StorePurchaseRelationList({Key key, String shownName, List<Widget> Function(List<Purchase>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  String detailRouteName = purchaseDetailRoute;

  @override
  String searchRouteName = purchaseSearchRoute;

  @override
  String localSearchRouteName = purchaseLocalSearchRoute;

}

abstract class StoreRelationList<W extends CollectionItem> extends ItemRelationList<Store, W, StoreRelationBloc<W>> {
  StoreRelationList({Key key, String shownName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);
}