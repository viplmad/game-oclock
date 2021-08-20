import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show DLCTheme, GameTheme, StoreTheme, PurchaseTypeTheme;
import 'relation.dart';


class PurchaseStoreRelationList extends _PurchaseRelationList<Store> {
  const PurchaseStoreRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<Store>)? trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final bool isSingleList = true;

  @override
  final String detailRouteName = storeDetailRoute;

  @override
  final String searchRouteName = storeSearchRoute;

  @override
  final String localSearchRouteName = storeLocalSearchRoute;

  @override
  Widget cardBuilder(BuildContext context, Store item) => StoreTheme.itemCard(context, item, onTap);
}

class PurchaseGameRelationList extends _PurchaseRelationList<Game> {
  const PurchaseGameRelationList({
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

class PurchaseDLCRelationList extends _PurchaseRelationList<DLC> {
  const PurchaseDLCRelationList({
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

class PurchaseTypeRelationList extends _PurchaseRelationList<PurchaseType> {
  const PurchaseTypeRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<PurchaseType>)? trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = '';

  @override
  final String searchRouteName = purchaseTypeSearchRoute;

  @override
  final String localSearchRouteName = purchaseTypeLocalSearchRoute;

  @override
  void Function()? onTap(BuildContext context, PurchaseType item) => null;

  @override
  Widget cardBuilder(BuildContext context, PurchaseType item) => PurchaseTypeTheme.itemCard(context, item, onTap);
}

abstract class _PurchaseRelationList<W extends Item> extends ItemRelationList<Purchase, W, PurchaseRelationBloc<W>, PurchaseRelationManagerBloc<W>> {
  const _PurchaseRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<W>)? trailingBuilder,
  }) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);
}