import 'package:backend/model/model.dart';
import 'package:backend/query/query.dart';
import 'package:backend/query/fields.dart';

import 'entity.dart';


class DLCEntityData {
  DLCEntityData._();

  // remove readTable
  static const String table = 'DLC';
  static const String readTable = '_DLC';

  static const Map<DLCView, String> viewToTable = <DLCView, String>{
    DLCView.Main : 'DLC-Main',
    DLCView.LastCreated : 'DLC-Last Created',
  };

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String _releaseYearField = 'Release Year';
  static const String _coverField = 'Cover';
  static const String _finishDateField = 'Finish Date';

  static const String baseGameField = 'Base Game';

  static const String imageField = _coverField;

  static Fields fields() {

    final Fields fields = Fields();
    fields.add(idField, int);
    fields.add(nameField, String);
    fields.add(_releaseYearField, int);
    fields.add(_coverField, String);
    fields.add(_finishDateField, DateTime);

    fields.add(baseGameField, int);

    return fields;

  }

  static Query idQuery(int id) {

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

  static DLCEntity _fromDynamicMap(Map<String, dynamic> map) {

    return DLCEntity(
      id: map[DLCEntityData.idField] as int,
      name: map[DLCEntityData.nameField] as String,
      releaseYear: map[DLCEntityData._releaseYearField] as int?,
      coverFilename: map[DLCEntityData._coverField] as String?,
      finishDate: map[DLCEntityData._finishDateField] as DateTime?,

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

  Map<String, dynamic> createDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      DLCEntityData.nameField : name,
    };

    putCreateMapValueNullable(createMap, DLCEntityData._releaseYearField, releaseYear);
    putCreateMapValueNullable(createMap, DLCEntityData._coverField, coverFilename);
    putCreateMapValueNullable(createMap, DLCEntityData._finishDateField, finishDate);
    putCreateMapValueNullable(createMap, DLCEntityData.baseGameField, baseGame);

    return createMap;

  }

  Map<String, dynamic> updateDynamicMap(DLCEntity updatedEntity, DLCUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, DLCEntityData.nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, DLCEntityData._releaseYearField, releaseYear, updatedEntity.releaseYear, updatedValueCanBeNull: updateProperties.releaseYearToNull);
    putUpdateMapValueNullable(updateMap, DLCEntityData._coverField, coverFilename, updatedEntity.coverFilename, updatedValueCanBeNull: updateProperties.coverFilenameToNull);
    putUpdateMapValueNullable(updateMap, DLCEntityData._finishDateField, finishDate, updatedEntity.finishDate, updatedValueCanBeNull: updateProperties.finishDateToNull);

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