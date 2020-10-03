import 'package:flutter/material.dart';

import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/model/model.dart';

import 'statistics.dart';


class PurchaseStatistics extends ItemStatistics {

  PurchaseStatistics({
    Key key,
    @required this.yearData,
  }) : super(
    key: key,
    itemName: purchaseTable,
  );

  PurchasesDataYear yearData;
  int get totalItems => yearData.length;

  @override
  List<Widget> statisticsFieldsBuilder(BuildContext context) {
    double totalSpent = yearData.getTotalPrice();
    double totalValue = yearData.getTotalOriginalPrice();

    double averageSpent = totalSpent / totalItems;

    return [
      statisticsIntField(
        fieldName: "Total",
        value: totalItems,
      ),
      statisticsMoneyField(
        fieldName: "Total Spent",
        value: totalSpent,
      ),
      statisticsMoneyField(
        fieldName: "Total Saved",
        value: (totalValue - totalSpent),
      ),
      statisticsMoneyField(
        fieldName: "Total Real Value",
        value: totalValue,
      ),
      statisticsMoneyField(
        fieldName: "Average Price Spent",
        value: averageSpent,
      ),
      Divider(),
      statisticsHistogram(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: "Prices by intervals",
        labels: ([0, 5, 10, 15, 20, 25, 50, 100]).map<String>((int e) => e.toString()).toList(growable: false),
        values: yearData.getIntervalPrice([0, 5, 10, 15, 20, 25, 50, 100]),
      ),
      Divider(),
      statisticsHistogram(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: "Purchases by month",
        labels: monthLabels,
        values: yearData.getMonthCount().data,
      ),
    ];

  }
}