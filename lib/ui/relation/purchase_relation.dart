import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';

import '../route_constants.dart';
import 'relation.dart';


class PurchaseStoreRelationList extends PurchaseRelationList<Store> {
  PurchaseStoreRelationList({Key key, String shownName, List<Widget> Function(List<Store>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  bool isSingleList = true;

  @override
  String detailRouteName = storeDetailRoute;

  @override
  String searchRouteName = storeSearchRoute;

  @override
  String localSearchRouteName = storeLocalSearchRoute;

}

class PurchaseGameRelationList extends PurchaseRelationList<Game> {
  PurchaseGameRelationList({Key key, String shownName, List<Widget> Function(List<Game>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  String detailRouteName = gameDetailRoute;

  @override
  String searchRouteName = gameSearchRoute;

  @override
  String localSearchRouteName = gameLocalSearchRoute;

}

class PurchaseDLCRelationList extends PurchaseRelationList<DLC> {
  PurchaseDLCRelationList({Key key, String shownName, List<Widget> Function(List<DLC>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  String detailRouteName = dlcDetailRoute;

  @override
  String searchRouteName = dlcSearchRoute;

  @override
  String localSearchRouteName = dlcLocalSearchRoute;

}

class PurchaseTypeRelationList extends PurchaseRelationList<PurchaseType> {
  PurchaseTypeRelationList({Key key, String shownName, List<Widget> Function(List<PurchaseType>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  String typeName = 'Type';

  @override
  String searchRouteName = typeSearchRoute;

  @override
  String localSearchRouteName = typeLocalSearchRoute;

  @override
  void Function() onTap(BuildContext context, PurchaseType item) {

    return null;

  }

}

abstract class PurchaseRelationList<W extends CollectionItem> extends ItemRelationList<Purchase, W, PurchaseRelationBloc<W>> {
  PurchaseRelationList({Key key, String shownName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);
}