import 'entity.dart';


const String systemTable = 'System';

const List<String> systemTables = <String>[
  idField,
  sys_nameField,
  sys_iconField,
  sys_generationField,
  sys_manufacturerField,
];

const String sys_nameField = 'Name';
const String sys_iconField = 'Icon';
const String sys_generationField = 'Generation';
const String sys_manufacturerField = 'Manufacturer';

List<String> manufacturers = <String>[
  'Nintendo',
  'Sony',
  'Microsoft',
  'Sega',
];

class SystemEntity extends CollectionItemEntity {
  const SystemEntity({
    required int id,
    required this.name,
    required this.iconFilename,
    required this.generation,
    required this.manufacturer,
  }) : super(id: id);

  final String name;
  final String? iconFilename;
  final int generation;
  final String? manufacturer;

  static SystemEntity fromDynamicMap(Map<String, dynamic> map) {

    return SystemEntity(
      id: map[idField] as int,
      name: map[sys_nameField] as String,
      iconFilename: map[sys_iconField] as String?,
      generation: map[sys_generationField] as int,
      manufacturer: map[sys_manufacturerField] as String?,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      idField : id,
      sys_nameField : name,
      sys_iconField : iconFilename,
      sys_generationField : generation,
      sys_manufacturerField : manufacturer,
    };

  }

  static List<SystemEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<SystemEntity> systemsList = <SystemEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final SystemEntity system = SystemEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, systemTable) );

      systemsList.add(system);
    });

    return systemsList;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '{$systemTable}Entity { '
        '$idField: $id, '
        '$sys_nameField: $name, '
        '$sys_iconField: $iconFilename, '
        '$sys_generationField: $generation, '
        '$sys_manufacturerField: $manufacturer'
        ' }';

  }
}