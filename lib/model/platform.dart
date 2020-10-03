import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum PlatformView {
  Main,
  LastCreated,
}

class Platform extends CollectionItem {

  Platform({
    @required int ID,
    this.name,
    this.iconURL,
    this.iconFilename,
    this.type,
  }) : super(ID: ID);

  final String name;
  final String iconURL;
  final String iconFilename;
  final String type;

  static Platform fromEntity(PlatformEntity entity, [String iconURL]) {

    return Platform(
      ID: entity.ID,
      name: entity.name,
      iconURL: iconURL,
      iconFilename: entity.iconFilename,
      type: entity.type,
    );

  }

  @override
  PlatformEntity toEntity() {

    return PlatformEntity(
      ID: this.ID,
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
      ID: ID,
      name: name?? this.name,
      iconURL: iconURL?? this.iconURL,
      iconFilename: iconName?? this.iconFilename,
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
  String getImageFilename() {

    return this.iconFilename;

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

class PlatformsData {

  PlatformsData({
    this.platforms,
  });

  final List<Platform> platforms;

}