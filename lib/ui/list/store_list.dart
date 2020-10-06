import 'package:flutter/material.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'list.dart';


class StoreAppBar extends ItemAppBar<Store, StoreListBloc> {

  @override
  BarData barData = storeBarData;

}

class StoreFAB extends ItemFAB<Store, StoreListManagerBloc> {

  @override
  BarData barData = storeBarData;

}

class StoreList extends ItemList<Store, StoreListBloc, StoreListManagerBloc> {

  @override
  String detailRouteName = storeDetailRoute;

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
  String detailRouteName = storeDetailRoute;

  @override
  String localSearchRouteName = storeLocalSearchRoute;

  @override
  void Function() onStatisticsTap(BuildContext context) {

    return null;

  }

  @override
  String getViewTitle() {

    return storeBarData.views.elementAt(viewIndex);

  }

}