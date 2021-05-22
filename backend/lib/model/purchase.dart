import 'package:backend/entity/entity.dart';

import 'model.dart';


enum PurchaseView {
  Main,
  LastCreated,
  Pending,
  LastPurchased,
  Review,
}

class Purchase extends CollectionItem {
  const Purchase({
    required int id,
    required this.description,
    required this.price,
    required this.externalCredit,
    required this.date,
    required this.originalPrice,

    required this.store,
  }) : this.uniqueId = 'Pu$id',
       this.discount = originalPrice > 0? (1 - (price + externalCredit) / originalPrice) : 0,
        super(id: id);

  final String description;
  final double price;
  final double externalCredit;
  final DateTime? date;
  final double originalPrice;
  final double discount;

  final int? store;

  @override
  final String uniqueId;

  @override
  final bool hasImage = false;
  @override
  ItemImage get image => const ItemImage(null, null);

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
    String? description,
    double? price,
    double? externalCredit,
    DateTime? date,
    double? originalPrice,

    int? store,
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
  List<Object> get props => <Object>[
    id,
    description,
    price,
    externalCredit,
    date?? DateTime(1970),
    originalPrice,
  ];

  @override
  String toString() {

    return 'Purchase { '
        'Id: $id, '
        'Description: $description, '
        'Price: $price, '
        'External Credit: $externalCredit, '
        'Date: $date, '
        'Original Price: $originalPrice'
        ' }';

  }
}

class PurchasesData extends ItemData<Purchase> {
  PurchasesData(List<Purchase> items)
      : this.itemsWithoutPromotion = items.where((Purchase item) => item.price > 0).toList(growable: false),
        this.years = (items.map<int>((Purchase item) => item.date?.year?? -1).toSet()..removeWhere((int year) => year == -1)).toList(growable: false)..sort(),
        super(items);

  final List<Purchase> itemsWithoutPromotion;
  final List<int> years;

  int get lengthWithoutPromotion => itemsWithoutPromotion.length;

  double priceSum() {
    final double priceSum = items.fold(0.0, (double previousValue, Purchase item) => previousValue + item.price);

    return priceSum;
  }

  double externalCreditSum() {
    final double externalCreditSum = items.fold(0.0, (double previousValue, Purchase item) => previousValue + item.externalCredit);

    return externalCreditSum;
  }

  double originalPriceSum() {
    final double originalPriceSum = items.fold(0.0, (double previousValue, Purchase item) => previousValue + item.originalPrice);

    return originalPriceSum;
  }

  double discountSum() {
    final double discountSum = items.fold(0.0, (double previousValue, Purchase item) => previousValue + item.discount);

    return discountSum;
  }

  double discountSumWithoutPromotion() {
    final double discountSum = itemsWithoutPromotion.fold(0.0, (double previousValue, Purchase item) => previousValue + item.discount);

    return discountSum;
  }

  List<int> yearlyCount(List<int> years) {

    return yearlyItemCount(
      years,
      (Purchase item, int year) => item.date?.year == year,
    );

  }

  List<double> yearlyPriceSum(List<int> years) {

    return yearlyFieldSum<double>(
      years,
      (Purchase item, int year) => item.date?.year == year,
      0.0,
      (Purchase item) => item.price,
    );

  }

  List<double> yearlyOriginalPriceSum(List<int> years) {

    return yearlyFieldSum<double>(
      years,
      (Purchase item, int year) => item.date?.year == year,
      0.0,
      (Purchase item) => item.originalPrice,
    );

  }

  YearData<int> monthlyCount() {

    return monthlyItemCount(
      (Purchase item, int month) => item.date?.month == month,
    );

  }

  YearData<double> monthlyPriceSum() {

    return monthlyFieldSum<double>(
      (Purchase item, int month) => item.date?.month == month,
      0.0,
      (Purchase item) => item.price,
    );

  }

  YearData<double> monthlyOriginalPriceSum() {

    return monthlyFieldSum<double>(
      (Purchase item, int month) => item.date?.month == month,
      0.0,
      (Purchase item) => item.originalPrice,
    );

  }

  YearData<double> monthlySavedSum() {

    return monthlyFieldSum<double>(
      (Purchase item, int month) => item.date?.month == month,
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

class PurchaseUpdateProperties {
  final bool dateToNull;

  const PurchaseUpdateProperties({
    this.dateToNull = false,
  });
}