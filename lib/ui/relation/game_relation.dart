import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import 'relation.dart';


class GamePlatformRelationList extends _GameRelationList<Platform> {
  GamePlatformRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<Platform>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = platformDetailRoute;

  @override
  final String searchRouteName = platformSearchRoute;

  @override
  final String localSearchRouteName = platformLocalSearchRoute;

}

class GamePurchaseRelationList extends _GameRelationList<Purchase> {
  GamePurchaseRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<Purchase>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = purchaseDetailRoute;

  @override
  final String searchRouteName = purchaseSearchRoute;

  @override
  final String localSearchRouteName = purchaseLocalSearchRoute;

}

class GameDLCRelationList extends _GameRelationList<DLC> {
  GameDLCRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<DLC>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = dlcDetailRoute;

  @override
  final String searchRouteName = dlcSearchRoute;

  @override
  final String localSearchRouteName = dlcLocalSearchRoute;

}

class GameTagRelationList extends _GameRelationList<Tag> {
  GameTagRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<Tag>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = '';

  @override
  final String searchRouteName = tagSearchRoute;

  @override
  final String localSearchRouteName = tagLocalSearchRoute;

  @override
  void Function() onTap(BuildContext context, Tag item) {

    return null;

  }

}

abstract class _GameRelationList<W extends CollectionItem> extends ItemRelationList<Game, W, GameRelationBloc<W>, GameRelationManagerBloc<W>> {
  _GameRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);
}