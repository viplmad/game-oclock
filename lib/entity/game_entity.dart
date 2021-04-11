import 'package:equatable/equatable.dart';

import 'entity.dart';


const String gameTable = 'Game';
const String gameTableRead = '_Game';

const List<String> gameFields = <String>[
  idField,
  game_nameField,
  game_editionField,
  game_releaseYearField,
  game_coverField,
  game_statusField,
  game_ratingField,
  game_thoughtsField,
  game_timeField,
  game_saveFolderField,
  game_screenshotFolderField,
  game_finishDateField,
  game_backupField,
];

const String game_nameField = 'Name';
const String game_editionField = 'Edition';
const String game_releaseYearField = 'Release Year';
const String game_coverField = 'Cover';
const String game_statusField = 'Status';
const String game_ratingField = 'Rating';
const String game_thoughtsField = 'Thoughts';
const String game_timeField = 'Time';
const String game_saveFolderField = 'Save Folder';
const String game_screenshotFolderField = 'Screenshot Folder';
const String game_finishDateField = 'Finish Date';
const String game_backupField = 'Backup';

const String gameFinishTable = 'GameFinish';
const String gameFinishTableRead = 'Game-Finish';
const List<String> gameFinishFields = <String>[
  gameFinish_gameField,
  gameFinish_dateField,
];
const String gameFinish_gameField = 'Game_ID';
const String gameFinish_dateField = 'Date';

const String gameLogTable = 'GameLog';
const String gameLogTableRead = 'Game-Log';
const List<String> gameLogFields = <String>[
  gameLog_gameField,
  gameLog_dateTimeField,
  gameLog_timeField,
];
const String gameLog_gameField = 'Game_ID';
const String gameLog_dateTimeField = 'DateTime';
const String gameLog_timeField = 'Time';

const List<String> statuses = <String>[
  'Low Priority',
  'Next Up',
  'Playing',
  'Played',
];

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
      name: map[game_nameField] as String,
      edition: map[game_editionField] as String,
      releaseYear: map[game_releaseYearField] as int?,
      coverFilename: map[game_coverField] as String?,
      status: map[game_statusField] as String,
      rating: map[game_ratingField] as int,
      thoughts: map[game_thoughtsField] as String,
      time: Duration(minutes: map[game_timeField] as int),
      saveFolder: map[game_saveFolderField] as String,
      screenshotFolder: map[game_screenshotFolderField] as String,
      finishDate: map[game_finishDateField] as DateTime?,
      isBackup: map[game_backupField] as bool,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      idField : id,
      game_nameField : name,
      game_editionField : edition,
      game_releaseYearField : releaseYear,
      game_coverField: coverFilename,
      game_statusField : status,
      game_ratingField : rating,
      game_thoughtsField : thoughts,
      game_timeField : time.inSeconds,
      game_saveFolderField : saveFolder,
      game_screenshotFolderField : screenshotFolder,
      game_finishDateField : finishDate,
      game_backupField : isBackup,
    };

  }

  static List<GameEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameEntity> gamesList = <GameEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final GameEntity game = GameEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, gameTable) );

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

    return '{$gameTable}Entity { '
        '$idField: $id, '
        '$game_nameField: $name, '
        '$game_editionField: $edition, '
        '$game_releaseYearField: $releaseYear, '
        '$game_coverField: $coverFilename, '
        '$game_statusField: $status, '
        '$game_ratingField: $rating, '
        '$game_thoughtsField: $thoughts, '
        '$game_timeField: $time, '
        '$game_saveFolderField: $saveFolder, '
        '$game_screenshotFolderField: $screenshotFolder, '
        '$game_finishDateField: $finishDate, '
        '$game_backupField: $isBackup'
        ' }';

  }
}

class TimeLogEntity extends Equatable {
  const TimeLogEntity({
    required this.dateTime,
    required this.time,
  });

  final DateTime dateTime;
  final Duration time;

  static TimeLogEntity fromDynamicMap(Map<String, dynamic> map) {

    return TimeLogEntity(
      dateTime: map[gameLog_dateTimeField] as DateTime,
      time: Duration(minutes: map[gameLog_timeField] as int),
    );

  }

  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      gameLog_dateTimeField : dateTime,
      gameLog_timeField : time.inSeconds,
    };

  }

  static List<TimeLogEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<TimeLogEntity> timeLogsList = <TimeLogEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final TimeLogEntity log = TimeLogEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, gameLogTable) );

      timeLogsList.add(log);
    });

    return timeLogsList;

  }

  @override
  List<Object> get props => <Object>[
    dateTime,
    time,
  ];

  @override
  String toString() {

    return '{$gameLogTable}Entity { '
        '$gameLog_dateTimeField: $dateTime, '
        '$gameLog_timeField: $time'
        ' }';

  }
}

// ignore: must_be_immutable
class GameWithLogsEntity extends Equatable {
  GameWithLogsEntity({
    required this.game,
    List<TimeLogEntity>? timeLogs,
  }) {

    this.timeLogs = timeLogs?? <TimeLogEntity>[];

  }

  final GameEntity game;
  late List<TimeLogEntity> timeLogs;

  void addTimeLog(TimeLogEntity timeLog) {
    timeLogs.add(timeLog);
  }

  static List<GameWithLogsEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameWithLogsEntity> gamesWithLogsList = <GameWithLogsEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {

      final Map<String, dynamic> gameMap = manyMap[gameTable]!;
      gameMap[game_timeField] = 0;
      final GameEntity gameEntity = GameEntity.fromDynamicMap(gameMap);

      final Map<String, dynamic> timeLogMap = CollectionItemEntity.combineMaps(manyMap, gameLogTable);
      final TimeLogEntity timeLogEntity = TimeLogEntity.fromDynamicMap(timeLogMap);

      GameWithLogsEntity gameWithLogs;
      try {
        gameWithLogs = gamesWithLogsList.singleWhere((GameWithLogsEntity tempGameWithLogs) => tempGameWithLogs.game.id == gameEntity.id);
      } catch(IterableElementError) {
        gameWithLogs = GameWithLogsEntity(game: gameEntity);
        gamesWithLogsList.add(gameWithLogs);
      }

      gameWithLogs.addTimeLog(timeLogEntity);

    });

    return gamesWithLogsList;

  }

  @override
  List<Object> get props => <Object>[
    game,
    timeLogs,
  ];

  @override
  String toString() {

    return 'GameWithLogsEntity { '
        'game: $game, '
        'timeLogs: $timeLogs'
        ' }';

  }
}