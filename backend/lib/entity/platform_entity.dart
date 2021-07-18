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

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String iconField = 'Icon';
  static const String typeField = 'Type';
}

class PlatformEntity extends ItemEntity {
  const PlatformEntity({
    required int id,
    required this.name,
    required this.iconFilename,
    required this.type,
  }) : super(id: id);

  final String name;
  final String? iconFilename;
  final String? type;

  static PlatformEntity _fromDynamicMap(Map<String, dynamic> map) {

    return PlatformEntity(
      id: map[PlatformEntityData.idField] as int,
      name: map[PlatformEntityData.nameField] as String,
      iconFilename: map[PlatformEntityData.iconField] as String?,
      type: map[PlatformEntityData.typeField] as String?,
    );

  }

  static List<PlatformEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<PlatformEntity> platformsList = <PlatformEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final PlatformEntity platform = PlatformEntity._fromDynamicMap( ItemEntity.combineMaps(manyMap, PlatformEntityData.table) );

      platformsList.add(platform);
    });

    return platformsList;

  }

  static int? idFromDynamicMap(List<Map<String, Map<String, dynamic>>> listMap) {
    int? id;

    if(listMap.isNotEmpty) {
      final Map<String, dynamic> map = ItemEntity.combineMaps(listMap.first, PlatformEntityData.table);
      id = map[PlatformEntityData.idField] as int;
    }

    return id;
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

    return '{$PlatformEntityData.table}Entity { '
        '{$PlatformEntityData.idField}: $id, '
        '{$PlatformEntityData._nameField}: $name, '
        '{$PlatformEntityData._iconField}: $iconFilename, '
        '{$PlatformEntityData._typeField}: $type'
        ' }';

  }
}