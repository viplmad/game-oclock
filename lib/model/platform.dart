import 'package:meta/meta.dart';

import 'package:game_collection/entity/collection_item_entity.dart';
import 'package:game_collection/entity/platform_entity.dart';

import 'collection_item.dart';


class Platform extends CollectionItem {

  Platform({
    @required int ID,
    this.name,
    this.type
  }) : super(ID: ID);

  final String name;
  final String type;

  static Platform fromEntity(PlatformEntity entity) {

    return Platform(
      ID: entity.ID,
      name: entity.name,
      type: entity.type,
    );

  }

  @override
  PlatformEntity toEntity() {

    return PlatformEntity(
      ID: this.ID,
      name: this.name,
      type: this.type,
    );

  }

  @override
  Platform copyWith({
    String name,
    String type,
  }) {

    return Platform(
      ID: ID,
      name: name?? this.name,
      type: type?? this.type,
    );

  }

  @override
  String getUniqueID() {

    return 'Pl' + this.ID.toString();

  }

  @override
  String getTitle() {

    return this.name;

  }

  @override
  List<Object> get props => [
    ID,
    name,
    type,
  ];

  @override
  String toString() {

    return '$platformTable { '
        '$IDField: $ID, '
        '$plat_nameField: $name, '
        '$plat_typeField: $type'
        ' }';

  }

}