import 'package:meta/meta.dart';

import 'collection_item_entity.dart';


const String tagTable = "Tag";

const tagFields = [
  IDField,
  tag_nameField,
];

const tag_nameField = 'Name';

class TagEntity extends CollectionItemEntity {

  TagEntity({
    @required int ID,
    this.name
  }) : super(ID: ID);

  final String name;

  static TagEntity fromDynamicMap(Map<String, dynamic> map) {

    return TagEntity(
      ID: map[IDField],
      name: map[tag_nameField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IDField : ID,
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
    ID,
    name,
  ];

  @override
  String toString() {

    return '{$tagTable}Entity { '
        '$IDField: $ID, '
        '$tag_nameField: $name'
        ' }';

  }

}