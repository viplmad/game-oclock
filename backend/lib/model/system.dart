import 'model.dart' show Item, ItemImage;


enum Manufacturer {
  Nintendo,
  Sony,
  Microsoft,
  Sega,
}

class System extends Item {
  const System({
    required this.id,
    required this.name,
    required this.iconURL,
    required this.iconFilename,
    required this.generation,
    required this.manufacturer,
  }) : super(
    uniqueId: 'Sy$id',
    hasImage: true,
    queryableTerms: name,
  );

  final int id;
  final String name;
  final String? iconURL;
  final String? iconFilename;
  final int generation;
  final Manufacturer? manufacturer;

  @override
  ItemImage get image => ItemImage(this.iconURL, this.iconFilename);

  @override
  System copyWith({
    String? name,
    String? iconURL,
    String? iconFilename,
    int? generation,
    Manufacturer? manufacturer,
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