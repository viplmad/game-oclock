import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'relation.dart';


class GamePlatformRelationList extends _GameRelationList<Platform> {
  const GamePlatformRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<Platform>)? trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = platformDetailRoute;

  @override
  final String searchRouteName = platformSearchRoute;

  @override
  final String localSearchRouteName = platformLocalSearchRoute;

  @override
  Widget cardBuilder(BuildContext context, Platform item) => PlatformTheme.itemCard(context, item, onTap);
}

class GamePurchaseRelationList extends _GameRelationList<Purchase> {
  const GamePurchaseRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<Purchase>)? trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = purchaseDetailRoute;

  @override
  final String searchRouteName = purchaseSearchRoute;

  @override
  final String localSearchRouteName = purchaseLocalSearchRoute;

  @override
  Widget cardBuilder(BuildContext context, Purchase item) => PurchaseTheme.itemCard(context, item, onTap);
}

class GameDLCRelationList extends _GameRelationList<DLC> {
  const GameDLCRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<DLC>)? trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = dlcDetailRoute;

  @override
  final String searchRouteName = dlcSearchRoute;

  @override
  final String localSearchRouteName = dlcLocalSearchRoute;

  @override
  Widget cardBuilder(BuildContext context, DLC item) => DLCTheme.itemCard(context, item, onTap);
}

class GameTagRelationList extends _GameRelationList<GameTag> {
  const GameTagRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<GameTag>)? trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = '';

  @override
  final String searchRouteName = tagSearchRoute;

  @override
  final String localSearchRouteName = tagLocalSearchRoute;

  @override
  void Function()? onTap(BuildContext context, GameTag item) => null;

  @override
  Widget cardBuilder(BuildContext context, GameTag item) => TagTheme.itemCard(context, item, onTap);
}

abstract class _GameRelationList<W extends Item> extends ItemRelationList<Game, W, GameRelationBloc<W>, GameRelationManagerBloc<W>> {
  const _GameRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<W>)? trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);
}