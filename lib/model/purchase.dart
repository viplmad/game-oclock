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

  Purchase({
    @required int id,
    this.description,
    this.price,
    this.externalCredit,
    this.date,
    this.originalPrice,

    this.store,
  }) : super(id: id);

  final String description;
  final double price;
  final double externalCredit;
  final DateTime date;
  final double originalPrice;
  double get discount => this.originalPrice > 0.0? (1 - (this.price + this.externalCredit) / this.originalPrice) * 100 : 0.0;

  final int store;

  @override
  String get uniqueId => 'Pu' + this.id.toString();

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
  PurchasesData(List<Purchase> items) : super(items);

  List<int> years() {

    return (items.map<int>((Purchase item) => item.date?.year).toSet()..removeWhere((int year) => year == null)).toList(growable: false)..sort();

  }

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

  List<int> yearlyCount(List<int> years) {
    List<int> values = List<int>(years.length);

    for(int index = 0; index < years.length; index++) {
      int year = years.elementAt(index);

      int yearSum = items.where((Purchase item) => item.date?.year == year).toList(growable: false).length;

      values[index] = yearSum;
    }

    return values;
  }

  List<double> yearlyPriceSum(List<int> years) {
    List<double> values = List<double>(years.length);

    for(int index = 0; index < years.length; index++) {
      int year = years.elementAt(index);

      List<Purchase> yearItems = items.where((Purchase item) => item.date?.year == year).toList(growable: false);
      double yearSum = yearItems.fold(0.0, (double previousValue, Purchase item) => previousValue + item.price);

      values[index] = yearSum;
    }

    return values;
  }

  List<double> yearlyOriginalPriceSum(List<int> years) {
    List<double> values = List<double>(years.length);

    for(int index = 0; index < years.length; index++) {
      int year = years.elementAt(index);

      List<Purchase> yearItems = items.where((Purchase item) => item.date?.year == year).toList(growable: false);
      double yearSum = yearItems.fold(0.0, (double previousValue, Purchase item) => previousValue + item.originalPrice);

      values[index] = yearSum;
    }

    return values;
  }

  YearData<int> monthlyCount() {
    YearData<int> yearData = YearData<int>();

    for(int month = 1; month <= 12; month++) {

      int monthSum = items.where((Purchase item) => item.date?.month == month).toList(growable: false).length;

      yearData.addData(monthSum);
    }

    return yearData;
  }

  YearData<double> monthlyPriceSum() {
    YearData<double> yearData = YearData<double>();

    for(int month = 1; month <= 12; month++) {

      List<Purchase> monthItems = items.where((Purchase item) => item.date?.month == month).toList(growable: false);
      double monthSum = monthItems.fold(0.0, (double previousValue, Purchase item) => previousValue + item.price);

      yearData.addData(monthSum);
    }

    return yearData;
  }

  YearData<double> monthlyOriginalPriceSum() {
    YearData<double> yearData = YearData<double>();

    for(int month = 1; month <= 12; month++) {

      List<Purchase> monthItems = items.where((Purchase item) => item.date?.month == month).toList(growable: false);
      double monthSum = monthItems.fold(0.0, (double previousValue, Purchase item) => previousValue + item.originalPrice);

      yearData.addData(monthSum);
    }

    return yearData;
  }

  List<int> intervalPriceCountWithInitialAndLast(List<double> intervals) {
    List<int> values = List<int>(intervals.length + 1);

    double initialPrice = intervals.first;
    int initialIntervalCount = items.where((Purchase item) => item.price <= initialPrice).length;
    values[0] = initialIntervalCount;

    for(int index = 0; index < intervals.length - 1; index++) {
      double minPrice = intervals.elementAt(index);
      double maxPrice = intervals.elementAt(index + 1);

      int intervalCount = items.where((Purchase item) => minPrice < item.price  && item.price <= maxPrice).length;

      values[index] = intervalCount;
    }

    double lastPrice = intervals.last;
    int lastIntervalCount = items.where((Purchase item) => lastPrice < item.price).length;
    values[intervals.length] = lastIntervalCount;

    return values;
  }
}