import 'package:backend/model/model.dart';

import 'entity.dart';


List<String> manufacturers = <String>[
  'Nintendo',
  'Sony',
  'Microsoft',
  'Sega',
];

class SystemEntityData {
  SystemEntityData._();

  static const String table = 'System';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String iconField = 'Icon';
  static const String generationField = 'Generation';
  static const String manufacturerField = 'Manufacturer';
}

class SystemEntity extends CollectionItemEntity {
  const SystemEntity({
    required int id,
    required this.name,
    required this.iconFilename,
    required this.generation,
    required this.manufacturer,
  }) : super(id: id);

  final String name;
  final String? iconFilename;
  final int generation;
  final String? manufacturer;

  static SystemEntity _fromDynamicMap(Map<String, dynamic> map) {

    return SystemEntity(
      id: map[SystemEntityData.idField] as int,
      name: map[SystemEntityData.nameField] as String,
      iconFilename: map[SystemEntityData.iconField] as String?,
      generation: map[SystemEntityData.generationField] as int,
      manufacturer: map[SystemEntityData.manufacturerField] as String?,
    );

  }

  static List<SystemEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<SystemEntity> systemsList = <SystemEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final SystemEntity system = SystemEntity._fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, SystemEntityData.table) );

      systemsList.add(system);
    });

    return systemsList;

  }

  static int? idFromDynamicMap(List<Map<String, Map<String, dynamic>>> listMap) {
    int? id;

    if(listMap.isNotEmpty) {
      final Map<String, dynamic> map = CollectionItemEntity.combineMaps(listMap.first, SystemEntityData.table);
      id = map[SystemEntityData.idField] as int;
    }

    return id;
  }

  Map<String, dynamic> createMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      SystemEntityData.nameField : name,
      SystemEntityData.generationField : generation,
    };

    putCreateMapValueNullable(createMap, SystemEntityData.iconField, iconFilename);
    putCreateMapValueNullable(createMap, SystemEntityData.manufacturerField, manufacturer);

    return createMap;

  }

  Map<String, dynamic> updateMap(SystemEntity updatedEntity, SystemUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, SystemEntityData.nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, SystemEntityData.iconField, iconFilename, updatedEntity.iconFilename, updatedValueCanBeNull: updateProperties.iconURLToNull);
    putUpdateMapValue(updateMap, SystemEntityData.generationField, generation, updatedEntity.generation);
    putUpdateMapValueNullable(updateMap, SystemEntityData.manufacturerField, manufacturer, updatedEntity.manufacturer, updatedValueCanBeNull: updateProperties.manufacturerToNull);

    return updateMap;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '{$SystemEntityData.table}Entity { '
        '{$SystemEntityData.idField}: $id, '
        '{$SystemEntityData.nameField}: $name, '
        '{$SystemEntityData.iconField}: $iconFilename, '
        '{$SystemEntityData.generationField}: $generation, '
        '{$SystemEntityData.manufacturerField}: $manufacturer'
        ' }';

  }
}