import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum TagView {
  Main,
  LastCreated,
}

class Tag extends CollectionItem {
  const Tag({
    required int id,
    required this.name,
  }) : this.uniqueId = 'Tg$id',
        super(id: id);

  final String name;

  @override
  final String uniqueId;

  @override
  final bool hasImage = false;
  @override
  ItemImage get image => ItemImage(null, null);

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
    String? name,
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
        '$idField: $id, '
        '$tag_nameField: $name'
        ' }';

  }
}