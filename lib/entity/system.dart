import 'package:flutter/material.dart';

import 'entity.dart';
import 'package:game_collection/entity_view/system_view.dart';

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

  static List<System> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<System> systemsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      System system = System.fromDynamicMap(map[systemTable]);

      systemsList.add(system);
    });

    return systemsList;

  }

  @override
  String getFormattedTitle() {

    return this.name;

  }

  @override
  String getFormattedSubtitle() {

    return this.manufacturer;

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
              SystemView(
                system: this,
              )
          ),
        );
      },
    );

  }

}