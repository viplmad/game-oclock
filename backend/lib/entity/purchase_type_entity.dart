import 'package:backend/model/model.dart';

import 'entity.dart';


class PurchaseTypeEntityData {
  PurchaseTypeEntityData._();

  static const String table = 'Type';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
}

class PurchaseTypeEntity extends CollectionItemEntity {
  const PurchaseTypeEntity({
    required int id,
    required this.name,
  }) : super(id: id);

  final String name;

  static PurchaseTypeEntity _fromDynamicMap(Map<String, dynamic> map) {

    return PurchaseTypeEntity(
      id: map[PurchaseTypeEntityData.idField] as int,
      name: map[PurchaseTypeEntityData.nameField] as String,
    );

  }

  static List<PurchaseTypeEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<PurchaseTypeEntity> typesList = <PurchaseTypeEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final PurchaseTypeEntity type = PurchaseTypeEntity._fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, PurchaseTypeEntityData.table) );

      typesList.add(type);
    });

    return typesList;

  }

  static int? idFromDynamicMap(List<Map<String, Map<String, dynamic>>> listMap) {
    int? id;

    if(listMap.isNotEmpty) {
      final Map<String, dynamic> map = CollectionItemEntity.combineMaps(listMap.first, PurchaseTypeEntityData.table);
      id = map[PurchaseTypeEntityData.idField] as int;
    }

    return id;
  }

  Map<String, dynamic> createMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      PurchaseTypeEntityData.nameField : name,
    };

    return createMap;

  }

  Map<String, dynamic> updateMap(PurchaseTypeEntity updatedEntity, PurchaseTypeUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, PurchaseTypeEntityData.nameField, name, updatedEntity.name);

    return updateMap;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '{$PurchaseTypeEntityData.table}Entity { '
        '{$PurchaseTypeEntityData.idField}: $id, '
        '{$PurchaseTypeEntityData._nameField}: $name'
        ' }';

  }
}