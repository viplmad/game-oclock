import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import 'relation.dart';


class PlatformGameRelationList extends _PlatformRelationList<Game> {
  PlatformGameRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<Game>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = gameDetailRoute;

  @override
  final String searchRouteName = gameSearchRoute;

  @override
  final String localSearchRouteName = gameLocalSearchRoute;

}

class PlatformSystemRelationList extends _PlatformRelationList<System> {
  PlatformSystemRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<System>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = '';

  @override
  final String searchRouteName = systemSearchRoute;

  @override
  final String localSearchRouteName = systemLocalSearchRoute;

  @override
  void Function() onTap(BuildContext context, System item) {

    return null;

  }

}

abstract class _PlatformRelationList<W extends CollectionItem> extends ItemRelationList<Platform, W, PlatformRelationBloc<W>, PlatformRelationManagerBloc<W>> {
  _PlatformRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);
}