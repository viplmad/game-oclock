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
  ItemImage get image => const ItemImage(null, null);

  @override
  String get queryableTerms => this.name;

  static Tag fromEntity(GameTagEntity entity) {

    return Tag(
      id: entity.id,
      name: entity.name,
    );

  }

  @override
  GameTagEntity toEntity() {

    return GameTagEntity(
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
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return 'Game Tag { '
        'Id: $id, '
        'Name: $name'
        ' }';

  }
}

class GameTagUpdateProperties {

  const GameTagUpdateProperties();
}