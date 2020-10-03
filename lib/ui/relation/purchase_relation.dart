import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_search/item_search.dart';

import '../search/search.dart';
import '../detail/detail.dart';
import 'relation.dart';


class PurchaseStoreRelationList extends PurchaseRelationList<Store> {
  PurchaseStoreRelationList({Key key, String shownName, List<Widget> Function(List<Store>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  bool isSingleList = true;

  @override
  ItemDetail<Store, StoreDetailBloc> detailBuilder(Store store) {

    return StoreDetail(
      item: store,
    );

  }

  @override
  ItemSearch<Store, ItemSearchBloc<Store>> repositorySearchBuilder(BuildContext context) {

    return StoreSearch();

  }

}

class PurchaseGameRelationList extends PurchaseRelationList<Game> {
  PurchaseGameRelationList({Key key, String shownName, List<Widget> Function(List<Game>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  ItemDetail<Game, GameDetailBloc> detailBuilder(Game game) {

    return GameDetail(
      item: game,
    );

  }

  @override
  ItemSearch<Game, ItemSearchBloc<Game>> repositorySearchBuilder(BuildContext context) {

    return GameSearch();

  }

}

class PurchaseDLCRelationList extends PurchaseRelationList<DLC> {
  PurchaseDLCRelationList({Key key, String shownName, List<Widget> Function(List<DLC>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  ItemDetail<DLC, DLCDetailBloc> detailBuilder(DLC dlc) {

    return DLCDetail(
      item: dlc,
    );

  }

  @override
  ItemSearch<DLC, ItemSearchBloc<DLC>> repositorySearchBuilder(BuildContext context) {

    return DLCSearch();

  }

}

class PurchaseTypeRelationList extends PurchaseRelationList<PurchaseType> {
  PurchaseTypeRelationList({Key key, String shownName, List<Widget> Function(List<PurchaseType>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  String typeName = 'Type';

  @override
  ItemSearch<PurchaseType, ItemSearchBloc<PurchaseType>> repositorySearchBuilder(BuildContext context) {

    return TypeSearch();

  }

  @override
  void Function() onTap(BuildContext context, PurchaseType item) {

    return null;

  }

}

abstract class PurchaseRelationList<W extends CollectionItem> extends ItemRelationList<Purchase, W, PurchaseRelationBloc<W>> {
  PurchaseRelationList({Key key, String shownName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);
}