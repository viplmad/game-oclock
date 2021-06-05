import 'package:backend/model/model.dart';
import 'package:backend/query/query.dart';

import 'entity.dart';


class DLCEntityData {
  DLCEntityData._();

  // remove readTable
  static const String table = 'DLC';
  static const String readTable = '_DLC';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String _releaseYearField = 'Release Year';
  static const String _coverField = 'Cover';
  static const String _finishDateField = 'Finish Date';

  static const String baseGameField = 'Base Game';

  static const String imageField = _coverField;

  static const Map<String, Type> fields = <String, Type>{
    idField : int,
    nameField : String,
    _releaseYearField : int,
    _coverField : String,
    _finishDateField : DateTime,

    baseGameField : int,
  };

  static Query getIdQuery(int id) {

    final Query idQuery = Query();
    idQuery.addAnd(idField, id);

    return idQuery;

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
      id: map[DLCEntityData.idField] as int,
      name: map[DLCEntityData.nameField] as String,
      releaseYear: map[DLCEntityData._releaseYearField] as int?,
      coverFilename: map[DLCEntityData._coverField] as String?,
      finishDate: map[DLCEntityData._finishDateField] as DateTime?,

      baseGame: map[DLCEntityData.baseGameField] as int?,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      DLCEntityData.idField : id,
      DLCEntityData.nameField : name,
      DLCEntityData._releaseYearField : releaseYear,
      DLCEntityData._coverField : coverFilename,
      DLCEntityData._finishDateField : finishDate,

      DLCEntityData.baseGameField : baseGame,
    };

  }

  @override
  Map<String, dynamic> getCreateDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      DLCEntityData.nameField : name,
    };

    putCreateMapValueNullable(createMap, DLCEntityData._releaseYearField, releaseYear);
    putCreateMapValueNullable(createMap, DLCEntityData._coverField, coverFilename);
    putCreateMapValueNullable(createMap, DLCEntityData._finishDateField, finishDate);
    putCreateMapValueNullable(createMap, DLCEntityData.baseGameField, baseGame);

    return createMap;

  }

  Map<String, dynamic> getUpdateDynamicMap(DLCEntity updatedEntity, DLCUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, DLCEntityData.nameField, name, updatedEntity.name);
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
        '{$DLCEntityData.idField}: $id, '
        '{$DLCEntityData._nameField}: $name, '
        '{$DLCEntityData._releaseYearField}: $releaseYear, '
        '{$DLCEntityData._coverField}: $coverFilename, '
        '{$DLCEntityData._finishDateField}: $finishDate'
        ' }';

  }
}