import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import 'entity.dart';
import 'package:game_collection/entity_view/purchase_view.dart';

const purchaseTable = "Purchase";

const List<String> purchaseFields = [IDField, descriptionField, priceField, externalCreditField, dateField, originalPriceField];

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

  Purchase({@required int ID, this.description, this.price, this.externalCredit,
    this.date, this.originalPrice, this.store}) : super(ID: ID);

  factory Purchase.fromDynamicMap(Map<String, dynamic> map) {

    return Purchase(
      ID: map[IDField],
      description: map[descriptionField],
      price: map[priceField] / 100,
      externalCredit: map[externalCreditField] / 100,
      date: map[dateField],
      originalPrice: map[originalPriceField] / 100,

      store: map[storeField],
    );

  }

  static List<Purchase> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<Purchase> purchasesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      Purchase purchase = Purchase.fromDynamicMap(map[purchaseTable]);

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

}