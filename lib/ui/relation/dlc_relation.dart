import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';

import '../route_constants.dart';
import 'relation.dart';


class DLCGameRelationList extends DLCRelationList<Game> {
  DLCGameRelationList({Key key, String shownName, List<Widget> Function(List<Game>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  bool isSingleList = true;

  @override
  String detailRouteName = gameDetailRoute;

  @override
  String searchRouteName = gameSearchRoute;

  @override
  String localSearchRouteName = gameLocalSearchRoute;

}

class DLCPurchaseRelationList extends DLCRelationList<Purchase> {
  DLCPurchaseRelationList({Key key, String shownName, List<Widget> Function(List<Purchase>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  String detailRouteName = purchaseDetailRoute;

  @override
  String searchRouteName = purchaseSearchRoute;

  @override
  String localSearchRouteName = purchaseLocalSearchRoute;

}

abstract class DLCRelationList<W extends CollectionItem> extends ItemRelationList<DLC, W, DLCRelationBloc<W>> {
  DLCRelationList({Key key, String shownName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);
}