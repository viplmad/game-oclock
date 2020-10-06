import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import 'relation.dart';


class PlatformGameRelationList extends PlatformRelationList<Game> {
  PlatformGameRelationList({Key key, String shownName, List<Widget> Function(List<Game>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  String detailRouteName = gameDetailRoute;

  @override
  String searchRouteName = gameSearchRoute;

  @override
  String localSearchRouteName = gameLocalSearchRoute;

}

class PlatformSystemRelationList extends PlatformRelationList<System> {
  PlatformSystemRelationList({Key key, String shownName, List<Widget> Function(List<System>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);

  @override
  String searchRouteName = systemSearchRoute;

  @override
  String localSearchRouteName = systemLocalSearchRoute;

  @override
  void Function() onTap(BuildContext context, System item) {

    return null;

  }

}

abstract class PlatformRelationList<W extends CollectionItem> extends ItemRelationList<Platform, W, PlatformRelationBloc<W>, PlatformRelationManagerBloc<W>> {
  PlatformRelationList({Key key, String shownName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, shownName: shownName, trailingBuilder: trailingBuilder);
}