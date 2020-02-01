import 'package:meta/meta.dart';

import 'entity.dart';

const String tagTable = "Tag";

const tagFields = [
  IDField,
  nameField,
];

const nameField = 'Name';

class Tag extends Entity {

  final String name;

  Tag({
    @required int ID,
    this.name
  }) : super(ID: ID);

  @override
  Tag copyWith({
    String name,
  }) {

    return Tag(
      ID: ID,
      name: name?? this.name,
    );

  }

  @override
  String getUniqueID() {

    return 'Tg' + this.ID.toString();

  }

  @override
  String getTitle() {

    return this.name;

  }

  static Tag fromDynamicMap(Map<String, dynamic> map) {

    return Tag(
      ID: map[IDField],
      name: map[nameField],
    );

  }

  static List<Tag> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<Tag> tagsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      Tag tag = Tag.fromDynamicMap(map[tagTable]);

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

    return '$tagTable { '
        '$IDField: $ID, '
        '$nameField: $name'
        ' }';

  }

}