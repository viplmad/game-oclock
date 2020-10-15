import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import 'relation.dart';


class DLCGameRelationList extends _DLCRelationList<Game> {
  DLCGameRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<Game>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final bool isSingleList = true;

  @override
  final String detailRouteName = gameDetailRoute;

  @override
  final String searchRouteName = gameSearchRoute;

  @override
  final String localSearchRouteName = gameLocalSearchRoute;

}

class DLCPurchaseRelationList extends _DLCRelationList<Purchase> {
  DLCPurchaseRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<Purchase>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = purchaseDetailRoute;

  @override
  final String searchRouteName = purchaseSearchRoute;

  @override
  final String localSearchRouteName = purchaseLocalSearchRoute;

}

abstract class _DLCRelationList<W extends CollectionItem> extends ItemRelationList<DLC, W, DLCRelationBloc<W>, DLCRelationManagerBloc<W>> {
  _DLCRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);
}