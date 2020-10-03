import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_search/item_search.dart';

import '../search/search.dart';
import '../detail/detail.dart';
import 'relation.dart';


class StorePurchaseRelationList extends StoreRelationList<Purchase> {
  StorePurchaseRelationList({Key key, String shownName, List<Widget> Function(List<Purchase>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  ItemDetail<Purchase, PurchaseDetailBloc> detailBuilder(Purchase purchase) {

    return PurchaseDetail(
      item: purchase,
    );

  }

  @override
  ItemSearch<Purchase, ItemSearchBloc<Purchase>> repositorySearchBuilder(BuildContext context) {

    return PurchaseSearch();

  }

}

abstract class StoreRelationList<W extends CollectionItem> extends ItemRelationList<Store, W, StoreRelationBloc<W>> {
  StoreRelationList({Key key, String shownName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);
}