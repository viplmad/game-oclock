import 'package:meta/meta.dart';

import 'collection_item_entity.dart';


const String platformTable = "Platform";

const List<String> platformFields = [
  IDField,
  plat_nameField,
  plat_typeField,
];

const String plat_nameField = "Name";
const String plat_typeField = "Type";

List<String> types = [
  "Physical",
  "Digital",
];

class PlatformEntity extends CollectionItemEntity {

  PlatformEntity({
    @required int ID,
    this.name,
    this.type
  }) : super(ID: ID);

  final String name;
  final String type;

  static PlatformEntity fromDynamicMap(Map<String, dynamic> map) {

    return PlatformEntity(
      ID: map[IDField],
      name: map[plat_nameField],
      type: map[plat_typeField],
    );

  }

  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IDField : ID,
      plat_nameField : name,
      plat_typeField : type,
    };

  }

  static List<PlatformEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<PlatformEntity> platformsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      PlatformEntity platform = PlatformEntity.fromDynamicMap(map[platformTable]);

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

    return '{$platformTable}Entity { '
        '$IDField: $ID, '
        '$plat_nameField: $name, '
        '$plat_typeField: $type'
        ' }';

  }

}