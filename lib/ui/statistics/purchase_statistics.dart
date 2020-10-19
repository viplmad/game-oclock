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
  String fromYearTitle(BuildContext context, int year) => GameCollectionLocalisations.of(context).purchasesFromYearString(year);

  @override
  List<Widget> statisticsGeneralFieldsBuilder(BuildContext context, PurchasesData data) {
    int totalItems = data.length;

    double priceSum = data.priceSum();
    double originalPriceSum = data.originalPriceSum();
    double externalCreditSum = data.externalCreditSum();

    double savedSum = originalPriceSum - priceSum;

    int totalItemsWithoutPromotion = data.lengthWithoutPromotion;

    return [
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
      Divider(),
      _countByYear(context, data),
      Divider(),
      _countByPrice(context, data),
      Divider(),
      _sumPriceByYear(context, data),
      Divider(),
      _sumOriginalPriceByYear(context, data),
    ];

  }

  @override
  List<Widget> statisticsYearFieldsBuilder(BuildContext context, PurchasesData data) {
    int totalItems = data.length;

    double priceSum = data.priceSum();
    double externalCreditSum = data.externalCreditSum();
    double originalPriceSum = data.originalPriceSum();

    double savedSum = originalPriceSum - priceSum;

    int totalItemsWithoutPromotion = data.lengthWithoutPromotion;

    return [
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
      Divider(),
      _countByMonth(context, data),
      Divider(),
      _countByPrice(context, data),
      Divider(),
      _sumPriceByMonth(context, data),
      Divider(),
      _sumOriginalPriceByMonth(context, data),
      Divider(),
      _sumSavedByMonth(context, data),
    ];

  }

  //#region Common
  Widget _countByPrice(BuildContext context, PurchasesData data) {

    List<double> intervals = [0.0, 5.0, 10.0, 15.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0];
    List<String> domainLabels = formatIntervalLabelsWithInitialAndLast<double>(
      intervals,
      (double element) => element.toStringAsFixed(0),
    );

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByPriceString,
      domainLabels: domainLabels,
      values: data.intervalPriceCount(intervals),
      vertical: false,
      labelAccessor: (String domainLabel, int value) => '$value',
    );
  }
  //#endregion Common

  //#region General
  Widget _countByYear(BuildContext context, PurchasesData data) {

    List<int> years = data.years;
    List<String> domainLabels = formatIntervalLabelsEqual<int>(
      years,
      (int element) => GameCollectionLocalisations.of(context).yearString(element),
    );

    return years.isNotEmpty?
      statisticsHistogram<int>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).countByYearString,
        domainLabels: domainLabels,
        values: data.yearlyCount(years),
        labelAccessor: (String domainLabel, int value) => '$value',
      ) : Container();
  }

  Widget _sumPriceByYear(BuildContext context, PurchasesData data) {

    List<int> years = data.years;
    List<String> domainLabels = formatIntervalLabelsEqual<int>(
      years,
      (int element) => GameCollectionLocalisations.of(context).yearString(element),
    );

    return years.isNotEmpty?
      statisticsHistogram<double>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).sumPriceByYearString,
        domainLabels: domainLabels,
        values: data.yearlyPriceSum(years),
        labelAccessor: (String domainLabel, double value) => GameCollectionLocalisations.of(context).euroString(value),
      ) : Container();
  }

  Widget _sumOriginalPriceByYear(BuildContext context, PurchasesData data) {

    List<int> years = data.years;
    List<String> domainLabels = formatIntervalLabelsEqual<int>(
      years,
      (int element) => GameCollectionLocalisations.of(context).yearString(element),
    );

    return years.isNotEmpty?
      statisticsHistogram<double>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).sumOriginalPriceByYearString,
        domainLabels: domainLabels,
        values: data.yearlyOriginalPriceSum(years),
        labelAccessor: (String domainLabel, double value) => GameCollectionLocalisations.of(context).euroString(value),
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
      labelAccessor: (String domainLabel, int value) => '$value',
    );
  }

  Widget _sumPriceByMonth(BuildContext context, PurchasesData data) {

    return statisticsHistogram<double>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).sumPriceByMonthString,
      domainLabels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlyPriceSum().values,
      labelAccessor: (String domainLabel, double value) => GameCollectionLocalisations.of(context).euroString(value),
    );
  }

  Widget _sumOriginalPriceByMonth(BuildContext context, PurchasesData data) {

    return statisticsHistogram<double>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).sumOriginalPriceByMonthString,
      domainLabels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlyOriginalPriceSum().values,
      labelAccessor: (String domainLabel, double value) => GameCollectionLocalisations.of(context).euroString(value),
    );
  }

  Widget _sumSavedByMonth(BuildContext context, PurchasesData data) {

    return statisticsHistogram<double>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).sumSavedByMonthString,
      domainLabels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlySavedSum().values,
      labelAccessor: (String domainLabel, double value) => GameCollectionLocalisations.of(context).euroString(value),
    );
  }
  //#endregion Year
}