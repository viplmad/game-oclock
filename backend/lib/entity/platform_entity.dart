import 'package:backend/model/model.dart';
import 'package:backend/query/query.dart';

import 'entity.dart';


const List<String> types = <String>[
  'Physical',
  'Digital',
];

class PlatformEntityData {
  PlatformEntityData._();

  static const String table = 'Platform';

  static const Map<PlatformView, String> viewToTable = <PlatformView, String>{
    PlatformView.Main : 'Platform-Main',
    PlatformView.LastCreated : 'Platform-Last Created',
  };

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String _iconField = 'Icon';
  static const String _typeField = 'Type';

  static const String imageField = _iconField;

  static const Map<String, Type> fields = <String, Type>{
    idField : int,
    nameField : String,
    _iconField : String,
    _typeField : String,
  };

  static Query getIdQuery(int id) {

    final Query idQuery = Query();
    idQuery.addAnd(idField, id);

    return idQuery;

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

  static PlatformEntity _fromDynamicMap(Map<String, dynamic> map) {

    return PlatformEntity(
      id: map[PlatformEntityData.idField] as int,
      name: map[PlatformEntityData.nameField] as String,
      iconFilename: map[PlatformEntityData._iconField] as String?,
      type: map[PlatformEntityData._typeField] as String?,
    );

  }

  static List<PlatformEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<PlatformEntity> platformsList = <PlatformEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final PlatformEntity platform = PlatformEntity._fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, PlatformEntityData.table) );

      platformsList.add(platform);
    });

    return platformsList;

  }

  Map<String, dynamic> createDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      PlatformEntityData.nameField : name,
    };

    putCreateMapValueNullable(createMap, PlatformEntityData._iconField, iconFilename);
    putCreateMapValueNullable(createMap, PlatformEntityData._typeField, type);

    return createMap;

  }

  Map<String, dynamic> updateDynamicMap(PlatformEntity updatedEntity, PlatformUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, PlatformEntityData.nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, PlatformEntityData._iconField, iconFilename, updatedEntity.iconFilename, updatedValueCanBeNull: updateProperties.iconURLToNull);
    putUpdateMapValueNullable(updateMap, PlatformEntityData._typeField, type, updatedEntity.type, updatedValueCanBeNull: updateProperties.typeToNull);

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