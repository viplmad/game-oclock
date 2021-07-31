import 'entity.dart' show ItemEntity;


const String lowPriorityValue = 'Low Priority';
const String nextUpValue = 'Next Up';
const String playingValue = 'Playing';
const String playedValue = 'Played';

enum GameView {
  Main,
  LastCreated,
  Playing,
  NextUp,
  LastPlayed,
  LastFinished,
  Review,
}

class GameEntityData {
  GameEntityData._();

  static const String table = 'Game';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String editionField = 'Edition';
  static const String releaseYearField = 'Release Year';
  static const String coverField = 'Cover';
  static const String statusField = 'Status';
  static const String ratingField = 'Rating';
  static const String thoughtsField = 'Thoughts';
  static const String timeField = 'Time';
  static const String saveFolderField = 'Save Folder';
  static const String screenshotFolderField = 'Screenshot Folder';
  static const String finishDateField = 'Finish Date';
  static const String backupField = 'Backup';
}

class GameID {
  GameID(this.id);

  final int id;
}

class GameEntity extends ItemEntity {
  const GameEntity({
    required this.id,
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
  });

  final int id;
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

  static GameEntity fromMap(Map<String, Object?> map) {

    return GameEntity(
      id: map[GameEntityData.idField] as int,
      name: map[GameEntityData.nameField] as String,
      edition: map[GameEntityData.editionField] as String,
      releaseYear: map[GameEntityData.releaseYearField] as int?,
      coverFilename: map[GameEntityData.coverField] as String?,
      status: map[GameEntityData.statusField] as String,
      rating: map[GameEntityData.ratingField] as int,
      thoughts: map[GameEntityData.thoughtsField] as String,
      time: Duration(seconds: (map[GameEntityData.timeField] as int?)?? 0),
      saveFolder: map[GameEntityData.saveFolderField] as String,
      screenshotFolder: map[GameEntityData.screenshotFolderField] as String,
      finishDate: map[GameEntityData.finishDateField] as DateTime?,
      isBackup: map[GameEntityData.backupField] as bool,
    );

  }

  static GameID idFromMap(Map<String, Object?> map) {

    return GameID(map[GameEntityData.idField] as int);

  }

  GameID createId() {

    return GameID(id);

  }

  Map<String, Object?> createMap() {

    final Map<String, Object?> createMap = <String, Object?>{
      GameEntityData.nameField : name,
      GameEntityData.editionField : edition,
      GameEntityData.statusField : status,
      GameEntityData.ratingField : rating,
      GameEntityData.thoughtsField : thoughts,
      GameEntityData.timeField : time,
      GameEntityData.saveFolderField : saveFolder,
      GameEntityData.screenshotFolderField : screenshotFolder,
      GameEntityData.backupField : isBackup,
    };

    putCreateMapValueNullable(createMap, GameEntityData.releaseYearField, releaseYear);
    putCreateMapValueNullable(createMap, GameEntityData.coverField, coverFilename);
    putCreateMapValueNullable(createMap, GameEntityData.finishDateField, finishDate);

    return createMap;

  }

  Map<String, Object?> updateMap(GameEntity updatedEntity) {

    final Map<String, Object?> updateMap = <String, Object?>{};

    putUpdateMapValue(updateMap, GameEntityData.nameField, name, updatedEntity.name);
    putUpdateMapValue(updateMap, GameEntityData.editionField, edition, updatedEntity.edition);
    putUpdateMapValueNullable(updateMap, GameEntityData.releaseYearField, releaseYear, updatedEntity.releaseYear);
    putUpdateMapValueNullable(updateMap, GameEntityData.coverField, coverFilename, updatedEntity.coverFilename);
    putUpdateMapValue(updateMap, GameEntityData.statusField, status, updatedEntity.status);
    putUpdateMapValue(updateMap, GameEntityData.ratingField, rating, updatedEntity.rating);
    putUpdateMapValue(updateMap, GameEntityData.thoughtsField, thoughts, updatedEntity.thoughts);
    putUpdateMapValue(updateMap, GameEntityData.timeField, time, updatedEntity.time);
    putUpdateMapValue(updateMap, GameEntityData.saveFolderField, saveFolder, updatedEntity.saveFolder);
    putUpdateMapValue(updateMap, GameEntityData.screenshotFolderField, screenshotFolder, updatedEntity.screenshotFolder);
    putUpdateMapValueNullable(updateMap, GameEntityData.finishDateField, finishDate, updatedEntity.finishDate);
    putUpdateMapValue(updateMap, GameEntityData.backupField, isBackup, updatedEntity.isBackup);

    return updateMap;
  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
    edition,
  ];

  @override
  String toString() {

    return '${GameEntityData.table}Entity { '
        '${GameEntityData.idField}: $id, '
        '${GameEntityData.nameField}: $name, '
        '${GameEntityData.editionField}: $edition, '
        '${GameEntityData.releaseYearField}: $releaseYear, '
        '${GameEntityData.coverField}: $coverFilename, '
        '${GameEntityData.statusField}: $status, '
        '${GameEntityData.ratingField}: $rating, '
        '${GameEntityData.thoughtsField}: $thoughts, '
        '${GameEntityData.timeField}: $time, '
        '${GameEntityData.saveFolderField}: $saveFolder, '
        '${GameEntityData.screenshotFolderField}: $screenshotFolder, '
        '${GameEntityData.finishDateField}: $finishDate, '
        '${GameEntityData.backupField}: $isBackup'
        ' }';

  }
}