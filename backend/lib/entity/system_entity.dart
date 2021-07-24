import 'entity.dart' show ItemEntity;


List<String> manufacturers = <String>[
  'Nintendo',
  'Sony',
  'Microsoft',
  'Sega',
];

enum SystemView {
  Main,
  LastCreated,
}

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

class SystemID {
  SystemID(this.id);

  final int id;
}

class SystemEntity extends ItemEntity {
  const SystemEntity({
    required this.id,
    required this.name,
    required this.iconFilename,
    required this.generation,
    required this.manufacturer,
  });

  final int id;
  final String name;
  final String? iconFilename;
  final int generation;
  final String? manufacturer;

  static SystemEntity fromMap(Map<String, dynamic> map) {

    return SystemEntity(
      id: map[SystemEntityData.idField] as int,
      name: map[SystemEntityData.nameField] as String,
      iconFilename: map[SystemEntityData.iconField] as String?,
      generation: map[SystemEntityData.generationField] as int,
      manufacturer: map[SystemEntityData.manufacturerField] as String?,
    );

  }

  static SystemID idFromMap(Map<String, dynamic> map) {

    return SystemID(map[SystemEntityData.idField] as int);

  }

  SystemID createId() {

    return SystemID(id);

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

  Map<String, dynamic> updateMap(SystemEntity updatedEntity) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, SystemEntityData.nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, SystemEntityData.iconField, iconFilename, updatedEntity.iconFilename);
    putUpdateMapValue(updateMap, SystemEntityData.generationField, generation, updatedEntity.generation);
    putUpdateMapValueNullable(updateMap, SystemEntityData.manufacturerField, manufacturer, updatedEntity.manufacturer);

    return updateMap;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '${SystemEntityData.table}Entity { '
        '${SystemEntityData.idField}: $id, '
        '${SystemEntityData.nameField}: $name, '
        '${SystemEntityData.iconField}: $iconFilename, '
        '${SystemEntityData.generationField}: $generation, '
        '${SystemEntityData.manufacturerField}: $manufacturer'
        ' }';

  }
}