import 'package:backend/model/model.dart';
import 'package:backend/query/query.dart';

import 'entity.dart';


class StoreEntityData {
  StoreEntityData._();

  static const String table = 'Store';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String _iconField = 'Icon';

  static const String imageField = _iconField;

  static const Map<String, Type> fields = <String, Type>{
    idField : int,
    nameField : String,
    _iconField : String,
  };

  static Query getIdQuery(int id) {

    final Query idQuery = Query();
    idQuery.addAnd(idField, id);

    return idQuery;

  }
}

class StoreEntity extends CollectionItemEntity {
  const StoreEntity({
    required int id,
    required this.name,
    required this.iconFilename,
  }) : super(id: id);

  final String name;
  final String? iconFilename;

  static StoreEntity fromDynamicMap(Map<String, dynamic> map) {

    return StoreEntity(
      id: map[StoreEntityData.idField] as int,
      name: map[StoreEntityData.nameField] as String,
      iconFilename: map[StoreEntityData._iconField] as String?,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      StoreEntityData.idField : id,
      StoreEntityData.nameField : name,
      StoreEntityData._iconField : iconFilename,
    };

  }

  @override
  Map<String, dynamic> getCreateDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      StoreEntityData.nameField : name,
    };

    putCreateMapValueNullable(createMap, StoreEntityData._iconField, iconFilename);

    return createMap;

  }

  Map<String, dynamic> getUpdateDynamicMap(StoreEntity updatedEntity, StoreUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, StoreEntityData.nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, StoreEntityData._iconField, iconFilename, updatedEntity.iconFilename, updatedValueCanBeNull: updateProperties.iconURLToNull);

    return updateMap;

  }

  static List<StoreEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<StoreEntity> storesList = <StoreEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final StoreEntity store = StoreEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, StoreEntityData.table) );

      storesList.add(store);
    });

    return storesList;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '{$StoreEntityData.table}Entity { '
        '{$StoreEntityData.idField}: $id, '
        '{$StoreEntityData._nameField}: $name, '
        '{$StoreEntityData._iconField}: $iconFilename'
        ' }';

  }
}