import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'item_statistics.dart';


class PurchaseStatisticsBloc extends ItemStatisticsBloc<Purchase, PurchasesData> {
  PurchaseStatisticsBloc({
    required List<Purchase> items,
  }) : super(items: items);

  @override
  Future<PurchasesData> getGeneralItemData() {

    return Future<PurchasesData>.value(PurchasesData(items));

  }

  @override
  Future<PurchasesData> getItemData(LoadYearItemStatistics event) {

    final List<Purchase> yearItems = items.where((Purchase item) => item.date?.year == event.year).toList(growable: false);
    return Future<PurchasesData>.value(PurchasesData(yearItems));

  }
}