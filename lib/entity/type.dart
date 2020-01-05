import 'package:flutter/material.dart';

import 'entity.dart';
import 'package:game_collection/type_view.dart';

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

  Widget getCard(BuildContext context) {

    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(this.name),
        ),
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