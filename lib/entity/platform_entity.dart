import 'package:meta/meta.dart';

import 'entity.dart';


const String platformTable = "Platform";

const List<String> platformFields = [
  IDField,
  plat_nameField,
  plat_iconField,
  plat_typeField,
];

const String plat_nameField = 'Name';
const String plat_iconField = 'Icon';
const String plat_typeField = 'Type';

const List<String> types = [
  "Physical",
  "Digital",
];

class PlatformEntity extends CollectionItemEntity {

  PlatformEntity({
    @required int id,
    this.name,
    this.iconFilename,
    this.type
  }) : super(id: id);

  final String name;
  final String iconFilename;
  final String type;

  static PlatformEntity fromDynamicMap(Map<String, dynamic> map) {

    return PlatformEntity(
      id: map[IDField],
      name: map[plat_nameField],
      iconFilename: map[plat_iconField],
      type: map[plat_typeField],
    );

  }

  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IDField : id,
      plat_nameField : name,
      plat_iconField : iconFilename,
      plat_typeField : type,
    };

  }

  static List<PlatformEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<PlatformEntity> platformsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      PlatformEntity platform = PlatformEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, platformTable) );

      platformsList.add(platform);
    });

    return platformsList;

  }

  @override
  List<Object> get props => [
    id,
    name,
    iconFilename,
    type,
  ];

  @override
  String toString() {

    return '{$platformTable}Entity { '
        '$IDField: $id, '
        '$plat_nameField: $name, '
        '$plat_iconField: $iconFilename, '
        '$plat_typeField: $type'
        ' }';

  }

}