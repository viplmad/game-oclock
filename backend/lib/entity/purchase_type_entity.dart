import 'package:backend/model/model.dart';
import 'package:backend/query/query.dart';

import 'entity.dart';


class PurchaseTypeEntityData {
  PurchaseTypeEntityData._();

  static const String table = 'Type';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';

  static const Map<String, Type> fields = <String, Type>{
    idField : int,
    nameField : String,
  };

  static Query getIdQuery(int id) {

    final Query idQuery = Query();
    idQuery.addAnd(idField, id);

    return idQuery;

  }
}

class PurchaseTypeEntity extends CollectionItemEntity {
  const PurchaseTypeEntity({
    required int id,
    required this.name,
  }) : super(id: id);

  final String name;

  static PurchaseTypeEntity fromDynamicMap(Map<String, dynamic> map) {

    return PurchaseTypeEntity(
      id: map[PurchaseTypeEntityData.idField] as int,
      name: map[PurchaseTypeEntityData.nameField] as String,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      PurchaseTypeEntityData.idField : id,
      PurchaseTypeEntityData.nameField : name,
    };

  }

  @override
  Map<String, dynamic> getCreateDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      PurchaseTypeEntityData.nameField : name,
    };

    return createMap;

  }

  Map<String, dynamic> getUpdateDynamicMap(PurchaseTypeEntity updatedEntity, PurchaseTypeUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, PurchaseTypeEntityData.nameField, name, updatedEntity.name);

    return updateMap;

  }

  static List<PurchaseTypeEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<PurchaseTypeEntity> typesList = <PurchaseTypeEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final PurchaseTypeEntity type = PurchaseTypeEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, PurchaseTypeEntityData.table) );

      typesList.add(type);
    });

    return typesList;

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