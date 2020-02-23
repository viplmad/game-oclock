import 'package:meta/meta.dart';

import 'collection_item_entity.dart';


const String systemTable = "System";

const List<String> systemTables = [
  IDField,
  sys_nameField,
  sys_iconField,
  sys_generationField,
  sys_manufacturerField,
];

const String sys_nameField = 'Name';
const String sys_iconField = 'Icon';
const String sys_generationField = 'Generation';
const String sys_manufacturerField = 'Manufacturer';

List<String> manufacturers = [
  "Nintendo",
  "Sony",
  "Microsoft",
  "Sega",
];

class SystemEntity extends CollectionItemEntity {

  SystemEntity({
    @required int ID,
    this.name,
    this.iconName,
    this.generation,
    this.manufacturer
  }) : super(ID: ID);

  final String name;
  final String iconName;
  final int generation;
  final String manufacturer;

  static SystemEntity fromDynamicMap(Map<String, dynamic> map) {

    return SystemEntity(
      ID: map[IDField],
      name: map[sys_nameField],
      iconName: map[sys_iconField],
      generation: map[sys_generationField],
      manufacturer: map[sys_manufacturerField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IDField : ID,
      sys_nameField : name,
      sys_iconField : iconName,
      sys_generationField : generation,
      sys_manufacturerField : manufacturer,
    };

  }

  static List<SystemEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<SystemEntity> systemsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      SystemEntity system = SystemEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, systemTable) );

      systemsList.add(system);
    });

    return systemsList;

  }

  @override
  List<Object> get props => [
    ID,
    name,
    iconName,
    generation,
    manufacturer,
  ];

  @override
  String toString() {

    return '{$systemTable}Entity { '
        '$IDField: $ID, '
        '$sys_nameField: $name, '
        '$sys_iconField: $iconName, '
        '$sys_generationField: $generation, '
        '$sys_manufacturerField: $manufacturer'
        ' }';

  }

}