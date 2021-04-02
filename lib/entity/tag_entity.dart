import 'entity.dart';


const String tagTable = 'Tag';

const tagFields = [
  idField,
  tag_nameField,
];

const tag_nameField = 'Name';

class TagEntity extends CollectionItemEntity {
  const TagEntity({
    required int id,
    required this.name,
  }) : super(id: id);

  final String name;

  static TagEntity fromDynamicMap(Map<String, dynamic> map) {

    return TagEntity(
      id: map[idField],
      name: map[tag_nameField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      idField : id,
      tag_nameField : name,
    };

  }

  static List<TagEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<TagEntity> tagsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      TagEntity tag = TagEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, tagTable) );

      tagsList.add(tag);
    });

    return tagsList;

  }

  @override
  List<Object> get props => [
    id,
    name,
  ];

  @override
  String toString() {

    return '{$tagTable}Entity { '
        '$idField: $id, '
        '$tag_nameField: $name'
        ' }';

  }
}