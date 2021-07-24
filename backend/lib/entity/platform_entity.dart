import 'entity.dart' show ItemEntity;


const List<String> types = <String>[
  'Physical',
  'Digital',
];

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

  static PlatformEntity fromMap(Map<String, dynamic> map) {

    return PlatformEntity(
      id: map[PlatformEntityData.idField] as int,
      name: map[PlatformEntityData.nameField] as String,
      iconFilename: map[PlatformEntityData.iconField] as String?,
      type: map[PlatformEntityData.typeField] as String?,
    );

  }

  static PlatformID idFromMap(Map<String, dynamic> map) {

    return PlatformID(map[PlatformEntityData.idField] as int);

  }

  PlatformID createId() {

    return PlatformID(id);

  }

  Map<String, dynamic> createMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      PlatformEntityData.nameField : name,
    };

    putCreateMapValueNullable(createMap, PlatformEntityData.iconField, iconFilename);
    putCreateMapValueNullable(createMap, PlatformEntityData.typeField, type);

    return createMap;

  }

  Map<String, dynamic> updateMap(PlatformEntity updatedEntity) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

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