import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme;
import 'relation.dart';


class GameTagGameRelationList extends _GameTagRelationList<Game> {
  const GameTagGameRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<Game>)? trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder, limitHeight: false);

  @override
  final String detailRouteName = gameDetailRoute;

  @override
  final String searchRouteName = gameSearchRoute;

  @override
  final String localSearchRouteName = gameLocalSearchRoute;

  @override
  Widget cardBuilder(BuildContext context, Game item) => GameTheme.itemCard(context, item, onTap);
}

abstract class _GameTagRelationList<W extends Item> extends ItemRelationList<Game, W, GameTagRelationBloc<W>, GameTagRelationManagerBloc<W>> {
  const _GameTagRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<W>)? trailingBuilder,
    bool limitHeight = true,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder, limitHeight: limitHeight);
}