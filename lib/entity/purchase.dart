import 'package:flutter/material.dart';

import 'entity.dart';
import 'package:game_collection/entity_view/purchase_view.dart';

const purchaseTable = "Purchase";
const Color purchaseColour = Colors.lightBlue;

const List<String> purchaseFields = [IDField, descriptionField, priceField, externalCreditField, dateField, originalPriceField, storeField];

const String descriptionField = 'Description';
const String priceField = 'Price';
const String externalCreditField = 'External Credit';
const String dateField = 'Date';
const String originalPriceField = 'Original Price';

const String storeField = 'Store';

class Purchase extends Entity {

  String description;
  double price;
  double externalCredit;
  DateTime date;
  double originalPrice;

  int store;

  Purchase({@required int ID, this.description, this.price, this.externalCredit,
    this.date, this.originalPrice, this.store}) : super(ID: ID);

  factory Purchase.fromDynamicMap(Map<String, dynamic> map) {

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
  String getFormattedTitle() {

    return this.description;

  }

  @override
  String getFormattedSubtitle() {

    return this.price.toString();

  }

  @override
  Widget entityBuilder(BuildContext context) {

    return PurchaseView(
      purchase: this,
    );

  }

  @override
  String getClassID() {

    return 'Pu';

  }

  @override
  Color getColour() {

    return purchaseColour;

  }

}