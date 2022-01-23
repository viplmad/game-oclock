import 'entity.dart' show ItemEntity;


enum SystemView {
  main,
  lastCreated,
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

  static const String systemManufacturerEnum = 'system_manufacturer';
  static const String nintendoValue = 'Nintendo';
  static const String sonyValue = 'Sony';
  static const String microsoftValue = 'Microsoft';
  static const String segaValue = 'Sega';
}

class SystemID {
  SystemID(this.id);

  final int id;

  @override
  String toString() => '$id';
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

  static SystemEntity fromMap(Map<String, Object?> map) {

    return SystemEntity(
      id: map[SystemEntityData.idField] as int,
      name: map[SystemEntityData.nameField] as String,
      iconFilename: map[SystemEntityData.iconField] as String?,
      generation: map[SystemEntityData.generationField] as int,
      manufacturer: map[SystemEntityData.manufacturerField] as String?,
    );

  }

  static SystemID idFromMap(Map<String, Object?> map) {

    return SystemID(map[SystemEntityData.idField] as int);

  }

  SystemID createId() {

    return SystemID(id);

  }

  Map<String, Object?> createMap() {

    final Map<String, Object?> createMap = <String, Object?>{
      SystemEntityData.nameField : name,
      SystemEntityData.generationField : generation,
    };

    putCreateMapValueNullable(createMap, SystemEntityData.iconField, iconFilename);
    putCreateMapValueNullable(createMap, SystemEntityData.manufacturerField, manufacturer);

    return createMap;

  }

  Map<String, Object?> updateMap(SystemEntity updatedEntity) {

    final Map<String, Object?> updateMap = <String, Object?>{};

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