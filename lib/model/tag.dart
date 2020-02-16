import 'package:meta/meta.dart';

import 'package:game_collection/entity/collection_item_entity.dart';
import 'package:game_collection/entity/tag_entity.dart';

import 'collection_item.dart';


enum TagView {
  Main,
}

const List<String> tagViews = [
  "Main",
];

class Tag extends CollectionItem {

  Tag({
    @required int ID,
    this.name
  }) : super(ID: ID);

  final String name;

  static Tag fromEntity(TagEntity entity) {

    return Tag(
      ID: entity.ID,
      name: entity.name,
    );

  }

  @override
  TagEntity toEntity() {

    return TagEntity(
      ID: this.ID,
      name: this.name,
    );

  }

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

  @override
  List<Object> get props => [
    ID,
    name,
  ];

  @override
  String toString() {

    return '$tagTable { '
        '$IDField: $ID, '
        '$tag_nameField: $name'
        ' }';

  }

}