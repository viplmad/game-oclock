import 'entity.dart' show ItemEntity;


const String physicalValue = 'Physical';
const String digitalValue = 'Digital';

enum PlatformView {
  Main,
  LastCreated,
}

class PlatformEntityData {
  PlatformEntityData._();

  static const String table = 'Platform';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String iconField = 'Icon';
  static const String typeField = 'Type';
}

class PlatformID {
  PlatformID(this.id);

  final int id;
}

class PlatformEntity extends ItemEntity {
  const PlatformEntity({
    required this.id,
    required this.name,
    required this.iconFilename,
    required this.type,
  });

  final int id;
  final String name;
  final String? iconFilename;
  final String? type;

  static PlatformEntity fromMap(Map<String, Object?> map) {

    return PlatformEntity(
      id: map[PlatformEntityData.idField] as int,
      name: map[PlatformEntityData.nameField] as String,
      iconFilename: map[PlatformEntityData.iconField] as String?,
      type: map[PlatformEntityData.typeField] as String?,
    );

  }

  static PlatformID idFromMap(Map<String, Object?> map) {

    return PlatformID(map[PlatformEntityData.idField] as int);

  }

  PlatformID createId() {

    return PlatformID(id);

  }

  Map<String, Object?> createMap() {

    final Map<String, Object?> createMap = <String, Object?>{
      PlatformEntityData.nameField : name,
    };

    putCreateMapValueNullable(createMap, PlatformEntityData.iconField, iconFilename);
    putCreateMapValueNullable(createMap, PlatformEntityData.typeField, type);

    return createMap;

  }

  Map<String, Object?> updateMap(PlatformEntity updatedEntity) {

    final Map<String, Object?> updateMap = <String, Object?>{};

    putUpdateMapValue(updateMap, PlatformEntityData.nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, PlatformEntityData.iconField, iconFilename, updatedEntity.iconFilename);
    putUpdateMapValueNullable(updateMap, PlatformEntityData.typeField, type, updatedEntity.type);

    return updateMap;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '${PlatformEntityData.table}Entity { '
        '${PlatformEntityData.idField}: $id, '
        '${PlatformEntityData.nameField}: $name, '
        '${PlatformEntityData.iconField}: $iconFilename, '
        '${PlatformEntityData.typeField}: $type'
        ' }';

  }
}