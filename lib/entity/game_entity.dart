import 'package:meta/meta.dart';

import 'collection_item_entity.dart';


const String gameTable = "Game";

const List<String> gameFields = [
  IDField,
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

const List<String> statuses = [
  "Low Priority",
  "Next Up",
  "Playing",
  "Played",
];

class GameEntity extends CollectionItemEntity {

  GameEntity({
    @required int ID,
    this.name,
    this.edition,
    this.releaseYear,
    this.status,
    this.rating,
    this.thoughts,
    this.time,
    this.saveFolder,
    this.screenshotFolder,
    this.finishDate,
    this.isBackup,
  }) : super(ID: ID);

  final String name;
  final String edition;
  final int releaseYear;
  final String status;
  final int rating;
  final String thoughts;
  final Duration time;
  final String saveFolder;
  final String screenshotFolder;
  final DateTime finishDate;
  final bool isBackup;

  static GameEntity fromDynamicMap(Map<String, dynamic> map) {

    return GameEntity(
      ID: map[IDField],
      name: map[game_nameField],
      edition: map[game_editionField],
      releaseYear: map[game_releaseYearField],
      status: map[game_statusField],
      rating: map[game_ratingField],
      thoughts: map[game_thoughtsField],
      time: Duration(minutes: map[game_timeField]),
      saveFolder: map[game_saveFolderField],
      screenshotFolder: map[game_screenshotFolderField],
      finishDate: map[game_finishDateField],
      isBackup: map[game_backupField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IDField : ID,
      game_nameField : name,
      game_editionField : edition,
      game_releaseYearField : releaseYear,
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

    List<GameEntity> gamesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      Map<String, dynamic> _tempFixMap = Map.from(map[gameTable]);
      _tempFixMap.addAll(
        map[null],
      );

      GameEntity game = GameEntity.fromDynamicMap(_tempFixMap);

      gamesList.add(game);
    });

    return gamesList;

  }

  @override
  List<Object> get props => [
    ID,
    name,
    edition,
    releaseYear,
    status,
    rating,
    thoughts,
    time,
    saveFolder,
    screenshotFolder,
    finishDate,
    isBackup,
  ];

  @override
  String toString() {

    return '{$gameTable}Entity { '
        '$IDField: $ID, '
        '$game_nameField: $name, '
        '$game_editionField: $edition, '
        '$game_releaseYearField: $releaseYear, '
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