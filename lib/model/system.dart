import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum SystemView {
  Main,
  LastCreated,
}

class System extends CollectionItem {

  System({
    @required int ID,
    this.name,
    this.iconURL,
    this.iconFilename,
    this.generation,
    this.manufacturer,
  }) : super(ID: ID);

  final String name;
  final String iconURL;
  final String iconFilename;
  final int generation;
  final String manufacturer;

  static System fromEntity(SystemEntity entity, [String iconURL]) {

    return System(
      ID: entity.ID,
      name: entity.name,
      iconURL: iconURL,
      iconFilename: entity.iconFilename,
      generation: entity.generation,
      manufacturer: entity.manufacturer,
    );

  }

  @override
  SystemEntity toEntity() {

    return SystemEntity(
      ID: this.ID,
      name: this.name,
      iconFilename: this.iconFilename,
      generation: this.generation,
      manufacturer: this.manufacturer,
    );

  }

  @override
  System copyWith({
    String name,
    String iconURL,
    String iconFilename,
    int generation,
    String manufacturer,
  }) {

    return System(
      ID: ID,
      name: name?? this.name,
      iconURL: iconURL?? this.iconURL,
      iconFilename: iconFilename?? this.iconFilename,
      generation: generation?? this.generation,
      manufacturer: manufacturer?? this.manufacturer,
    );

  }

  @override
  String getUniqueID() {

    return 'Sy' + this.ID.toString();

  }

  @override
  String getTitle() {

    return this.name;

  }

  @override
  String getSubtitle() {

    return this.manufacturer;

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
    generation,
    manufacturer,
  ];

  @override
  String toString() {

    return '$systemTable { '
        '$IDField: $ID, '
        '$sys_nameField: $name, '
        '$sys_iconField: $iconURL, '
        '$sys_generationField: $generation, '
        '$sys_manufacturerField: $manufacturer'
        ' }';

  }

}

class SystemsData {

  SystemsData({
    this.systems,
  });

  final List<System> systems;

}