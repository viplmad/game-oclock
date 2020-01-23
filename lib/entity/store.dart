import 'package:flutter/material.dart';

import 'entity.dart';
import 'package:game_collection/entity_view/store_view.dart';

const String storeTable = "Store";

const List<String> storeFields = [IDField, nameField, iconField];

const String nameField = 'Name';
const String iconField = 'Icon';

class Store extends Entity {

  String name;
  dynamic icon;

  Store({@required int ID, this.name, this.icon}) : super(ID: ID);

  factory Store.fromDynamicMap(Map<String, dynamic> map) {

    return Store(
      ID: map[IDField],
      name: map[nameField],
      icon: map[iconField],
    );

  }

  static List<Store> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<Store> storesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      Store store = Store.fromDynamicMap(map[storeTable]);

      storesList.add(store);
    });

    return storesList;

  }

  @override
  String getFormattedTitle() {

    return this.name;

  }

  @override
  Widget entityBuilder(BuildContext context) {

    return StoreView(
      store: this,
    );

  }

}