import 'package:meta/meta.dart';

import 'entity.dart';

const String systemTable = "System";

const List<String> systemTables = [
  IDField,
  nameField,
  iconField,
  generationField,
  manufacturerField,
];

const String nameField = 'Name';
const String iconField = 'Icon';
const String generationField = 'Generation';
const String manufacturerField = 'Manufacturer';

List<String> manufacturers = [
  "Nintendo",
  "Sony",
  "Microsoft",
  "Sega",
];

class System extends Entity {

  final String name;
  final int generation;
  final String manufacturer;

  System({
    @required int ID,
    this.name,
    this.generation,
    this.manufacturer
  }) : super(ID: ID);

  @override
  System copyWith({
    String name,
    int generation,
    String manufacturer,
  }) {

    return System(
      ID: ID,
      name: name?? this.name,
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

  static System fromDynamicMap(Map<String, dynamic> map) {

    return System(
      ID: map[IDField],
      name: map[nameField],
      generation: map[generationField],
      manufacturer: map[manufacturerField],
    );

  }

  static List<System> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<System> systemsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      System system = System.fromDynamicMap(map[systemTable]);

      systemsList.add(system);
    });

    return systemsList;

  }@override
  List<Object> get props => [
    ID,
    name,
    generation,
    manufacturer,
  ];

  @override
  String toString() {

    return '$systemTable { '
        '$IDField: $ID, '
        '$nameField: $name, '
        '$generationField: $generation, '
        '$manufacturerField: $manufacturer'
        ' }';

  }

}