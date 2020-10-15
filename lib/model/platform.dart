import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum PlatformView {
  Main,
  LastCreated,
}

class Platform extends CollectionItem {

  Platform({
    @required int id,
    this.name,
    this.iconURL,
    this.iconFilename,
    this.type,
  }) : super(id: id);

  final String name;
  final String iconURL;
  final String iconFilename;
  final String type;

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
  String getUniqueID() {

    return 'Pl' + this.id.toString();

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
  String getImageFilename() {

    return this.iconFilename;

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
        '$IDField: $id, '
        '$plat_nameField: $name, '
        '$plat_iconField: $iconURL, '
        '$plat_typeField: $type'
        ' }';

  }

}

class PlatformsData {

  PlatformsData({
    this.platforms,
  });

  final List<Platform> platforms;

}