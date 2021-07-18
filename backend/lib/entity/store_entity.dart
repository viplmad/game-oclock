import 'package:backend/model/model.dart';

import 'entity.dart';


class StoreEntityData {
  StoreEntityData._();

  static const String table = 'Store';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String iconField = 'Icon';
}

class StoreEntity extends ItemEntity {
  const StoreEntity({
    required int id,
    required this.name,
    required this.iconFilename,
  }) : super(id: id);

  final String name;
  final String? iconFilename;

  static StoreEntity _fromDynamicMap(Map<String, dynamic> map) {

    return StoreEntity(
      id: map[StoreEntityData.idField] as int,
      name: map[StoreEntityData.nameField] as String,
      iconFilename: map[StoreEntityData.iconField] as String?,
    );

  }

  static List<StoreEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<StoreEntity> storesList = <StoreEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final StoreEntity store = StoreEntity._fromDynamicMap( ItemEntity.combineMaps(manyMap, StoreEntityData.table) );

      storesList.add(store);
    });

    return storesList;

  }

  static int? idFromDynamicMap(List<Map<String, Map<String, dynamic>>> listMap) {
    int? id;

    if(listMap.isNotEmpty) {
      final Map<String, dynamic> map = ItemEntity.combineMaps(listMap.first, StoreEntityData.table);
      id = map[StoreEntityData.idField] as int;
    }

    return id;
  }

  Map<String, dynamic> createMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      StoreEntityData.nameField : name,
    };

    putCreateMapValueNullable(createMap, StoreEntityData.iconField, iconFilename);

    return createMap;

  }

  Map<String, dynamic> updateMap(StoreEntity updatedEntity) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, StoreEntityData.nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, StoreEntityData.iconField, iconFilename, updatedEntity.iconFilename);

    return updateMap;

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