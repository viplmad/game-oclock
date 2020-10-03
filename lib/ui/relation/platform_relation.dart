import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_search/item_search.dart';

import '../search/search.dart';
import '../detail/detail.dart';
import 'relation.dart';


class PlatformGameRelationList extends PlatformRelationList<Game> {
  PlatformGameRelationList({Key key, String shownName, List<Widget> Function(List<Game>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

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

class PlatformSystemRelationList extends PlatformRelationList<System> {
  PlatformSystemRelationList({Key key, String shownName, List<Widget> Function(List<System>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  ItemSearch<System, ItemSearchBloc<System>> repositorySearchBuilder(BuildContext context) {

    return SystemSearch();

  }

  @override
  void Function() onTap(BuildContext context, System item) {

    return null;

  }

}

abstract class PlatformRelationList<W extends CollectionItem> extends ItemRelationList<Platform, W, PlatformRelationBloc<W>> {
  PlatformRelationList({Key key, String shownName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);
}