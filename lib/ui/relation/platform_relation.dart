import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'relation.dart';


class PlatformGameRelationList extends _PlatformRelationList<Game> {
  const PlatformGameRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<Game>)? trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = gameDetailRoute;

  @override
  final String searchRouteName = gameSearchRoute;

  @override
  final String localSearchRouteName = gameLocalSearchRoute;

  @override
  Widget cardBuilder(BuildContext context, Game item) => GameTheme.itemCard(context, item, onTap);
}

class PlatformSystemRelationList extends _PlatformRelationList<System> {
  const PlatformSystemRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<System>)? trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = '';

  @override
  final String searchRouteName = systemSearchRoute;

  @override
  final String localSearchRouteName = systemLocalSearchRoute;

  @override
  void Function()? onTap(BuildContext context, System item) => null;

  @override
  Widget cardBuilder(BuildContext context, System item) => SystemTheme.itemCard(context, item, onTap);
}

abstract class _PlatformRelationList<W extends CollectionItem> extends ItemRelationList<Platform, W, PlatformRelationBloc<W>, PlatformRelationManagerBloc<W>> {
  const _PlatformRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<W>)? trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);
}