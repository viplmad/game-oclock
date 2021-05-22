import 'package:backend/model/model.dart';

import 'entity.dart';


const List<String> types = <String>[
  'Physical',
  'Digital',
];

class PlatformEntityData {
  PlatformEntityData._();

  static const String table = 'Platform';

  static const String relationField = table + '_ID';

  static const String _nameField = 'Name';
  static const String _iconField = 'Icon';
  static const String _typeField = 'Type';

  static const String searchField = _nameField;
  static const String imageField = _iconField;

  static const Map<String, Type> fields = <String, Type>{
    idField : int,
    _nameField : String,
    _iconField : String,
    _typeField : String,
  };

  static Map<String, dynamic> getIdMap(int id) {

    return <String, dynamic>{
      idField : id,
    };

  }
}

class PlatformEntity extends CollectionItemEntity {
  const PlatformEntity({
    required int id,
    required this.name,
    required this.iconFilename,
    required this.type,
  }) : super(id: id);

  final String name;
  final String? iconFilename;
  final String? type;

  static PlatformEntity fromDynamicMap(Map<String, dynamic> map) {

    return PlatformEntity(
      id: map[idField] as int,
      name: map[PlatformEntityData._nameField] as String,
      iconFilename: map[PlatformEntityData._iconField] as String?,
      type: map[PlatformEntityData._typeField] as String?,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      idField : id,
      PlatformEntityData._nameField : name,
      PlatformEntityData._iconField : iconFilename,
      PlatformEntityData._typeField : type,
    };

  }

  @override
  Map<String, dynamic> getCreateDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      PlatformEntityData._nameField : name,
    };

    putCreateMapValueNullable(createMap, PlatformEntityData._iconField, iconFilename);
    putCreateMapValueNullable(createMap, PlatformEntityData._typeField, type);

    return createMap;

  }

  Map<String, dynamic> getUpdateDynamicMap(PlatformEntity updatedEntity, PlatformUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, PlatformEntityData._nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, PlatformEntityData._iconField, iconFilename, updatedEntity.iconFilename, updatedValueCanBeNull: updateProperties.iconURLToNull);
    putUpdateMapValueNullable(updateMap, PlatformEntityData._typeField, type, updatedEntity.type, updatedValueCanBeNull: updateProperties.typeToNull);

    return updateMap;

  }

  static List<PlatformEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<PlatformEntity> platformsList = <PlatformEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final PlatformEntity platform = PlatformEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, PlatformEntityData.table) );

      platformsList.add(platform);
    });

    return platformsList;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '{$PlatformEntityData.table}Entity { '
        '$idField: $id, '
        '{$PlatformEntityData._nameField}: $name, '
        '{$PlatformEntityData._iconField}: $iconFilename, '
        '{$PlatformEntityData._typeField}: $type'
        ' }';

  }
}