import 'package:meta/meta.dart';

import 'package:game_collection/entity/collection_item_entity.dart';
import 'package:game_collection/entity/game_entity.dart';

import 'collection_item.dart';


enum GameView {
  Main,
  LastCreated,
  Playing,
  NextUp,
  LastFinished,
  Review2019,
}

class Game extends CollectionItem {

  Game({
    @required int ID,
    this.name,
    this.edition,
    this.releaseYear,
    this.coverURL,
    this.coverFilename,
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
  final String coverURL;
  final String coverFilename;
  final String status;
  final int rating;
  final String thoughts;
  final Duration time;
  final String saveFolder;
  final String screenshotFolder;
  final DateTime finishDate;
  final bool isBackup;

  static Game fromEntity(GameEntity entity, [String coverURL]) {

    return Game(
      ID: entity.ID,
      name: entity.name,
      edition: entity.edition,
      releaseYear: entity.releaseYear,
      coverURL: coverURL,
      coverFilename: entity.coverFilename,
      status: entity.status,
      rating: entity.rating,
      thoughts: entity.thoughts,
      time: entity.time,
      saveFolder: entity.saveFolder,
      screenshotFolder: entity.screenshotFolder,
      finishDate: entity.finishDate,
      isBackup: entity.isBackup,
    );

  }

  @override
  GameEntity toEntity() {

    return GameEntity(
      ID: this.ID,
      name: this.name,
      edition: this.edition,
      releaseYear: this.releaseYear,
      coverFilename: this.coverFilename,
      status: this.status,
      rating: this.rating,
      thoughts: this.thoughts,
      time: this.time,
      saveFolder: this.saveFolder,
      screenshotFolder: this.screenshotFolder,
      finishDate: this.finishDate,
      isBackup: this.isBackup,
    );

  }

  @override
  Game copyWith({
    String name,
    String edition,
    int releaseYear,
    String coverURL,
    String coverName,
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
      coverURL: coverURL?? this.coverURL,
      coverFilename: coverName?? this.coverFilename,
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

    return (this.status?? "") + " · " + this.releaseYear.toString();

  }

  @override
  String getImageURL() {

    return this.coverURL?? '';

  }

  @override
  String getImageFilename() {

    return this.coverFilename;

  }

  @override
  List<Object> get props => [
    ID,
    name,
    edition,
    releaseYear,
    coverURL,
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
        '$game_nameField: $name, '
        '$game_editionField: $edition, '
        '$game_releaseYearField: $releaseYear, '
        '$game_coverField: $coverURL, '
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

class GamesData {

  GamesData({
    this.games,
  });

  final List<Game> games;

  GamesDataYear getYearData(int year) {
    List<Game> yearItems = games.where((Game item) => item.finishDate?.year == year).toList(growable: false);

    return GamesDataYear(yearItems);
  }
}

class GamesDataYear {
  GamesDataYear(this.items);

  final List<Game> items;
  int get length => items.length;

  int getLowPriorityGamesCount() {
    int lowPriorityGames = items.where((item) => item.status == statuses.elementAt(0)).length;

    return lowPriorityGames;
  }

  int getNextUpGamesCount() {
    int nextUpGames = items.where((Game item) => item.status == statuses.elementAt(1)).length;

    return nextUpGames;
  }

  int getPlayingGamesCount() {
    int playingGames = items.where((Game item) => item.status == statuses.elementAt(2)).length;

    return playingGames;
  }

  int getPlayedGamesCount() {
    int playedGames = items.where((Game item) => item.status == statuses.elementAt(3)).length;

    return playedGames;
  }

  int getTotalMinutes() {
    int totalMinutes = items.fold(0, (int previousMinutes, Game item) => previousMinutes + item.time.inMinutes);

    return totalMinutes;
  }

  List<int> getIntervalRating(List<int> intervals) {
    List<int> values = List<int>(intervals.length);

    for(int index = 0; index < intervals.length; index++) {
      int rating = intervals.elementAt(index);

      int intervalSum = items.where((Game item) => item.rating == rating).length;

      values[index] = intervalSum;
    }

    return values;
  }

  List<int> getIntervalReleaseYears(List<int> intervals) {
    List<int> values = List<int>(intervals.length);

    for(int index = 0; index < intervals.length; index++) {
      int minYear = intervals.elementAt(index);

      int maxYear = 10000;
      if(intervals.length != index + 1) {
        maxYear = intervals.elementAt(index + 1);
      }

      int intervalSum = items.where((Game item) => item.releaseYear >= minYear && item.releaseYear <= maxYear).length;

      values[index] = intervalSum;
    }

    return values;
  }

  List<int> getIntervalTime(List<int> intervals) {
    List<int> values = List<int>(intervals.length);

    for(int index = 0; index < intervals.length; index++) {
      int minDuration = intervals.elementAt(index);

      int maxDuration = 10000;
      if(intervals.length != index + 1) {
        maxDuration = intervals.elementAt(index + 1);
      }

      int intervalSum = items.where((Game item) => item.time >= Duration(hours: minDuration) && item.time < Duration(hours: maxDuration)).length;

      values[index] = intervalSum;
    }

    return values;
  }
}