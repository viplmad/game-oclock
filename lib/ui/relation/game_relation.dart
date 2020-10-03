import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_search/item_search.dart';

import '../search/search.dart';
import '../detail/detail.dart';
import 'relation.dart';


class GamePlatformRelationList extends GameRelationList<Platform> {
  GamePlatformRelationList({Key key, String shownName, List<Widget> Function(List<Platform>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  ItemDetail<Platform, PlatformDetailBloc> detailBuilder(Platform platform) {

    return PlatformDetail(
      item: platform,
    );

  }

  @override
  ItemSearch<Platform, ItemSearchBloc<Platform>> repositorySearchBuilder(BuildContext context) {

    return PlatformSearch();

  }

}

class GamePurchaseRelationList extends GameRelationList<Purchase> {
  GamePurchaseRelationList({Key key, String shownName, List<Widget> Function(List<Purchase>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

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

class GameDLCRelationList extends GameRelationList<DLC> {
  GameDLCRelationList({Key key, String shownName, List<Widget> Function(List<DLC>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

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

class GameTagRelationList extends GameRelationList<Tag> {
  GameTagRelationList({Key key, String shownName, List<Widget> Function(List<Tag>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  ItemSearch<Tag, ItemSearchBloc<Tag>> repositorySearchBuilder(BuildContext context) {

    return TagSearch();

  }

  @override
  void Function() onTap(BuildContext context, Tag item) {

    return null;

  }

}

abstract class GameRelationList<W extends CollectionItem> extends ItemRelationList<Game, W, GameRelationBloc<W>> {
  GameRelationList({Key key, String shownName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);
}