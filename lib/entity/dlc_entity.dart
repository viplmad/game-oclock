import 'package:game_collection/model/model.dart';

import 'entity.dart';


class DLCEntityData {
  DLCEntityData._();
  
  // remove readTable
  static const String table = 'DLC';
  static const String readTable = '_DLC';
  
  static const String relationField = table + '_ID';

  static const String _nameField = 'Name';
  static const String _releaseYearField = 'Release Year';
  static const String _coverField = 'Cover';
  static const String _finishDateField = 'Finish Date';
  
  static const String _baseGameField = 'Base Game';

  static const String searchField = _nameField;
  static const String imageField = _coverField;
  static const String baseGameField = _baseGameField;

  static const Map<String, Type> fields = <String, Type>{
    idField : int,
    _nameField : String,
    _releaseYearField : int,
    _coverField : String,
    _finishDateField : DateTime,

    _baseGameField : int,
  };
  
  static Map<String, dynamic> getIdMap(int id) {

    return <String, dynamic>{
      idField : id,
    };

  }
}

class DLCEntity extends CollectionItemEntity {
  const DLCEntity({
    required int id,
    required this.name,
    required this.releaseYear,
    required this.coverFilename,
    required this.finishDate,

    required this.baseGame,
  }) : super(id: id);

  final String name;
  final int? releaseYear;
  final String? coverFilename;
  final DateTime? finishDate;

  final int? baseGame;

  static DLCEntity fromDynamicMap(Map<String, dynamic> map) {

    return DLCEntity(
      id: map[idField] as int,
      name: map[DLCEntityData._nameField] as String,
      releaseYear: map[DLCEntityData._releaseYearField] as int?,
      coverFilename: map[DLCEntityData._coverField] as String?,
      finishDate: map[DLCEntityData._finishDateField] as DateTime?,

      baseGame: map[DLCEntityData._baseGameField] as int?,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      idField : id,
      DLCEntityData._nameField : name,
      DLCEntityData._releaseYearField : releaseYear,
      DLCEntityData._coverField : coverFilename,
      DLCEntityData._finishDateField : finishDate,

      DLCEntityData._baseGameField : baseGame,
    };

  }

  @override
  Map<String, dynamic> getCreateDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      DLCEntityData._nameField : name,
    };

    putCreateMapValueNullable(createMap, DLCEntityData._releaseYearField, releaseYear);
    putCreateMapValueNullable(createMap, DLCEntityData._coverField, coverFilename);
    putCreateMapValueNullable(createMap, DLCEntityData._finishDateField, finishDate);
    putCreateMapValueNullable(createMap, DLCEntityData._baseGameField, baseGame);

    return createMap;

  }
  
  Map<String, dynamic> getUpdateDynamicMap(DLCEntity updatedEntity, DLCUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, DLCEntityData._nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, DLCEntityData._releaseYearField, releaseYear, updatedEntity.releaseYear, updatedValueCanBeNull: updateProperties.releaseYearToNull);
    putUpdateMapValueNullable(updateMap, DLCEntityData._coverField, coverFilename, updatedEntity.coverFilename, updatedValueCanBeNull: updateProperties.coverFilenameToNull);
    putUpdateMapValueNullable(updateMap, DLCEntityData._finishDateField, finishDate, updatedEntity.finishDate, updatedValueCanBeNull: updateProperties.finishDateToNull);

    return updateMap;

  }

  static List<DLCEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<DLCEntity> dlcsList = <DLCEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final DLCEntity dlc = DLCEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, DLCEntityData.table) );

      dlcsList.add(dlc);
    });

    return dlcsList;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '{$DLCEntityData.table}Entity { '
        '$idField: $id, '
        '{$DLCEntityData._nameField}: $name, '
        '{$DLCEntityData._releaseYearField}: $releaseYear, '
        '{$DLCEntityData._coverField}: $coverFilename, '
        '{$DLCEntityData._finishDateField}: $finishDate'
        ' }';

  }
}