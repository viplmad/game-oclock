import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum SystemView {
  Main,
  LastCreated,
}

class System extends CollectionItem {
  const System({
    required int id,
    required this.name,
    required this.iconURL,
    required this.iconFilename,
    required this.generation,
    required this.manufacturer,
  }) : this.uniqueId = 'Sy$id',
        super(id: id);

  final String name;
  final String? iconURL;
  final String? iconFilename;
  final int generation;
  final String? manufacturer;

  @override
  final String uniqueId;

  @override
  final bool hasImage = true;
  @override
  ItemImage get image => ItemImage(this.iconURL, this.iconFilename);

  @override
  String get queryableTerms => this.name;

  static System fromEntity(SystemEntity entity, [String? iconURL]) {

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
    String? name,
    String? iconURL,
    String? iconFilename,
    int? generation,
    String? manufacturer,
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
  List<Object> get props => [
    id,
    name,
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