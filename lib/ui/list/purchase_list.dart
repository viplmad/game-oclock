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


class PurchaseAppBar extends ItemAppBar<Purchase, PurchaseListBloc> {

  @override
  BarData getBarData() {

    return purchaseBarData;

  }

}

class PurchaseFAB extends ItemFAB<Purchase, PurchaseListBloc> {

  @override
  BarData getBarData() {

    return purchaseBarData;

  }

}

class PurchaseList extends ItemList<Purchase, PurchaseListBloc> {

  @override
  ItemDetail<Purchase, PurchaseDetailBloc> detailBuilder(Purchase purchase) {

    return PurchaseDetail(
      item: purchase,
    );

  }

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

class _PurchaseListBody extends ItemListBody<Purchase> {

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
  String getViewTitle() {

    return purchaseBarData.views.elementAt(viewIndex);

  }

  @override
  ItemDetail<Purchase, PurchaseDetailBloc> detailBuilder(Purchase purchase) {

    return PurchaseDetail(
      item: purchase,
    );

  }

  @override
  Widget statisticsBuilder() {

    return PurchaseStatistics(
      yearData: PurchasesData(
        purchases: items,
      ).getYearData(2020),
    );

  }

}