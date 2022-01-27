import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_statistics/item_statistics.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'statistics.dart';


class PurchaseStatistics extends ItemStatistics<Purchase, PurchasesData, PurchaseStatisticsBloc> {
  const PurchaseStatistics({
    Key? key,
    required List<Purchase> items,
    required String viewTitle,
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
    Key? key,
    required String viewTitle,
  }) : super(key: key, viewTitle: viewTitle);

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).purchasesString;

  @override
  String fromYearTitle(BuildContext context, int year) => GameCollectionLocalisations.of(context).purchasesFromYearString(year);

  @override
  List<Widget> statisticsGeneralFieldsBuilder(BuildContext context, PurchasesData data) {
    final int totalItems = data.length;

    final double priceSum = data.priceSum();
    final double originalPriceSum = data.originalPriceSum();
    final double externalCreditSum = data.externalCreditSum();

    final double savedSum = originalPriceSum - priceSum;

    final int totalItemsWithoutPromotion = data.lengthWithoutPromotion;

    return <Widget>[
      statisticsIntField(
        context,
        fieldName: GameCollectionLocalisations.of(context).totalPurchasesString,
        value: totalItems,
      ),
      statisticsIntField(
        context,
        fieldName: GameCollectionLocalisations.of(context).totalPurchasesWithoutPromotionString,
        value: totalItemsWithoutPromotion,
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
        fieldName: GameCollectionLocalisations.of(context).avgPriceWithoutPromotionString,
        value: (totalItemsWithoutPromotion > 0)? priceSum / totalItemsWithoutPromotion : 0,
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
        value: (totalItems > 0)? data.discountSum() / totalItems : 0,
      ),
      statisticsPercentageField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgDiscountWithoutPromotionString,
        value: (totalItemsWithoutPromotion > 0)? data.discountSumWithoutPromotion() / totalItemsWithoutPromotion : 0,
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
      const Divider(),
      _countByYear(context, data),
      const Divider(),
      _countByPrice(context, data),
      const Divider(),
      _sumPriceByYear(context, data),
      const Divider(),
      _sumOriginalPriceByYear(context, data),
    ];

  }

  @override
  List<Widget> statisticsYearFieldsBuilder(BuildContext context, PurchasesData data) {
    final int totalItems = data.length;

    final double priceSum = data.priceSum();
    final double externalCreditSum = data.externalCreditSum();
    final double originalPriceSum = data.originalPriceSum();

    final double savedSum = originalPriceSum - priceSum;

    final int totalItemsWithoutPromotion = data.lengthWithoutPromotion;

    return <Widget>[
      statisticsIntField(
        context,
        fieldName: GameCollectionLocalisations.of(context).totalPurchasesString,
        value: totalItems,
      ),
      statisticsIntField(
        context,
        fieldName: GameCollectionLocalisations.of(context).totalPurchasesWithoutPromotionString,
        value: totalItemsWithoutPromotion,
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
        fieldName: GameCollectionLocalisations.of(context).avgPriceWithoutPromotionString,
        value: (totalItemsWithoutPromotion > 0)? priceSum / totalItemsWithoutPromotion : 0,
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
        value: (totalItems > 0)? data.discountSum() / totalItems : 0,
      ),
      statisticsPercentageField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgDiscountWithoutPromotionString,
        value: (totalItemsWithoutPromotion > 0)? data.discountSumWithoutPromotion() / totalItemsWithoutPromotion : 0,
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
      const Divider(),
      _countByMonth(context, data),
      const Divider(),
      _countByPrice(context, data),
      const Divider(),
      _sumPriceByMonth(context, data),
      const Divider(),
      _sumOriginalPriceByMonth(context, data),
      const Divider(),
      _sumSavedByMonth(context, data),
    ];

  }

  //#region Common
  Widget _countByPrice(BuildContext context, PurchasesData data) {

    final List<double> intervals = <double>[0.0, 5.0, 10.0, 15.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0];
    final List<String> domainLabels = formatIntervalLabelsWithInitialAndLast<double>(
      intervals,
      (double element) => element.toStringAsFixed(0),
    );

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByPriceString,
      domainLabels: domainLabels,
      values: data.intervalPriceCount(intervals),
      vertical: false,
      labelAccessor: (int value) => '$value',
    );
  }
  //#endregion Common

  //#region General
  Widget _countByYear(BuildContext context, PurchasesData data) {

    final List<int> years = data.years;
    final List<String> domainLabels = formatIntervalLabelsEqual<int>(
      years,
      (int element) => GameCollectionLocalisations.of(context).formatYear(element),
    );

    return years.isNotEmpty?
      statisticsHistogram<int>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).countByYearString,
        domainLabels: domainLabels,
        values: data.yearlyCount(years),
        labelAccessor: (int value) => '$value',
      ) : Container();
  }

  Widget _sumPriceByYear(BuildContext context, PurchasesData data) {

    final List<int> years = data.years;
    final List<String> domainLabels = formatIntervalLabelsEqual<int>(
      years,
      (int element) => GameCollectionLocalisations.of(context).formatYear(element),
    );

    return years.isNotEmpty?
      statisticsHistogram<double>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).sumPriceByYearString,
        domainLabels: domainLabels,
        values: data.yearlyPriceSum(years),
        labelAccessor: (double value) => GameCollectionLocalisations.of(context).formatEuro(value),
      ) : Container();
  }

  Widget _sumOriginalPriceByYear(BuildContext context, PurchasesData data) {

    final List<int> years = data.years;
    final List<String> domainLabels = formatIntervalLabelsEqual<int>(
      years,
      (int element) => GameCollectionLocalisations.of(context).formatYear(element),
    );

    return years.isNotEmpty?
      statisticsHistogram<double>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).sumOriginalPriceByYearString,
        domainLabels: domainLabels,
        values: data.yearlyOriginalPriceSum(years),
        labelAccessor: (double value) => GameCollectionLocalisations.of(context).formatEuro(value),
      ) : Container();
  }
  //#endregion General

  //#region Year
  Widget _countByMonth(BuildContext context, PurchasesData data) {

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByMonthString,
      domainLabels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlyCount().values,
      labelAccessor: (int value) => '$value',
    );
  }

  Widget _sumPriceByMonth(BuildContext context, PurchasesData data) {

    return statisticsHistogram<double>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).sumPriceByMonthString,
      domainLabels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlyPriceSum().values,
      labelAccessor: (double value) => GameCollectionLocalisations.of(context).formatEuro(value),
    );
  }

  Widget _sumOriginalPriceByMonth(BuildContext context, PurchasesData data) {

    return statisticsHistogram<double>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).sumOriginalPriceByMonthString,
      domainLabels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlyOriginalPriceSum().values,
      labelAccessor: (double value) => GameCollectionLocalisations.of(context).formatEuro(value),
    );
  }

  Widget _sumSavedByMonth(BuildContext context, PurchasesData data) {

    return statisticsHistogram<double>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).sumSavedByMonthString,
      domainLabels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlySavedSum().values,
      labelAccessor: (double value) => GameCollectionLocalisations.of(context).formatEuro(value),
    );
  }
  //#endregion Year
}