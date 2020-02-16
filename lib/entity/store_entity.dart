import 'package:meta/meta.dart';

import 'collection_item_entity.dart';


const String storeTable = "Store";

const List<String> storeFields = [
  IDField,
  stor_nameField,
];

const String stor_nameField = 'Name';

class StoreEntity extends CollectionItemEntity {

  StoreEntity({
    @required int ID,
    this.name,
  }) : super(ID: ID);

  final String name;

  static StoreEntity fromDynamicMap(Map<String, dynamic> map) {

    return StoreEntity(
      ID: map[IDField],
      name: map[stor_nameField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IDField : ID,
      stor_nameField : name,
    };

  }

  static List<StoreEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<StoreEntity> storesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      StoreEntity store = StoreEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap) );

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

    return '{$storeTable}Entity { '
        '$IDField: $ID, '
        '$stor_nameField: $name'
        ' }';

  }

}