import 'package:meta/meta.dart';

import 'entity.dart';

const String platformTable = "Platform";

const List<String> platformFields = [
  IDField,
  nameField,
  iconField,
  typeField,
];

const String nameField = "Name";
const String iconField = "Icon";
const String typeField = "Type";

List<String> types = [
  "Physical",
  "Digital",
];

class Platform extends Entity {

  final String name;
  final String type;

  Platform({
    @required int ID,
    this.name,
    this.type
  }) : super(ID: ID);

  @override
  Platform copyWith({
    String name,
    String type,
  }) {

    return Platform(
      ID: ID,
      name: name?? this.name,
      type: type?? this.type,
    );

  }

  @override
  String getUniqueID() {

    return 'Pl' + this.ID.toString();

  }

  @override
  String getTitle() {

    return this.name;

  }

  static Platform fromDynamicMap(Map<String, dynamic> map) {

    return Platform(
      ID: map[IDField],
      name: map[nameField],
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
  List<Object> get props => [
    ID,
    name,
    type,
  ];

  @override
  String toString() {

    return '$platformTable { '
        '$IDField: $ID, '
        '$nameField: $name, '
        '$typeField: $type'
        ' }';

  }

}