import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme, PurchaseTheme;
import 'relation.dart';

class DLCGameRelationList extends _DLCRelationList<Game> {
  const DLCGameRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<Game>)? trailingBuilder,
  }) : super(
          key: key,
          relationName: relationName,
          relationTypeName: relationTypeName,
          trailingBuilder: trailingBuilder,
          isSingleList: true,
          hasImage: Game.hasImage,
          detailRouteName: gameDetailRoute,
          searchRouteName: gameSearchRoute,
          localSearchRouteName: gameLocalSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, Game item) =>
      GameTheme.itemCard(context, item, onTap);
}

class DLCPurchaseRelationList extends _DLCRelationList<Purchase> {
  const DLCPurchaseRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<Purchase>)? trailingBuilder,
  }) : super(
          key: key,
          relationName: relationName,
          relationTypeName: relationTypeName,
          trailingBuilder: trailingBuilder,
          hasImage: Purchase.hasImage,
          detailRouteName: purchaseDetailRoute,
          searchRouteName: purchaseSearchRoute,
          localSearchRouteName: purchaseLocalSearchRoute,
        );

  @override
  Widget cardBuilder(BuildContext context, Purchase item) =>
      PurchaseTheme.itemCard(context, item, onTap);
}

abstract class _DLCRelationList<W extends Item> extends ItemRelationList<DLC, W,
    DLCRelationBloc<W>, DLCRelationManagerBloc<W>> {
  const _DLCRelationList({
    Key? key,
    required String relationName,
    required String relationTypeName,
    List<Widget> Function(List<W>)? trailingBuilder,
    bool limitHeight = true,
    bool isSingleList = false,
    required bool hasImage,
    String detailRouteName = '',
    required String searchRouteName,
    required String localSearchRouteName,
  }) : super(
          key: key,
          relationName: relationName,
          relationTypeName: relationTypeName,
          trailingBuilder: trailingBuilder,
          limitHeight: limitHeight,
          isSingleList: isSingleList,
          hasImage: hasImage,
          detailRouteName: detailRouteName,
          searchRouteName: searchRouteName,
          localSearchRouteName: localSearchRouteName,
        );
}
