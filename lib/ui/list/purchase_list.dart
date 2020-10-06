import 'package:flutter/material.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'list.dart';


class PurchaseAppBar extends ItemAppBar<Purchase, PurchaseListBloc> {

  @override
  BarData barData = purchaseBarData;

}

class PurchaseFAB extends ItemFAB<Purchase, PurchaseListManagerBloc> {

  @override
  BarData barData = purchaseBarData;

}

class PurchaseList extends ItemList<Purchase, PurchaseListBloc, PurchaseListManagerBloc> {

  @override
  String detailRouteName = purchaseDetailRoute;

  @override
  _PurchaseListBody itemListBodyBuilder({@required List<Purchase> items, @required int viewIndex, @required void Function(Purchase) onDelete, @required ListStyle style}) {

    return _PurchaseListBody(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
    );

  }

}

class _PurchaseListBody extends ItemListBody<Purchase, PurchaseListBloc> {

  _PurchaseListBody({
    Key key,
    @required List<Purchase> items,
    @required int viewIndex,
    @required void Function(Purchase) onDelete,
    @required ListStyle style,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    onDelete: onDelete,
    style: style,
  );

  @override
  String detailRouteName = purchaseDetailRoute;

  @override
  String localSearchRouteName = purchaseLocalSearchRoute;

  @override
  String statisticsRouteName = purchaseStatisticsRoute;

  @override
  String getViewTitle() {

    return purchaseBarData.views.elementAt(viewIndex);

  }

}