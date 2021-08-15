import 'entity.dart' show ItemEntity;


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
  static const String saveFolderField = 'Save Folder';
  static const String screenshotFolderField = 'Screenshot Folder';
  static const String backupField = 'Backup';

  static const String firstFinishDateField = 'First Finish Date';
  static const String totalTimeField = 'Total Time';

  static const String gameStatusEnum = 'game_status';
  static const String lowPriorityValue = 'Low Priority';
  static const String nextUpValue = 'Next Up';
  static const String playingValue = 'Playing';
  static const String playedValue = 'Played';
}

class GameID {
  GameID(this.id);

  final int id;

  @override
  String toString() => '$id';
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
    required this.saveFolder,
    required this.screenshotFolder,
    required this.isBackup,
    required this.firstFinishDate,
    required this.totalTime,
  });

  final int id;
  final String name;
  final String edition;
  final int? releaseYear;
  final String? coverFilename;
  final String status;
  final int rating;
  final String thoughts;
  final String saveFolder;
  final String screenshotFolder;
  final bool isBackup;
  final DateTime? firstFinishDate;
  final Duration totalTime;

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
      saveFolder: map[GameEntityData.saveFolderField] as String,
      screenshotFolder: map[GameEntityData.screenshotFolderField] as String,
      isBackup: map[GameEntityData.backupField] as bool,
      firstFinishDate: map[GameEntityData.firstFinishDateField] as DateTime?,
      totalTime: Duration(minutes: (map[GameEntityData.totalTimeField] as int?)?? 0),
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
      GameEntityData.saveFolderField : saveFolder,
      GameEntityData.screenshotFolderField : screenshotFolder,
      GameEntityData.backupField : isBackup,
    };

    putCreateMapValueNullable(createMap, GameEntityData.releaseYearField, releaseYear);
    putCreateMapValueNullable(createMap, GameEntityData.coverField, coverFilename);

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
    putUpdateMapValue(updateMap, GameEntityData.saveFolderField, saveFolder, updatedEntity.saveFolder);
    putUpdateMapValue(updateMap, GameEntityData.screenshotFolderField, screenshotFolder, updatedEntity.screenshotFolder);
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
        '${GameEntityData.saveFolderField}: $saveFolder, '
        '${GameEntityData.screenshotFolderField}: $screenshotFolder, '
        '${GameEntityData.backupField}: $isBackup, '
        '${GameEntityData.firstFinishDateField}: $firstFinishDate, '
        '${GameEntityData.totalTimeField}: $totalTime'
        ' }';

  }
}