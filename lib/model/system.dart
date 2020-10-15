import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum SystemView {
  Main,
  LastCreated,
}

class System extends CollectionItem {

  System({
    @required int id,
    this.name,
    this.iconURL,
    this.iconFilename,
    this.generation,
    this.manufacturer,
  }) : super(id: id);

  final String name;
  final String iconURL;
  final String iconFilename;
  final int generation;
  final String manufacturer;

  static System fromEntity(SystemEntity entity, [String iconURL]) {

    return System(
      id: entity.id,
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
      id: this.id,
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
      id: id,
      name: name?? this.name,
      iconURL: iconURL?? this.iconURL,
      iconFilename: iconFilename?? this.iconFilename,
      generation: generation?? this.generation,
      manufacturer: manufacturer?? this.manufacturer,
    );

  }

  @override
  String getUniqueId() {

    return 'Sy' + this.id.toString();

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
    id,
    name,
    iconURL,
    generation,
    manufacturer,
  ];

  @override
  String toString() {

    return '$systemTable { '
        '$IdField: $id, '
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