import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum TagView {
  Main,
  LastCreated,
}

class Tag extends CollectionItem {

  Tag({
    @required int id,
    this.name
  }) : super(id: id);

  final String name;

  @override
  String get uniqueId => 'Tg' + this.id.toString();

  @override
  final bool hasImage = false;
  @override
  final ItemImage image = null;

  @override
  String get queryableTerms => this.name;

  static Tag fromEntity(TagEntity entity) {

    return Tag(
      id: entity.id,
      name: entity.name,
    );

  }

  @override
  TagEntity toEntity() {

    return TagEntity(
      id: this.id,
      name: this.name,
    );

  }

  @override
  Tag copyWith({
    String name,
  }) {

    return Tag(
      id: id,
      name: name?? this.name,
    );

  }

  @override
  List<Object> get props => [
    id,
    name,
  ];

  @override
  String toString() {

    return '$tagTable { '
        '$IdField: $id, '
        '$tag_nameField: $name'
        ' }';

  }

}

class TagsData {

  TagsData({
    this.tags,
  });

  final List<Tag> tags;

}