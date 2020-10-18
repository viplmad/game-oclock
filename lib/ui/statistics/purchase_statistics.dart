import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_statistics/item_statistics.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'statistics.dart';


class PurchaseStatistics extends ItemStatistics<Purchase, PurchasesData, PurchaseStatisticsBloc> {
  const PurchaseStatistics({
    Key key,
    @required List<Purchase> items,
    @required String viewTitle,
  }) : super(key: key, items: items, viewTitle: viewTitle);

  @override
  PurchaseStatisticsBloc statisticsBlocBuilder() {

    return PurchaseStatisticsBloc(
      items: items,
    );

  }

  @override
  _PurchaseStatisticsBody statisticsBodyBuilder() {

    return _PurchaseStatisticsBody(
      viewTitle: viewTitle,
    );

  }
}

class _PurchaseStatisticsBody extends ItemStatisticsBody<Purchase, PurchasesData, PurchaseStatisticsBloc> {
  const _PurchaseStatisticsBody({
    Key key,
    @required String viewTitle,
  }) : super(key: key, viewTitle: viewTitle);

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).purchasesString;

  @override
  List<Widget> statisticsGeneralFieldsBuilder(BuildContext context, PurchasesData data) {
    int totalItems = data.length;

    double priceSum = data.priceSum();
    double originalPriceSum = data.originalPriceSum();
    double externalCreditSum = data.externalCreditSum();

    double savedSum = originalPriceSum - priceSum;

    List<int> years = data.years();

    return [
      statisticsIntField(
        context,
        fieldName: GameCollectionLocalisations.of(context).totalString(typesName(context)),
        value: totalItems,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).sumPriceString,
        value: priceSum,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgPriceString,
        value: (totalItems > 0)? priceSum / totalItems : 0,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).sumExternalCreditString,
        value: externalCreditSum,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgExternalCreditString,
        value: (totalItems > 0)? externalCreditSum / totalItems : 0,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).sumOriginalPriceString,
        value: originalPriceSum,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgOriginalPriceString,
        value: (totalItems > 0)? originalPriceSum / totalItems : 0,
      ),
      statisticsPercentageField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgDiscountString,
        value: (totalItems > 0 && originalPriceSum > 0)? (1 - (priceSum + externalCreditSum) / originalPriceSum) / totalItems : 0,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).sumSavedString,
        value: savedSum,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgSavedString,
        value: (totalItems > 0)? savedSum / totalItems : 0,
      ),
      Divider(),
      _countByYear(context, data, years),
      Divider(),
      _countByPrice(context, data),
      Divider(),
      _sumPriceByYear(context, data, years),
      Divider(),
      _sumOriginalPriceByYear(context, data, years),
    ];

  }

  @override
  List<Widget> statisticsYearFieldsBuilder(BuildContext context, PurchasesData data) {
    int totalItems = data.length;

    double priceSum = data.priceSum();
    double originalPriceSum = data.originalPriceSum();
    double externalCreditSum = data.externalCreditSum();

    double savedSum = originalPriceSum - priceSum;

    //Todo average spent without promotion
    //Todo average discount without promotion

    return [
      statisticsIntField(
        context,
        fieldName: GameCollectionLocalisations.of(context).totalString(typesName(context)),
        value: totalItems,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).sumPriceString,
        value: priceSum,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgPriceString,
        value: (totalItems > 0)? priceSum / totalItems : 0,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).sumExternalCreditString,
        value: externalCreditSum,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgExternalCreditString,
        value: (totalItems > 0)? externalCreditSum / totalItems : 0,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).sumOriginalPriceString,
        value: originalPriceSum,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgOriginalPriceString,
        value: (totalItems > 0)? originalPriceSum / totalItems : 0,
      ),
      statisticsPercentageField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgDiscountString,
        value: (totalItems > 0 && originalPriceSum > 0)? (1 - (priceSum + externalCreditSum) / originalPriceSum) / totalItems : 0,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).sumSavedString,
        value: savedSum,
      ),
      statisticsMoneyField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgSavedString,
        value: (totalItems > 0)? savedSum / totalItems : 0,
      ),
      Divider(),
      _countByMonth(context, data),
      Divider(),
      _countByPrice(context, data),
      Divider(),
      _sumPriceByMonth(context, data),
      Divider(),
      _sumOriginalPriceByMonth(context, data),
      //TODO sum saved by month
    ];

  }

  //#region General
  Widget _countByYear(BuildContext context, PurchasesData data, List<int> years) {

    return years.isNotEmpty?
      statisticsHistogram<int>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).countByYearString,
        labels: years.map<String>((int e) => e.toString()).toList(growable: false),
        values: data.yearlyCount(years),
      ) : Container();
  }

  Widget _sumPriceByYear(BuildContext context, PurchasesData data, List<int> years) {

    return years.isNotEmpty?
      statisticsHistogram<double>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).sumPriceByYearString,
        labels: years.map<String>((int e) => e.toString()).toList(growable: false),
        values: data.yearlyPriceSum(years),
      ) : Container();
  }

  Widget _sumOriginalPriceByYear(BuildContext context, PurchasesData data, List<int> years) {

    return years.isNotEmpty?
      statisticsHistogram<double>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).sumOriginalPriceByYearString,
        labels: years.map<String>((int e) => e.toString()).toList(growable: false),
        values: data.yearlyOriginalPriceSum(years),
      ) : Container();
  }
  //#endregion General

  //#region Year
  Widget _countByMonth(BuildContext context, PurchasesData data) {

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByMonthString,
      labels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlyCount().values,
    );
  }

  Widget _countByPrice(BuildContext context, PurchasesData data) {

    List<double> intervals = [0.0, 5.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 55.0, 60.0, 65.0, 70.0, 75.0, 80.0, 85.0, 90.0, 95.0, 100.0];
    List<String> labels = formatIntervalLabelsWithInitialAndLast(intervals);

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByPriceString,
      labels: labels,
      values: data.intervalPriceCountWithInitialAndLast(intervals),
    );
  }

  Widget _sumPriceByMonth(BuildContext context, PurchasesData data) {

    return statisticsHistogram<double>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).sumPriceByMonthString,
      labels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlyPriceSum().values,
    );
  }

  Widget _sumOriginalPriceByMonth(BuildContext context, PurchasesData data) {

    return statisticsHistogram<double>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).sumOriginalPriceByMonthString,
      labels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlyOriginalPriceSum().values,
    );
  }
  //#endregion Year

}