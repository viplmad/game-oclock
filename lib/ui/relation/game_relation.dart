import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import 'relation.dart';


class GamePlatformRelationList extends GameRelationList<Platform> {
  GamePlatformRelationList({Key key, String shownName, List<Widget> Function(List<Platform>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  String detailRouteName = platformDetailRoute;

  @override
  String searchRouteName = platformSearchRoute;

  @override
  String localSearchRouteName = platformLocalSearchRoute;

}

class GamePurchaseRelationList extends GameRelationList<Purchase> {
  GamePurchaseRelationList({Key key, String shownName, List<Widget> Function(List<Purchase>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  String detailRouteName = purchaseDetailRoute;

  @override
  String searchRouteName = purchaseSearchRoute;

  @override
  String localSearchRouteName = purchaseLocalSearchRoute;

}

class GameDLCRelationList extends GameRelationList<DLC> {
  GameDLCRelationList({Key key, String shownName, List<Widget> Function(List<DLC>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  String detailRouteName = dlcDetailRoute;

  @override
  String searchRouteName = dlcSearchRoute;

  @override
  String localSearchRouteName = dlcLocalSearchRoute;

}

class GameTagRelationList extends GameRelationList<Tag> {
  GameTagRelationList({Key key, String shownName, List<Widget> Function(List<Tag>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  String searchRouteName = tagSearchRoute;

  @override
  String localSearchRouteName = tagLocalSearchRoute;

  @override
  void Function() onTap(BuildContext context, Tag item) {

    return null;

  }

}

abstract class GameRelationList<W extends CollectionItem> extends ItemRelationList<Game, W, GameRelationBloc<W>, GameRelationManagerBloc<W>> {
  GameRelationList({Key key, String shownName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);
}