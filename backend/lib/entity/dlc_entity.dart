import 'package:backend/model/model.dart';

import 'entity.dart';


class DLCEntityData {
  DLCEntityData._();

  static const String table = 'DLC';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String releaseYearField = 'Release Year';
  static const String coverField = 'Cover';
  static const String finishDateField = 'Finish Date';

  static const String baseGameField = 'Base Game';
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

  static DLCEntity _fromDynamicMap(Map<String, dynamic> map) {

    return DLCEntity(
      id: map[DLCEntityData.idField] as int,
      name: map[DLCEntityData.nameField] as String,
      releaseYear: map[DLCEntityData.releaseYearField] as int?,
      coverFilename: map[DLCEntityData.coverField] as String?,
      finishDate: map[DLCEntityData.finishDateField] as DateTime?,

      baseGame: map[DLCEntityData.baseGameField] as int?,
    );

  }

  static List<DLCEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<DLCEntity> dlcsList = <DLCEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final DLCEntity dlc = DLCEntity._fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, DLCEntityData.table) );

      dlcsList.add(dlc);
    });

    return dlcsList;

  }

  static int? idFromDynamicMap(List<Map<String, Map<String, dynamic>>> listMap) {
    int? id;

    if(listMap.isNotEmpty) {
      final Map<String, dynamic> map = CollectionItemEntity.combineMaps(listMap.first, DLCEntityData.table);
      id = map[DLCEntityData.idField] as int;
    }

    return id;
  }

  Map<String, dynamic> createMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      DLCEntityData.nameField : name,
    };

    putCreateMapValueNullable(createMap, DLCEntityData.releaseYearField, releaseYear);
    putCreateMapValueNullable(createMap, DLCEntityData.coverField, coverFilename);
    putCreateMapValueNullable(createMap, DLCEntityData.finishDateField, finishDate);
    putCreateMapValueNullable(createMap, DLCEntityData.baseGameField, baseGame);

    return createMap;

  }

  Map<String, dynamic> updateMap(DLCEntity updatedEntity, DLCUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, DLCEntityData.nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, DLCEntityData.releaseYearField, releaseYear, updatedEntity.releaseYear, updatedValueCanBeNull: updateProperties.releaseYearToNull);
    putUpdateMapValueNullable(updateMap, DLCEntityData.coverField, coverFilename, updatedEntity.coverFilename, updatedValueCanBeNull: updateProperties.coverFilenameToNull);
    putUpdateMapValueNullable(updateMap, DLCEntityData.finishDateField, finishDate, updatedEntity.finishDate, updatedValueCanBeNull: updateProperties.finishDateToNull);

    return updateMap;

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