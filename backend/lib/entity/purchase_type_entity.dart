import 'package:backend/model/model.dart';
import 'package:backend/utils/query.dart';
import 'package:backend/utils/fields.dart';

import 'entity.dart';


class PurchaseTypeEntityData {
  PurchaseTypeEntityData._();

  static const String table = 'Type';

  static const Map<TypeView, String> viewToTable = <TypeView, String>{
    TypeView.Main : 'Type-Main',
    TypeView.LastCreated : 'Type-Last Created',
  };

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';

  static Fields fields() {

    final Fields fields = Fields();
    fields.add(idField, int);
    fields.add(nameField, String);

    return fields;

  }

  static Query idQuery(int id) {

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

  Map<String, dynamic> createDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      PurchaseTypeEntityData.nameField : name,
    };

    return createMap;

  }

  Map<String, dynamic> updateDynamicMap(PurchaseTypeEntity updatedEntity, PurchaseTypeUpdateProperties updateProperties) {

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