import 'package:flutter/material.dart';

import 'entity.dart';

const String systemTable = "System";

const List<String> systemTables = [IDField, nameField, iconField, generationField,
  manufacturerField];

const String nameField = 'Name';
const String iconField = 'Icon';
const String generationField = 'Generation';
const String manufacturerField = 'Manufacturer';

class System extends Entity {

  final String name;
  final dynamic icon;
  final int generation;
  final String manufacturer;

  System({@required int ID, this.name, this.icon, this.generation, this.manufacturer}) : super(ID: ID);

  factory System.fromDynamicMap(Map<String, dynamic> map) {

    return System(
      ID: map[IDField],
      name: map[nameField],
      icon: map[iconField],
      generation: map[generationField],
      manufacturer: map[manufacturerField],
    );

  }
}