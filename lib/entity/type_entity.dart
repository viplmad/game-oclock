import 'package:meta/meta.dart';

import 'entity.dart';


const String typeTable = "Type";

const List<String> typeFields = [
  IdField,
  type_nameField,
];

const String type_nameField = 'Name';

class PurchaseTypeEntity extends CollectionItemEntity {
  const PurchaseTypeEntity({
    @required int id,
    this.name,
  }) : super(id: id);

  final String name;

  static PurchaseTypeEntity fromDynamicMap(Map<String, dynamic> map) {

    return PurchaseTypeEntity(
      id: map[IdField],
      name: map[type_nameField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IdField : id,
      type_nameField : name,
    };

  }

  static List<PurchaseTypeEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<PurchaseTypeEntity> typesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      PurchaseTypeEntity type = PurchaseTypeEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, typeTable) );

      typesList.add(type);
    });

    return typesList;

  }

  @override
  List<Object> get props => [
    id,
    name,
  ];

  @override
  String toString() {

    return '{$typeTable}Entity { '
        '$IdField: $id, '
        '$type_nameField: $name'
        ' }';

  }
}