import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show DLCTheme, PlatformTheme, PurchaseTheme, GameTagTheme;
import 'relation.dart';


class GamePlatformRelationList extends _GameRelationList<Platform> {
  const GamePlatformRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<Platform>)? trailingBuilder,
  }) : super(
    key: key,
    relationName: relationName,
    relationTypeName: relationTypeName,
    trailingBuilder: trailingBuilder,
    detailRouteName: platformDetailRoute,
    searchRouteName: platformSearchRoute,
    localSearchRouteName: platformLocalSearchRoute,
  );

  @override
  Widget cardBuilder(BuildContext context, Platform item) => PlatformTheme.itemCard(context, item, onTap);
}

class GamePurchaseRelationList extends _GameRelationList<Purchase> {
  const GamePurchaseRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<Purchase>)? trailingBuilder,
  }) : super(
    key: key,
    relationName: relationName,
    relationTypeName: relationTypeName,
    trailingBuilder: trailingBuilder,
    detailRouteName: purchaseDetailRoute,
    searchRouteName: purchaseSearchRoute,
    localSearchRouteName: purchaseLocalSearchRoute,
  );

  @override
  Widget cardBuilder(BuildContext context, Purchase item) => PurchaseTheme.itemCard(context, item, onTap);
}

class GameDLCRelationList extends _GameRelationList<DLC> {
  const GameDLCRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<DLC>)? trailingBuilder,
  }) : super(
    key: key,
    relationName: relationName,
    relationTypeName: relationTypeName,
    trailingBuilder: trailingBuilder,
    detailRouteName: dlcDetailRoute,
    searchRouteName: dlcSearchRoute,
    localSearchRouteName: dlcLocalSearchRoute,
  );

  @override
  Widget cardBuilder(BuildContext context, DLC item) => DLCTheme.itemCard(context, item, onTap);
}

class GameTagRelationList extends _GameRelationList<GameTag> {
  const GameTagRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<GameTag>)? trailingBuilder,
  }) : super(
    key: key,
    relationName: relationName,
    relationTypeName: relationTypeName,
    trailingBuilder: trailingBuilder,
    detailRouteName: gameTagDetailRoute,
    searchRouteName: gameTagSearchRoute,
    localSearchRouteName: gameTagLocalSearchRoute,
  );

  @override
  Widget cardBuilder(BuildContext context, GameTag item) => GameTagTheme.itemCard(context, item, onTap);
}

abstract class _GameRelationList<W extends Item> extends ItemRelationList<Game, W, GameRelationBloc<W>, GameRelationManagerBloc<W>> {
  const _GameRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<W>)? trailingBuilder,
    bool limitHeight = true,
    bool isSingleList = false,
    String detailRouteName = '',
    String searchRouteName = '',
    String localSearchRouteName = '',
  }) : super(
    key: key,
    relationName: relationName,
    relationTypeName: relationTypeName,
    trailingBuilder: trailingBuilder,
    limitHeight: limitHeight,
    isSingleList: isSingleList,
    detailRouteName: detailRouteName,
    searchRouteName: searchRouteName,
    localSearchRouteName: localSearchRouteName,
  );
}