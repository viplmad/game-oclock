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
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          limitHeight: false,
          hasImage: Game.hasImage,
          detailRouteName: gameDetailRoute,
          searchRouteName: gameSearchRoute,
          localSearchRouteName: gameLocalSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, Game item) =>
      GameTheme.itemCard(context, item, onTap);
}

abstract class _GameTagRelationList<W extends Item> extends ItemRelationList<
    Game, W, GameTagRelationBloc<W>, GameTagRelationManagerBloc<W>> {
  const _GameTagRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
    super.limitHeight = true,
    super.isSingleList = false,
    required super.hasImage,
    super.detailRouteName = '',
    required super.searchRouteName,
    required super.localSearchRouteName,
  }) : super(key: key);
}
