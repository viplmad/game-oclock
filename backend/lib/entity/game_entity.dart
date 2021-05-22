import 'package:backend/model/model.dart';

import 'entity.dart';


const List<String> statuses = <String>[
  'Low Priority',
  'Next Up',
  'Playing',
  'Played',
];

class GameEntityData {
  GameEntityData._();

  static const String table = 'Game';
  static const String readTable = '_Game';

  static const String relationField = table + '_ID';

  static const String _nameField = 'Name';
  static const String _editionField = 'Edition';
  static const String _releaseYearField = 'Release Year';
  static const String _coverField = 'Cover';
  static const String _statusField = 'Status';
  static const String _ratingField = 'Rating';
  static const String _thoughtsField = 'Thoughts';
  static const String _timeField = 'Time';
  static const String _saveFolderField = 'Save Folder';
  static const String _screenshotFolderField = 'Screenshot Folder';
  static const String _finishDateField = 'Finish Date';
  static const String _backupField = 'Backup';

  static const String searchField = _nameField;
  static const String imageField = _coverField;

  static const Map<String, Type> fields = <String, Type>{
    idField : int,
    _nameField : String,
    _editionField : String,
    _releaseYearField : int,
    _coverField : String,
    _statusField : String,
    _ratingField : int,
    _thoughtsField : String,
    _timeField : Duration,
    _saveFolderField : String,
    _screenshotFolderField : String,
    _finishDateField : DateTime,
    _backupField : bool,
  };

  static Map<String, dynamic> getIdMap(int id) {

    return <String, dynamic>{
      idField : id,
    };

  }
}

class GameEntity extends CollectionItemEntity {
  const GameEntity({
    required int id,
    required this.name,
    required this.edition,
    required this.releaseYear,
    required this.coverFilename,
    required this.status,
    required this.rating,
    required this.thoughts,
    required this.time,
    required this.saveFolder,
    required this.screenshotFolder,
    required this.finishDate,
    required this.isBackup,
  }) : super(id: id);

  final String name;
  final String edition;
  final int? releaseYear;
  final String? coverFilename;
  final String status;
  final int rating;
  final String thoughts;
  final Duration time;
  final String saveFolder;
  final String screenshotFolder;
  final DateTime? finishDate;
  final bool isBackup;

  static GameEntity fromDynamicMap(Map<String, dynamic> map) {

    return GameEntity(
      id: map[idField] as int,
      name: map[GameEntityData._nameField] as String,
      edition: map[GameEntityData._editionField] as String,
      releaseYear: map[GameEntityData._releaseYearField] as int?,
      coverFilename: map[GameEntityData._coverField] as String?,
      status: map[GameEntityData._statusField] as String,
      rating: map[GameEntityData._ratingField] as int,
      thoughts: map[GameEntityData._thoughtsField] as String,
      time: Duration(seconds: map[GameEntityData._timeField] as int),
      saveFolder: map[GameEntityData._saveFolderField] as String,
      screenshotFolder: map[GameEntityData._screenshotFolderField] as String,
      finishDate: map[GameEntityData._finishDateField] as DateTime?,
      isBackup: map[GameEntityData._backupField] as bool,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      idField : id,
      GameEntityData._nameField : name,
      GameEntityData._editionField : edition,
      GameEntityData._releaseYearField : releaseYear,
      GameEntityData._coverField: coverFilename,
      GameEntityData._statusField : status,
      GameEntityData._ratingField : rating,
      GameEntityData._thoughtsField : thoughts,
      GameEntityData._timeField : time,
      GameEntityData._saveFolderField : saveFolder,
      GameEntityData._screenshotFolderField : screenshotFolder,
      GameEntityData._finishDateField : finishDate,
      GameEntityData._backupField : isBackup,
    };

  }

  @override
  Map<String, dynamic> getCreateDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      GameEntityData._nameField : name,
      GameEntityData._editionField : edition,
      GameEntityData._statusField : status,
      GameEntityData._ratingField : rating,
      GameEntityData._thoughtsField : thoughts,
      GameEntityData._timeField : time,
      GameEntityData._saveFolderField : saveFolder,
      GameEntityData._screenshotFolderField : screenshotFolder,
      GameEntityData._backupField : isBackup,
    };

    putCreateMapValueNullable(createMap, GameEntityData._releaseYearField, releaseYear);
    putCreateMapValueNullable(createMap, GameEntityData._coverField, coverFilename);
    putCreateMapValueNullable(createMap, GameEntityData._finishDateField, finishDate);

    return createMap;

  }

  Map<String, dynamic> getUpdateDynamicMap(GameEntity updatedEntity, GameUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, GameEntityData._nameField, name, updatedEntity.name);
    putUpdateMapValue(updateMap, GameEntityData._editionField, edition, updatedEntity.edition);
    putUpdateMapValueNullable(updateMap, GameEntityData._releaseYearField, releaseYear, updatedEntity.releaseYear, updatedValueCanBeNull: updateProperties.releaseYearToNull);
    putUpdateMapValueNullable(updateMap, GameEntityData._coverField, coverFilename, updatedEntity.coverFilename, updatedValueCanBeNull: updateProperties.coverURLToNull);
    putUpdateMapValue(updateMap, GameEntityData._statusField, status, updatedEntity.status);
    putUpdateMapValue(updateMap, GameEntityData._ratingField, rating, updatedEntity.rating);
    putUpdateMapValue(updateMap, GameEntityData._thoughtsField, thoughts, updatedEntity.thoughts);
    putUpdateMapValue(updateMap, GameEntityData._timeField, time, updatedEntity.time);
    putUpdateMapValue(updateMap, GameEntityData._saveFolderField, saveFolder, updatedEntity.saveFolder);
    putUpdateMapValue(updateMap, GameEntityData._screenshotFolderField, screenshotFolder, updatedEntity.screenshotFolder);
    putUpdateMapValueNullable(updateMap, GameEntityData._finishDateField, finishDate, updatedEntity.finishDate, updatedValueCanBeNull: updateProperties.finishDateToNull);
    putUpdateMapValue(updateMap, GameEntityData._backupField, isBackup, updatedEntity.isBackup);

    return updateMap;
  }

  static List<GameEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameEntity> gamesList = <GameEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final GameEntity game = GameEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, GameEntityData.table) );

      gamesList.add(game);
    });

    return gamesList;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
    edition,
  ];

  @override
  String toString() {

    return '{$GameEntityData.table}Entity { '
        '$idField: $id, '
        '{$GameEntityData._nameField}: $name, '
        '{$GameEntityData._editionField}: $edition, '
        '{$GameEntityData._releaseYearField}: $releaseYear, '
        '{$GameEntityData._coverField}: $coverFilename, '
        '{$GameEntityData._statusField}: $status, '
        '{$GameEntityData._ratingField}: $rating, '
        '{$GameEntityData._thoughtsField}: $thoughts, '
        '{$GameEntityData._timeField}: $time, '
        '{$GameEntityData._saveFolderField}: $saveFolder, '
        '{$GameEntityData._screenshotFolderField}: $screenshotFolder, '
        '{$GameEntityData._finishDateField}: $finishDate, '
        '{$GameEntityData._backupField}: $isBackup'
        ' }';

  }
}