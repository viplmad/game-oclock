import 'model.dart';


enum SystemView {
  Main,
  LastCreated,
}

class System extends Item {
  const System({
    required this.id,
    required this.name,
    required this.iconURL,
    required this.iconFilename,
    required this.generation,
    required this.manufacturer,
  }) : this.uniqueId = 'Sy$id';

  final int id;
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
  List<Object> get props => <Object>[
    id,
    name,
    iconURL?? '',
    generation,
    manufacturer?? '',
  ];

  @override
  String toString() {

    return 'System { '
        'Id: $id, '
        'Name: $name, '
        'Icon URL: $iconURL, '
        'Generation: $generation, '
        'Manufacturer: $manufacturer'
        ' }';

  }
}