import 'package:flutter/material.dart';

import 'entity.dart';

const String platformTable = "Platform";

const List<String> platformFields = [IDField, nameField, iconField, typeField];

const String nameField = "Name";
const String iconField = "Icon";
const String typeField = "Type";

class Platform extends Entity {

  final String name;
  final dynamic icon;
  final String type;

  Platform({@required int ID, this.name, this.icon, this.type}) : super(ID: ID);

  factory Platform.fromDynamicMap(Map<String, dynamic> map) {

    return Platform(
      ID: map[IDField],
      name: map[nameField],
      icon: map[iconField],
      type: map[typeField],
    );

  }

}