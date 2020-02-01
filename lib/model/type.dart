import 'package:meta/meta.dart';

import 'entity.dart';

const String typeTable = "Type";

const List<String> typeFields = [
  IDField,
  nameField,
];

const String nameField = 'Name';

class PurchaseType extends Entity{

  final String name;

  PurchaseType({
    @required int ID,
    this.name,
  }) : super(ID: ID);

  @override
  PurchaseType copyWith({
    String name,
  }) {

    return PurchaseType(
      ID: ID,
      name: name?? this.name,
    );

  }

  @override
  String getUniqueID() {

    return 'Ty' + this.ID.toString();

  }

  @override
  String getTitle() {

    return this.name;

  }

  static PurchaseType fromDynamicMap(Map<String, dynamic> map) {

    return PurchaseType(
      ID: map[IDField],
      name: map[nameField],
    );

  }

  static List<PurchaseType> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<PurchaseType> typesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      PurchaseType type = PurchaseType.fromDynamicMap(map[typeTable]);

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

    return '$typeTable { '
        '$IDField: $ID, '
        '$nameField: $name'
        ' }';

  }

}