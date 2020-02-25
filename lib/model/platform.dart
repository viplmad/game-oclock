import 'package:meta/meta.dart';

import 'package:game_collection/entity/collection_item_entity.dart';
import 'package:game_collection/entity/platform_entity.dart';

import 'collection_item.dart';


enum PlatformView {
  Main,
  LastCreated,
}

const List<String> platformViews = [
  "Main",
  "Last Created",
];

class Platform extends CollectionItem {

  Platform({
    @required int ID,
    this.name,
    this.iconURL,
    this.type,
  }) : super(ID: ID);

  final String name;
  final String iconURL;
  final String type;

  static Platform fromEntity(PlatformEntity entity, [String iconURL]) {

    return Platform(
      ID: entity.ID,
      name: entity.name,
      iconURL: iconURL,
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
    String iconURL,
    String type,
  }) {

    return Platform(
      ID: ID,
      name: name?? this.name,
      iconURL: iconURL?? this.iconURL,
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
  String getImageURL() {

    return this.iconURL?? '';

  }

  @override
  List<Object> get props => [
    ID,
    name,
    iconURL,
    type,
  ];

  @override
  String toString() {

    return '$platformTable { '
        '$IDField: $ID, '
        '$plat_nameField: $name, '
        '$plat_iconField: $iconURL, '
        '$plat_typeField: $type'
        ' }';

  }

}