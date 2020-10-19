import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum PlatformView {
  Main,
  LastCreated,
}

class Platform extends CollectionItem {
  const Platform({
    @required int id,
    this.name,
    this.iconURL,
    this.iconFilename,
    this.type,
  }) : this.uniqueId = 'Pl$id',
        super(id: id);

  final String name;
  final String iconURL;
  final String iconFilename;
  final String type;

  @override
  final String uniqueId;

  @override
  final bool hasImage = true;
  @override
  ItemImage get image => ItemImage(this.iconURL, this.iconFilename);

  @override
  String get queryableTerms => this.name;

  static Platform fromEntity(PlatformEntity entity, [String iconURL]) {

    return Platform(
      id: entity.id,
      name: entity.name,
      iconURL: iconURL,
      iconFilename: entity.iconFilename,
      type: entity.type,
    );

  }

  @override
  PlatformEntity toEntity() {

    return PlatformEntity(
      id: this.id,
      name: this.name,
      iconFilename: this.iconFilename,
      type: this.type,
    );

  }

  @override
  Platform copyWith({
    String name,
    String iconURL,
    String iconName,
    String type,
  }) {

    return Platform(
      id: id,
      name: name?? this.name,
      iconURL: iconURL?? this.iconURL,
      iconFilename: iconName?? this.iconFilename,
      type: type?? this.type,
    );

  }

  @override
  List<Object> get props => [
    id,
    name,
    iconURL,
    type,
  ];

  @override
  String toString() {

    return '$platformTable { '
        '$IdField: $id, '
        '$plat_nameField: $name, '
        '$plat_iconField: $iconURL, '
        '$plat_typeField: $type'
        ' }';

  }
}