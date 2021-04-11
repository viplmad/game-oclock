import 'entity.dart';


const String storeTable = 'Store';

const List<String> storeFields = <String>[
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
      id: map[idField] as int,
      name: map[stor_nameField] as String,
      iconFilename: map[stor_iconField] as String?,
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

    final List<StoreEntity> storesList = <StoreEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final StoreEntity store = StoreEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, storeTable) );

      storesList.add(store);
    });

    return storesList;

  }

  @override
  List<Object> get props => <Object>[
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