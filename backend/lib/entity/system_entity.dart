import 'package:backend/model/model.dart';
import 'package:backend/query/query.dart';
import 'package:backend/query/fields.dart';

import 'entity.dart';


List<String> manufacturers = <String>[
  'Nintendo',
  'Sony',
  'Microsoft',
  'Sega',
];

class SystemEntityData {
  SystemEntityData._();

  static const String table = 'System';

  static const Map<SystemView, String> viewToTable = <SystemView, String>{
    SystemView.Main : 'System-Main',
    SystemView.LastCreated : 'System-Last Created',
  };

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String _iconField = 'Icon';
  static const String _generationField = 'Generation';
  static const String _manufacturerField = 'Manufacturer';

  static const String imageField = _iconField;

  static Fields fields() {

    final Fields fields = Fields();
    fields.add(idField, int);
    fields.add(nameField, String);
    fields.add(_iconField, String);
    fields.add(_generationField, int);
    fields.add(_manufacturerField, String);

    return fields;

  }

  static Query idQuery(int id) {

    final Query idQuery = Query();
    idQuery.addAnd(idField, id);

    return idQuery;

  }
}

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

  static SystemEntity _fromDynamicMap(Map<String, dynamic> map) {

    return SystemEntity(
      id: map[SystemEntityData.idField] as int,
      name: map[SystemEntityData.nameField] as String,
      iconFilename: map[SystemEntityData._iconField] as String?,
      generation: map[SystemEntityData._generationField] as int,
      manufacturer: map[SystemEntityData._manufacturerField] as String?,
    );

  }

  static List<SystemEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<SystemEntity> systemsList = <SystemEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final SystemEntity system = SystemEntity._fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, SystemEntityData.table) );

      systemsList.add(system);
    });

    return systemsList;

  }

  Map<String, dynamic> createDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      SystemEntityData.nameField : name,
      SystemEntityData._generationField : generation,
    };

    putCreateMapValueNullable(createMap, SystemEntityData._iconField, iconFilename);
    putCreateMapValueNullable(createMap, SystemEntityData._manufacturerField, manufacturer);

    return createMap;

  }

  Map<String, dynamic> updateDynamicMap(SystemEntity updatedEntity, SystemUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, SystemEntityData.nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, SystemEntityData._iconField, iconFilename, updatedEntity.iconFilename, updatedValueCanBeNull: updateProperties.iconURLToNull);
    putUpdateMapValue(updateMap, SystemEntityData._generationField, generation, updatedEntity.generation);
    putUpdateMapValueNullable(updateMap, SystemEntityData._manufacturerField, manufacturer, updatedEntity.manufacturer, updatedValueCanBeNull: updateProperties.manufacturerToNull);

    return updateMap;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '{$SystemEntityData.table}Entity { '
        '{$SystemEntityData.idField}: $id, '
        '{$SystemEntityData._nameField}: $name, '
        '{$SystemEntityData._iconField}: $iconFilename, '
        '{$SystemEntityData._generationField}: $generation, '
        '{$SystemEntityData._manufacturerField}: $manufacturer'
        ' }';

  }
}