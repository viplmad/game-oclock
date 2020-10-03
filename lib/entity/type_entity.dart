import 'package:meta/meta.dart';

import 'entity.dart';


const String typeTable = "Type";

const List<String> typeFields = [
  IDField,
  type_nameField,
];

const String type_nameField = 'Name';

class PurchaseTypeEntity extends CollectionItemEntity {

  PurchaseTypeEntity({
    @required int ID,
    this.name,
  }) : super(ID: ID);

  final String name;

  static PurchaseTypeEntity fromDynamicMap(Map<String, dynamic> map) {

    return PurchaseTypeEntity(
      ID: map[IDField],
      name: map[type_nameField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IDField : ID,
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
    ID,
    name,
  ];

  @override
  String toString() {

    return '{$typeTable}Entity { '
        '$IDField: $ID, '
        '$type_nameField: $name'
        ' }';

  }

}