import 'entity.dart';


const String typeTable = 'Type';

const List<String> typeFields = <String>[
  idField,
  type_nameField,
];

const String type_nameField = 'Name';

class PurchaseTypeEntity extends CollectionItemEntity {
  const PurchaseTypeEntity({
    required int id,
    required this.name,
  }) : super(id: id);

  final String name;

  static PurchaseTypeEntity fromDynamicMap(Map<String, dynamic> map) {

    return PurchaseTypeEntity(
      id: map[idField] as int,
      name: map[type_nameField] as String,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      idField : id,
      type_nameField : name,
    };

  }

  static List<PurchaseTypeEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<PurchaseTypeEntity> typesList = <PurchaseTypeEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final PurchaseTypeEntity type = PurchaseTypeEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, typeTable) );

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

    return '{$typeTable}Entity { '
        '$idField: $id, '
        '$type_nameField: $name'
        ' }';

  }
}