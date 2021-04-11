import 'entity.dart';


const String tagTable = 'Tag';

const List<String> tagFields = <String>[
  idField,
  tag_nameField,
];

const String tag_nameField = 'Name';

class TagEntity extends CollectionItemEntity {
  const TagEntity({
    required int id,
    required this.name,
  }) : super(id: id);

  final String name;

  static TagEntity fromDynamicMap(Map<String, dynamic> map) {

    return TagEntity(
      id: map[idField] as int,
      name: map[tag_nameField] as String,
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

    final List<TagEntity> tagsList = <TagEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final TagEntity tag = TagEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, tagTable) );

      tagsList.add(tag);
    });

    return tagsList;

  }

  @override
  List<Object> get props => <Object>[
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