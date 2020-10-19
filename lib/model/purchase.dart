import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum PurchaseView {
  Main,
  LastCreated,
  Pending,
  LastPurchased,
  Review2019,
}

class Purchase extends CollectionItem {
  const Purchase({
    @required int id,
    this.description,
    this.price,
    this.externalCredit,
    this.date,
    this.originalPrice,

    this.store,
  }) : this.uniqueId = 'Pu$id',
       this.discount = originalPrice > 0? (1 - (price + externalCredit) / originalPrice) : 0,
        super(id: id);

  final String description;
  final double price;
  final double externalCredit;
  final DateTime date;
  final double originalPrice;
  final double discount;

  final int store;

  @override
  final String uniqueId;

  @override
  final bool hasImage = false;
  @override
  final ItemImage image = null;

  @override
  String get queryableTerms => this.description;

  static Purchase fromEntity(PurchaseEntity entity) {

    return Purchase(
      id: entity.id,
      description: entity.description,
      price: entity.price,
      externalCredit: entity.externalCredit,
      date: entity.date,
      originalPrice: entity.originalPrice,

      store: entity.store,
    );

  }

  @override
  PurchaseEntity toEntity() {

    return PurchaseEntity(
      id: this.id,
      description: this.description,
      price: this.price,
      externalCredit: this.externalCredit,
      date: this.date,
      originalPrice: this.originalPrice,

      store: this.store,
    );

  }

  @override
  Purchase copyWith({
    String description,
    double price,
    double externalCredit,
    DateTime date,
    double originalPrice,

    int store,
  }) {

    return Purchase(
      id: id,
      description: description?? this.description,
      price: price?? this.price,
      externalCredit: externalCredit?? this.externalCredit,
      date: date?? this.date,
      originalPrice: originalPrice?? this.originalPrice,

      store: store?? this.store,
    );

  }

  @override
  List<Object> get props => [
    id,
    description,
    price,
    externalCredit,
    date,
    originalPrice,
  ];

  @override
  String toString() {

    return '$purchaseTable { '
        '$IdField: $id, '
        '$purc_descriptionField: $description, '
        '$purc_priceField: $price, '
        '$purc_externalCreditField: $externalCredit, '
        '$purc_dateField: $date, '
        '$purc_originalPriceField: $originalPrice'
        ' }';

  }
}

class PurchasesData extends ItemData<Purchase> {
  PurchasesData(List<Purchase> items)
      : this.itemsWithoutPromotion = items.where((Purchase item) => item.price > 0).toList(growable: false),
        this.years = (items.map<int>((Purchase item) => item.date?.year).toSet()..removeWhere((int year) => year == null)).toList(growable: false)..sort(),
        super(items);

  final List<Purchase> itemsWithoutPromotion;
  final List<int> years;

  int get lengthWithoutPromotion => itemsWithoutPromotion.length;

  double priceSum() {
    double priceSum = items.fold(0.0, (double previousValue, Purchase item) => previousValue + item.price);

    return priceSum;
  }

  double externalCreditSum() {
    double externalCreditSum = items.fold(0.0, (double previousValue, Purchase item) => previousValue + item.externalCredit);

    return externalCreditSum;
  }

  double originalPriceSum() {
    double originalPriceSum = items.fold(0.0, (double previousValue, Purchase item) => previousValue + item.originalPrice);

    return originalPriceSum;
  }

  double discountSum() {
    double discountSum = items.fold(0.0, (double previousValue, Purchase item) => previousValue + item.discount);

    return discountSum;
  }

  double discountSumWithoutPromotion() {
    double discountSum = itemsWithoutPromotion.fold(0.0, (double previousValue, Purchase item) => previousValue + item.discount);

    return discountSum;
  }

  List<int> yearlyCount(List<int> years) {

    return yearlyItemCount(
      years,
      (Purchase item) => item.date?.year,
    );

  }

  List<double> yearlyPriceSum(List<int> years) {

    return yearlyFieldSum<double>(
      years,
      (Purchase item) => item.date?.year,
      0.0,
      (Purchase item) => item.price,
    );

  }

  List<double> yearlyOriginalPriceSum(List<int> years) {

    return yearlyFieldSum<double>(
      years,
      (Purchase item) => item.date?.year,
      0.0,
      (Purchase item) => item.originalPrice,
    );

  }

  YearData<int> monthlyCount() {

    return monthlyItemCount(
      (Purchase item) => item.date?.month,
    );

  }

  YearData<double> monthlyPriceSum() {

    return monthlyFieldSum<double>(
      (Purchase item) => item.date?.month,
      0.0,
      (Purchase item) => item.price,
    );

  }

  YearData<double> monthlyOriginalPriceSum() {

    return monthlyFieldSum<double>(
      (Purchase item) => item.date?.month,
      0.0,
      (Purchase item) => item.originalPrice,
    );

  }

  YearData<double> monthlySavedSum() {

    return monthlyFieldSum<double>(
      (Purchase item) => item.date?.month,
      0.0,
      (Purchase item) => item.originalPrice - item.price,
      sumOperation: (double monthSum, int length) => (length > 0)? monthSum / length : 0,
    );

  }

  List<int> intervalPriceCount(List<double> intervals) {

    return intervalCountWithInitialAndLast<double>(
      intervals,
      (Purchase item) => item.price,
    );

  }
}