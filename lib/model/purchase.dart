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

  double getTotalPrice() {
    double value = items.fold(0.0, (double previousValue, Purchase item) => previousValue + item.price);

    return value;
  }

  double getTotalOriginalPrice() {
    double value = items.fold(0.0, (double previousValue, Purchase item) => previousValue + item.originalPrice);

    return value;
  }

  YearData<int> getMonthCount() {
    YearData<int> values = YearData<int>();

    for(int month = 1; month <= 12; month++) {

      int monthSum = items.where((item) => item.date.month == month).length;

      values.addData(monthSum);
    }

    return values;
  }

  YearData<double> getMonthPrice() {
    YearData<double> values = YearData<double>();

    for(int month = 1; month <= 12; month++) {

      List<Purchase> itemsMonth = items.where((Purchase item) => item.date.month == month);
      double monthSum = itemsMonth.fold(0, (double previousValue, Purchase item) => previousValue + item.price);

      values.addData(monthSum);
    }

    return values;
  }

  List<int> getIntervalPrice(List<int> intervals) {
    List<int> values = List<int>(intervals.length);

    for(int index = 0; index < intervals.length; index++) {
      int minPrice = intervals.elementAt(index);

      int maxPrice = 10000;
      if(intervals.length != index + 1) {
        maxPrice = intervals.elementAt(index + 1);
      }

      int intervalSum = items.where((Purchase item) => item.price >= minPrice && item.price < maxPrice).length;

      values[index] = intervalSum;
    }

    return values;
  }
}