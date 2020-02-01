import 'package:meta/meta.dart';

import 'entity.dart';

const String storeTable = "Store";

const List<String> storeFields = [
  IDField,
  nameField,
  iconField,
];

const String nameField = 'Name';
const String iconField = 'Icon';

class Store extends Entity {

  final String name;

  Store({
    @required int ID,
    this.name,
  }) : super(ID: ID);

  @override
  Store copyWith({
    String name,
  }) {

    return Store(
      ID: ID,
      name: name?? this.name,
    );

  }

  @override
  String getUniqueID() {

    return 'St' + this.ID.toString();

  }

  @override
  String getTitle() {

    return this.name;

  }

  static Store fromDynamicMap(Map<String, dynamic> map) {

    return Store(
      ID: map[IDField],
      name: map[nameField],
    );

  }

  static List<Store> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<Store> storesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      Store store = Store.fromDynamicMap(map[storeTable]);

      storesList.add(store);
    });

    return storesList;

  }

  @override
  List<Object> get props => [
    ID,
    name,
  ];

  @override
  String toString() {

    return '$storeTable { '
        '$IDField: $ID, '
        '$nameField: $name'
        ' }';

  }

}