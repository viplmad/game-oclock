import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


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
    @required int id,
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
  }) : super(id: id);

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

  @override
  String get uniqueId => 'G' + this.id.toString();

  @override
  final bool hasImage = true;
  @override
  ItemImage get image => ItemImage(this.coverURL, this.coverFilename);

  @override
  String get queryableTerms => [this.name, this.edition].join(',');

  static Game fromEntity(GameEntity entity, [String coverURL]) {

    return Game(
      id: entity.id,
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
      id: this.id,
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
      id: id,
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
  List<Object> get props => [
    id,
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
        '$IdField: $id, '
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

class GamesData extends ItemData<Game> {
  GamesData(List<Game> items) : super(items);
  
  List<int> finishYears() {
    
    return (items.map<int>((Game item) => item.finishDate?.year).toSet()..removeWhere((int year) => year == null)).toList(growable: false).reversed.toList(growable: false);
    
  }

  int lowPriorityCount() {
    int lowPriorityGames = items.where((item) => item.status == statuses.elementAt(0)).length;

    return lowPriorityGames;
  }

  int nextUpCount() {
    int nextUpGames = items.where((Game item) => item.status == statuses.elementAt(1)).length;

    return nextUpGames;
  }

  int playingCount() {
    int playingGames = items.where((Game item) => item.status == statuses.elementAt(2)).length;

    return playingGames;
  }

  int playedCount() {
    int playedGames = items.where((Game item) => item.status == statuses.elementAt(3)).length;

    return playedGames;
  }

  int minutesSum() {
    int totalMinutes = items.fold(0, (int previousMinutes, Game item) => previousMinutes + item.time.inMinutes);

    return totalMinutes;
  }

  int totalRating() {
    int totalRating = items.fold(0, (int previousValue, Game item) => previousValue + item.rating);

    return totalRating;
  }

  List<int> intervalRating(List<int> intervals) {
    List<int> values = List<int>(intervals.length);

    for(int index = 0; index < intervals.length; index++) {
      int rating = intervals.elementAt(index);

      int intervalSum = items.where((Game item) => item.rating == rating).length;

      values[index] = intervalSum;
    }

    return values;
  }

  List<int> intervalReleaseYears(List<int> intervals) {
    List<int> values = List<int>(intervals.length);

    for(int index = 0; index < intervals.length; index++) {
      int minYear = intervals.elementAt(index);

      int maxYear = 10000;
      if(intervals.length != index + 1) {
        maxYear = intervals.elementAt(index + 1);
      }

      int intervalSum = items.where((Game item) => item.releaseYear >= minYear && item.releaseYear < maxYear).length;

      values[index] = intervalSum;
    }

    return values;
  }

  List<int> intervalTime(List<int> intervals) {
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

  List<int> yearlySumHours(List<int> years) {
    List<int> values = List<int>(years.length);

    for(int index = 0; index < years.length; index++) {
      int year = years.elementAt(index);

      List<Game> yearItems = items.where((Game item) => item.finishDate?.year == year).toList(growable: false);
      int minutesSum = yearItems.fold(0, (int previousValue, Game item) => previousValue + item.time.inMinutes);
      int yearSum = minutesSum ~/ 60;

      values[index] = yearSum;
    }

    return values;
  }

  List<int> yearlyCountFinishDate(List<int> years) {
    List<int> values = List<int>(years.length);

    for(int index = 0; index < years.length; index++) {
      int year = years.elementAt(index);

      int yearSum = items.where((Game item) => item.finishDate?.year == year).length;

      values[index] = yearSum;
    }

    return values;
  }

  YearData<int> monthlySumHours() {
    YearData<int> yearData = YearData<int>();

    for(int month = 1; month <= 12; month++) {

      List<Game> monthItems = items.where((Game item) => item.finishDate?.month == month).toList(growable: false);
      int minutesSum = monthItems.fold(0, (int previousValue, Game item) => previousValue + item.time.inMinutes);
      int monthSum = minutesSum ~/ 60;

      yearData.addData(monthSum);
    }

    return yearData;
  }
}