import 'entity.dart';


const String storeTable = 'Store';

const List<String> storeFields = [
  idField,
  stor_nameField,
  stor_iconField,
];

const String stor_nameField = 'Name';
const String stor_iconField = 'Icon';

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
      id: map[idField],
      name: map[stor_nameField],
      iconFilename: map[stor_iconField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      idField : id,
      stor_nameField : name,
      stor_iconField : iconFilename,
    };

  }

  static List<StoreEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<StoreEntity> storesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      StoreEntity store = StoreEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, storeTable) );

      storesList.add(store);
    });

    return storesList;

  }

  @override
  List<Object> get props => [
    id,
    name,
  ];

  @override
  String toString() {

    return '{$storeTable}Entity { '
        '$idField: $id, '
        '$stor_nameField: $name, '
        '$stor_iconField: $iconFilename'
        ' }';

  }
}