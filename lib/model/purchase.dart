import 'package:meta/meta.dart';

import 'entity.dart';

const purchaseTable = "Purchase";

const List<String> purchaseFields = [
  IDField,
  descriptionField,
  priceField,
  externalCreditField,
  dateField,
  originalPriceField,
  storeField,
];

const String descriptionField = 'Description';
const String priceField = 'Price';
const String externalCreditField = 'External Credit';
const String dateField = 'Date';
const String originalPriceField = 'Original Price';

const String storeField = 'Store';

class Purchase extends Entity {

  final String description;
  final double price;
  final double externalCredit;
  final DateTime date;
  final double originalPrice;

  final int store;

  Purchase({
    @required int ID,
    this.description,
    this.price,
    this.externalCredit,
    this.date,
    this.originalPrice,

    this.store,
  }) : super(ID: ID);

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
      ID: ID,
      description: description?? this.description,
      price: price?? this.price,
      externalCredit: externalCredit?? this.externalCredit,
      date: date?? this.date,
      originalPrice: originalPrice?? this.originalPrice,

      store: store?? this.store,
    );

  }

  @override
  String getUniqueID() {

    return 'Pu' + this.ID.toString();

  }

  @override
  String getTitle() {

    return this.description;

  }

  @override
  String getSubtitle() {

    return this.price.toString();

  }

  static Purchase fromDynamicMap(Map<String, dynamic> map) {

    return Purchase(
      ID: map[IDField],
      description: map[descriptionField],
      price: map[priceField],
      externalCredit: map[externalCreditField],
      date: map[dateField],
      originalPrice: map[originalPriceField],

      store: map[storeField],
    );

  }

  static List<Purchase> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<Purchase> purchasesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      Map<String, dynamic> _tempFixMap = Map.from(map[purchaseTable]);
      _tempFixMap.addAll(
        map[null],
      );

      Purchase purchase = Purchase.fromDynamicMap(_tempFixMap);
      //Purchase purchase = Purchase.fromDynamicMap(map[purchaseTable]);

      purchasesList.add(purchase);
    });

    return purchasesList;

  }

  @override
  List<Object> get props => [
    ID,
    description,
    price,
    externalCredit,
    date,
    originalPrice,
  ];

  @override
  String toString() {

    return '$purchaseTable { '
        '$IDField: $ID, '
        '$descriptionField: $description, '
        '$priceField: $price, '
        '$externalCreditField: $externalCredit, '
        '$dateField: $date, '
        '$originalPriceField: $originalPrice'
        ' }';

  }

}