import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'relation.dart';


class PurchaseStoreRelationList extends _PurchaseRelationList<Store> {
  PurchaseStoreRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<Store>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final bool isSingleList = true;

  @override
  final String detailRouteName = storeDetailRoute;

  @override
  final String searchRouteName = storeSearchRoute;

  @override
  final String localSearchRouteName = storeLocalSearchRoute;

  @override
  Widget cardBuilder(BuildContext context, Store item) {

    return StoreTheme.itemCard(context, item, onTap);

  }

}

class PurchaseGameRelationList extends _PurchaseRelationList<Game> {
  PurchaseGameRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<Game>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = gameDetailRoute;

  @override
  final String searchRouteName = gameSearchRoute;

  @override
  final String localSearchRouteName = gameLocalSearchRoute;

  @override
  Widget cardBuilder(BuildContext context, Game item) {

    return GameTheme.itemCard(context, item, onTap);

  }

}

class PurchaseDLCRelationList extends _PurchaseRelationList<DLC> {
  PurchaseDLCRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<DLC>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = dlcDetailRoute;

  @override
  final String searchRouteName = dlcSearchRoute;

  @override
  final String localSearchRouteName = dlcLocalSearchRoute;

  @override
  Widget cardBuilder(BuildContext context, DLC item) {

    return DLCTheme.itemCard(context, item, onTap);

  }

}

class PurchaseTypeRelationList extends _PurchaseRelationList<PurchaseType> {
  PurchaseTypeRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<PurchaseType>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);

  @override
  final String detailRouteName = '';

  @override
  final String searchRouteName = typeSearchRoute;

  @override
  final String localSearchRouteName = typeLocalSearchRoute;

  @override
  void Function() onTap(BuildContext context, PurchaseType item) {

    return null;

  }

  @override
  Widget cardBuilder(BuildContext context, PurchaseType item) {

    return TypeTheme.itemCard(context, item, onTap);

  }

}

abstract class _PurchaseRelationList<W extends CollectionItem> extends ItemRelationList<Purchase, W, PurchaseRelationBloc<W>, PurchaseRelationManagerBloc<W>> {
  _PurchaseRelationList({Key key, @required String relationName, @required String relationTypeName, List<Widget> Function(List<W>) trailingBuilder}) : super(key: key, relationName: relationName, relationTypeName: relationTypeName, trailingBuilder: trailingBuilder);
}