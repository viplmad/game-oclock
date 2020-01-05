import 'package:flutter/material.dart';

import 'entity.dart';

const String storeTable = "Store";

const List<String> storeFields = [IDField, nameField, iconField];

const String nameField = 'Name';
const String iconField = 'Icon';

class Store extends Entity {

  final String name;
  final dynamic icon;

  Store({@required int ID, this.name, this.icon}) : super(ID: ID);

  factory Store.fromDynamicMap(Map<String, dynamic> map) {

    return Store(
      ID: map[IDField],
      name: map[nameField],
      icon: map[iconField],
    );

  }
}