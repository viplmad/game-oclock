import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'list.dart';


class StoreAppBar extends ItemAppBar<Store, StoreListBloc> {
  const StoreAppBar({
    Key? key,
  }) : super(key: key);

  @override
  final Color themeColor = StoreTheme.primaryColour;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).storesString;

  @override
  List<String> views(BuildContext context) => StoreTheme.views(context);
}

class StoreFAB extends ItemFAB<Store, StoreListManagerBloc> {
  const StoreFAB({
    Key? key,
  }) : super(key: key);

  @override
  final Color themeColor = StoreTheme.primaryColour;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).storeString;
}

class StoreList extends ItemList<Store, StoreListBloc, StoreListManagerBloc> {
  const StoreList({
    Key? key,
  }) : super(key: key);

  @override
  final String detailRouteName = storeDetailRoute;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).storeString;

  @override
  _StoreListBody itemListBodyBuilder({required List<Store> items, required int viewIndex, required int viewYear, required void Function(Store) onDelete, required ListStyle style}) {

    return _StoreListBody(
      items: items,
      viewIndex: viewIndex,
      viewYear: viewYear,
      onDelete: onDelete,
      style: style,
    );

  }
}

class _StoreListBody extends ItemListBody<Store, StoreListBloc> {
  const _StoreListBody({
    Key? key,
    required List<Store> items,
    required int viewIndex,
    required int viewYear,
    required void Function(Store) onDelete,
    required ListStyle style,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    viewYear: viewYear,
    onDelete: onDelete,
    style: style,
  );

  @override
  final String detailRouteName = storeDetailRoute;

  @override
  final String localSearchRouteName = storeLocalSearchRoute;

  @override
  final String statisticsRouteName = '';

  @override
  final String calendarRouteName = '';

  @override
  String itemTitle(Store item) => StoreTheme.itemTitle(item);

  @override
  String viewTitle(BuildContext context) => StoreTheme.views(context).elementAt(viewIndex);

  @override
  Widget cardBuilder(BuildContext context, Store item) => StoreTheme.itemCard(context, item, onTap);

  @override
  Widget gridBuilder(BuildContext context, Store item) => StoreTheme.itemGrid(context, item, onTap);
}