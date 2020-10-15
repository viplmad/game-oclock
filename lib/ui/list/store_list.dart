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

  @override
  final Color themeColor = StoreTheme.primaryColour;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).storesString;

  @override
  List<String> views(BuildContext context) => StoreTheme.views(context);

}

class StoreFAB extends ItemFAB<Store, StoreListManagerBloc> {

  @override
  final Color themeColor = StoreTheme.primaryColour;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).storeString;

}

class StoreList extends ItemList<Store, StoreListBloc, StoreListManagerBloc> {

  @override
  final String detailRouteName = storeDetailRoute;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).storeString;

  @override
  _StoreListBody itemListBodyBuilder({@required List<Store> items, @required int viewIndex, @required void Function(Store) onDelete, @required ListStyle style}) {

    return _StoreListBody(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
    );

  }

}

class _StoreListBody extends ItemListBody<Store, StoreListBloc> {

  _StoreListBody({
    Key key,
    @required List<Store> items,
    @required int viewIndex,
    @required void Function(Store) onDelete,
    @required ListStyle style,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
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
  void Function() onStatisticsTap(BuildContext context) {

    return null;

  }

  @override
  String viewTitle(BuildContext context) {

    return StoreTheme.views(context).elementAt(viewIndex);

  }

}