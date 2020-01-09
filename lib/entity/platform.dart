import 'package:flutter/material.dart';

import 'entity.dart';
import 'package:game_collection/entity_view/platform_view.dart';

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

  static List<Platform> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<Platform> platformsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      Platform platform = Platform.fromDynamicMap(map[platformTable]);

      platformsList.add(platform);
    });

    return platformsList;

  }

  @override
  Widget getEssentialInfo({Function handleDelete}) {
    return ListTile(
      title: Text(this.name),
      trailing: FlatButton(
        child: Text("Delete", style: TextStyle(color: Colors.white),),
        color: Colors.red,
        onPressed: handleDelete,
      ),
    );
  }

  @override
  Widget getCard(BuildContext context, {Function handleDelete}) {

    return GestureDetector(
      child: Card(
        child: this.getEssentialInfo(handleDelete: handleDelete),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) =>
              PlatformView(
                platform: this,
              )
          ),
        );
      },
    );

  }

}