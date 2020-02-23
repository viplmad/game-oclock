import 'package:meta/meta.dart';

import 'package:game_collection/entity/collection_item_entity.dart';
import 'package:game_collection/entity/system_entity.dart';

import 'collection_item.dart';


enum SystemView {
  Main,
  LastCreated,
}

const List<String> systemViews = [
  "Main",
  "Last Created",
];

class System extends CollectionItem {

  System({
    @required int ID,
    this.name,
    this.iconURL,
    this.generation,
    this.manufacturer,
  }) : super(ID: ID);

  final String name;
  final String iconURL;
  final int generation;
  final String manufacturer;

  static System fromEntity(SystemEntity entity, [String iconURL]) {

    return System(
      ID: entity.ID,
      name: entity.name,
      iconURL: iconURL,
      generation: entity.generation,
      manufacturer: entity.manufacturer,
    );

  }

  @override
  SystemEntity toEntity() {

    return SystemEntity(
      ID: this.ID,
      name: this.name,
      generation: this.generation,
      manufacturer: this.manufacturer,
    );

  }

  @override
  System copyWith({
    String name,
    String iconURL,
    int generation,
    String manufacturer,
  }) {

    return System(
      ID: ID,
      name: name?? this.name,
      iconURL: iconURL?? this.iconURL,
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

    return this.iconURL;

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