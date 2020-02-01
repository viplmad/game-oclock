import 'package:meta/meta.dart';

import 'entity.dart';

const String gameTable = "Game";

const List<String> gameFields = [
  IDField,
  nameField,
  editionField,
  releaseYearField,
  coverField,
  statusField,
  ratingField,
  thoughtsField,
  timeField,
  saveFolderField,
  screenshotFolderField,
  finishDateField,
  backupField,
];

const String nameField = 'Name';
const String editionField = 'Edition';
const String releaseYearField = 'Release Year';
const String coverField = 'Cover';
const String statusField = 'Status';
const String ratingField = 'Rating';
const String thoughtsField = 'Thoughts';
const String timeField = 'Time';
const String saveFolderField = 'Save Folder';
const String screenshotFolderField = 'Screenshot Folder';
const String finishDateField = 'Finish Date';
const String backupField = 'Backup';

const List<String> statuses = [
  "Low Priority",
  "Next Up",
  "Playing",
  "Played",
];

class Game extends Entity {

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

  Game({
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

  @override
  Game copyWith({
    String name,
    String edition,
    int releaseYear,
    String status,
    int rating,
    String thoughts,
    Duration time,
    String saveFolder,
    String screenshotFolder,
    DateTime finishDate,
    bool isBackup,
  }) {

    return Game(
      ID: ID,
      name: name?? this.name,
      edition: edition?? this.edition,
      releaseYear: releaseYear?? this.releaseYear,
      status: status?? this.status,
      rating: rating?? this.rating,
      thoughts: thoughts?? this.thoughts,
      time: time?? this.time,
      saveFolder: saveFolder?? this.saveFolder,
      screenshotFolder: screenshotFolder?? this.screenshotFolder,
      finishDate: finishDate?? this.finishDate,
      isBackup: isBackup?? this.isBackup,
    );

  }

  @override
  String getUniqueID() {

    return 'G' + this.ID.toString();

  }

  @override
  String getTitle() {

    if(this.edition == '') {
      return this.name;
    }

    return this.name + " - " + this.edition;

  }

  @override
  String getSubtitle() {

    return this.status?? "";

  }

  static Game fromDynamicMap(Map<String, dynamic> map) {

    return Game(
      ID: map[IDField],
      name: map[nameField],
      edition: map[editionField],
      releaseYear: map[releaseYearField],
      status: map[statusField],
      rating: map[ratingField],
      thoughts: map[thoughtsField],
      time: Duration(minutes: map[timeField]),
      saveFolder: map[saveFolderField],
      screenshotFolder: map[screenshotFolderField],
      finishDate: map[finishDateField],
      isBackup: map[backupField],
    );

  }

  static List<Game> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<Game> gamesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      Map<String, dynamic> _tempFixMap = Map.from(map[gameTable]);
      _tempFixMap.addAll(
        map[null],
      );

      Game game = Game.fromDynamicMap(_tempFixMap);

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

    return '$gameTable { '
        '$IDField: $ID, '
        '$nameField: $name, '
        '$editionField: $edition, '
        '$releaseYearField: $releaseYear, '
        '$statusField: $status, '
        '$ratingField: $rating, '
        '$thoughtsField: $thoughts, '
        '$timeField: $time, '
        '$saveFolderField: $saveFolder, '
        '$screenshotFolderField: $screenshotFolder, '
        '$finishDateField: $finishDate, '
        '$backupField: $isBackup'
        ' }';

  }

}