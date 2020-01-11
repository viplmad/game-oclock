import 'package:flutter/material.dart';

import 'entity.dart';
import 'package:game_collection/entity_view/type_view.dart';

const String typeTable = "Type";

const List<String> typeFields = [IDField, nameField];

const String nameField = 'Name';

class PurchaseType extends Entity{

  final String name;

  PurchaseType({@required int ID, this.name}) : super(ID: ID);

  factory PurchaseType.fromDynamicMap(Map<String, dynamic> map) {

    return PurchaseType(
      ID: map[IDField],
      name: map[nameField],
    );

  }

  static List<PurchaseType> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<PurchaseType> typesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      PurchaseType type = PurchaseType.fromDynamicMap(map[typeTable]);

      typesList.add(type);
    });

    return typesList;

  }

  @override
  String getFormattedTitle() {

    return this.name;

  }

  @override
  Widget getModifyCard(BuildContext context, {Function handleDelete}) {

    return GestureDetector(
      child: Card(
        child: this.getCard(handleDelete: handleDelete),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) =>
              TypeView(
                type: this,
              )
          ),
        );
      },
    );

  }

}