import 'package:flutter/material.dart';

import 'entity.dart';
import 'package:game_collection/entity_view/platform_view.dart';

const String platformTable = "Platform";

const List<String> platformFields = [IDField, nameField, iconField, typeField];

const String nameField = "Name";
const String iconField = "Icon";
const String typeField = "Type";

List<String> types = [
  "Physical",
  "Digital",
];

class Platform extends Entity {

  String name;
  dynamic icon;
  String type;

  Platform({@required int ID, this.name, this.icon, this.type}) : super(ID: ID);

  factory Platform.fromDynamicMap(Map<String, dynamic> map) {

    return Platform(
      ID: map[IDField],
      name: map[nameField],
      icon: map[iconField],
      type: map[typeField],
    );

  }

  static List<Platform> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<Platform> platformsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      Platform platform = Platform.fromDynamicMap(map[platformTable]);

      platformsList.add(platform);
    });

    return platformsList;

  }

  @override
  String getFormattedTitle() {

    return this.name;

  }

  @override
  Widget entityBuilder(BuildContext context) {

    return PlatformView(
      platform: this,
    );

  }

}