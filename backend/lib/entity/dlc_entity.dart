import 'entity.dart' show ItemEntity;


enum DLCView {
  Main,
  LastCreated,
}

class DLCEntityData {
  DLCEntityData._();

  static const String table = 'DLC';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String releaseYearField = 'Release Year';
  static const String coverField = 'Cover';
  static const String baseGameField = 'Base Game';

  static const String firstfinishDateField = 'First Finish Date';
}

class DLCID {
  DLCID(this.id);

  final int id;
}

class DLCEntity extends ItemEntity {
  const DLCEntity({
    required this.id,
    required this.name,
    required this.releaseYear,
    required this.coverFilename,
    required this.baseGame,
    required this.firstFinishDate,
  });

  final int id;
  final String name;
  final int? releaseYear;
  final String? coverFilename;
  final int? baseGame;
  final DateTime? firstFinishDate;

  static DLCEntity fromMap(Map<String, Object?> map) {

    return DLCEntity(
      id: map[DLCEntityData.idField] as int,
      name: map[DLCEntityData.nameField] as String,
      releaseYear: map[DLCEntityData.releaseYearField] as int?,
      coverFilename: map[DLCEntityData.coverField] as String?,
      baseGame: map[DLCEntityData.baseGameField] as int?,
      firstFinishDate: map[DLCEntityData.firstfinishDateField] as DateTime?,
    );

  }

  static DLCID idFromMap(Map<String, Object?> map) {

    return DLCID(map[DLCEntityData.idField] as int);

  }

  DLCID createId() {

    return DLCID(id);

  }

  Map<String, Object?> createMap() {

    final Map<String, Object?> createMap = <String, Object?>{
      DLCEntityData.nameField : name,
    };

    putCreateMapValueNullable(createMap, DLCEntityData.releaseYearField, releaseYear);
    putCreateMapValueNullable(createMap, DLCEntityData.coverField, coverFilename);
    putCreateMapValueNullable(createMap, DLCEntityData.baseGameField, baseGame);

    return createMap;

  }

  Map<String, Object?> updateMap(DLCEntity updatedEntity) {

    final Map<String, Object?> updateMap = <String, Object?>{};

    putUpdateMapValue(updateMap, DLCEntityData.nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, DLCEntityData.releaseYearField, releaseYear, updatedEntity.releaseYear);
    putUpdateMapValueNullable(updateMap, DLCEntityData.coverField, coverFilename, updatedEntity.coverFilename);

    return updateMap;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '${DLCEntityData.table}Entity { '
        '${DLCEntityData.idField}: $id, '
        '${DLCEntityData.nameField}: $name, '
        '${DLCEntityData.releaseYearField}: $releaseYear, '
        '${DLCEntityData.coverField}: $coverFilename, '
        '${DLCEntityData.firstfinishDateField}: $firstFinishDate'
        ' }';

  }
}