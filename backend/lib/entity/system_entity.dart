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

  static const String _nameField = 'Name';
  static const String _iconField = 'Icon';
  static const String _generationField = 'Generation';
  static const String _manufacturerField = 'Manufacturer';

  static const String searchField = _nameField;
  static const String imageField = _iconField;

  static const Map<String, Type> fields = <String, Type>{
    idField : int,
    _nameField : String,
    _iconField : String,
    _generationField : int,
    _manufacturerField : String,
  };

  static Map<String, dynamic> getIdMap(int id) {

    return <String, dynamic>{
      idField : id,
    };

  }
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

  static SystemEntity fromDynamicMap(Map<String, dynamic> map) {

    return SystemEntity(
      id: map[idField] as int,
      name: map[SystemEntityData._nameField] as String,
      iconFilename: map[SystemEntityData._iconField] as String?,
      generation: map[SystemEntityData._generationField] as int,
      manufacturer: map[SystemEntityData._manufacturerField] as String?,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      idField : id,
      SystemEntityData._nameField : name,
      SystemEntityData._iconField : iconFilename,
      SystemEntityData._generationField : generation,
      SystemEntityData._manufacturerField : manufacturer,
    };

  }

  @override
  Map<String, dynamic> getCreateDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      SystemEntityData._nameField : name,
      SystemEntityData._generationField : generation,
    };

    putCreateMapValueNullable(createMap, SystemEntityData._iconField, iconFilename);
    putCreateMapValueNullable(createMap, SystemEntityData._manufacturerField, manufacturer);

    return createMap;

  }

  Map<String, dynamic> getUpdateDynamicMap(SystemEntity updatedEntity, SystemUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, SystemEntityData._nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, SystemEntityData._iconField, iconFilename, updatedEntity.iconFilename, updatedValueCanBeNull: updateProperties.iconURLToNull);
    putUpdateMapValue(updateMap, SystemEntityData._generationField, generation, updatedEntity.generation);
    putUpdateMapValueNullable(updateMap, SystemEntityData._manufacturerField, manufacturer, updatedEntity.manufacturer, updatedValueCanBeNull: updateProperties.manufacturerToNull);

    return updateMap;

  }

  static List<SystemEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<SystemEntity> systemsList = <SystemEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final SystemEntity system = SystemEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, SystemEntityData.table) );

      systemsList.add(system);
    });

    return systemsList;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '{$SystemEntityData.table}Entity { '
        '$idField: $id, '
        '{$SystemEntityData._nameField}: $name, '
        '{$SystemEntityData._iconField}: $iconFilename, '
        '{$SystemEntityData._generationField}: $generation, '
        '{$SystemEntityData._manufacturerField}: $manufacturer'
        ' }';

  }
}