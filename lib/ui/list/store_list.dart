import 'package:flutter/material.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';

import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/bar_data.dart';
import 'package:game_collection/model/model.dart';

import '../theme/theme.dart';
import '../detail/detail.dart';
import '../statistics/statistics.dart';

import 'list.dart';


class StoreAppBar extends ItemAppBar<Store, StoreListBloc> {

  @override
  BarData getBarData() {

    return storeBarData;

  }

}

class StoreFAB extends ItemFAB<Store, StoreListBloc> {

  @override
  BarData getBarData() {

    return storeBarData;

  }

}

class StoreList extends ItemList<Store, StoreListBloc> {

  @override
  ItemDetail<Store, StoreDetailBloc> detailBuilder(Store store) {

    return StoreDetail(
      item: store,
    );

  }

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

class _StoreListBody extends ItemListBody<Store> {

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
  String getViewTitle() {

    return storeBarData.views.elementAt(viewIndex);

  }

  @override
  ItemDetail<Store, StoreDetailBloc> detailBuilder(Store store) {

    return StoreDetail(
      item: store,
    );

  }

  @override
  Widget statisticsBuilder() {

    return null;

  }

}