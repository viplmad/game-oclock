import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme, SystemTheme;
import 'relation.dart';

class PlatformGameRelationList extends _PlatformRelationList<Game> {
  const PlatformGameRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          hasImage: Game.hasImage,
          detailRouteName: gameDetailRoute,
          searchRouteName: gameSearchRoute,
          localSearchRouteName: gameLocalSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, Game item) =>
      GameTheme.itemCard(context, item, onTap);
}

class PlatformSystemRelationList extends _PlatformRelationList<System> {
  const PlatformSystemRelationList({
    Key? key,
    required super.relationName,
    required super.relationTypeName,
    super.trailingBuilder,
  }) : super(
          key: key,
          hasImage: System.hasImage,
          searchRouteName: systemSearchRoute,
          localSearchRouteName: systemLocalSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, System item) =>
      SystemTheme.itemCard(context, item, onTap);
}

abstract class _PlatformRelationList<W extends Item> extends ItemRelationList<
    Platform, W, PlatformRelationBloc<W>, PlatformRelationManagerBloc<W>> {
  const _PlatformRelationList({
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
