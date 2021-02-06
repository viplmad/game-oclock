import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum GameView {
  Main,
  LastCreated,
  Playing,
  NextUp,
  LastFinished,
  Review,
}

class Game extends CollectionItem {
  const Game({
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
  }) : this.uniqueId = 'G$id',
        super(id: id);

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
  final String uniqueId;

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

class TimeLog extends Equatable implements Comparable<TimeLog> {
  const TimeLog({
    this.dateTime,
    this.time,
  });

  final DateTime dateTime;
  final Duration time;

  static TimeLog fromEntity(TimeLogEntity entity) {

    return TimeLog(
      dateTime: entity.dateTime,
      time: entity.time,
    );

  }

  TimeLogEntity toEntity() {

    return TimeLogEntity(
      dateTime: this.dateTime,
      time: this.time,
    );

  }

  TimeLog copyWith({
    DateTime dateTime,
    Duration time,
  }) {

    return TimeLog(
      dateTime: dateTime?? this.dateTime,
      time: time?? this.time,
    );

  }

  @override
  List<Object> get props => [
    dateTime,
    time,
  ];

  @override
  String toString() {

    return '$gameLogTable { '
        '$dateTime: $dateTime, '
        '$game_timeField: $time'
        ' }';

  }

  @override
  int compareTo(TimeLog other) => this.dateTime.compareTo(other.dateTime);
}

class GamesData extends ItemData<Game> {
  GamesData(List<Game> items)
      : this.finishYears = (items.map<int>((Game item) => item.finishDate?.year).toSet()..removeWhere((int year) => year == null)).toList(growable: false)..sort(),
        super(items);
  
  final List<int> finishYears;

  int lowPriorityCount() {
    int lowPriorityCount = items.where((item) => item.status == statuses.elementAt(0)).length;

    return lowPriorityCount;
  }

  int nextUpCount() {
    int nextUpCount = items.where((Game item) => item.status == statuses.elementAt(1)).length;

    return nextUpCount;
  }

  int playingCount() {
    int playingCount = items.where((Game item) => item.status == statuses.elementAt(2)).length;

    return playingCount;
  }

  int playedCount() {
    int playedCount = items.where((Game item) => item.status == statuses.elementAt(3)).length;

    return playedCount;
  }

  int minutesSum() {
    int minutesSum = items.fold(0, (int previousMinutes, Game item) => previousMinutes + item.time.inMinutes);

    return minutesSum;
  }

  int ratingSum() {
    int ratingSum = items.fold(0, (int previousValue, Game item) => previousValue + item.rating);

    return ratingSum;
  }

  List<int> yearlyRatingAverage(List<int> years) {

    return yearlyFieldSum<int>(
      years,
      (Game item, int year) => item.finishDate?.year == year,
      0,
      (Game item) => item.rating,
      sumOperation: (int yearSum, int length) => (length > 0)? yearSum ~/ length : 0,
    );

  }

  List<int> yearlyHoursSum(List<int> years) {

    return yearlyFieldSum<int>(
      years,
      (Game item, int year) => item.finishDate?.year == year,
      0,
      (Game item) => item.time.inMinutes,
      sumOperation: (int yearSum, int length) => yearSum ~/ 60,
    );

  }

  List<int> yearlyFinishDateCount(List<int> years) {

    return yearlyItemCount(
      years,
      (Game item, int year) => item.finishDate?.year == year,
    );

  }

  YearData<int> monthlyHoursSum() {

    return monthlyFieldSum<int>(
      (Game item, int month) => item.finishDate?.month == month,
      0,
      (Game item) => item.time.inMinutes,
      sumOperation: (int monthSum, int length) => monthSum ~/ 60,
    );

  }

  List<int> intervalRatingCount(List<int> intervals) {

    return intervalCountEqual<int>(
      intervals,
      (Game item) => item.rating,
    );

  }

  List<int> intervalReleaseYearCount(List<int> intervals) {

    return intervalCount<int>(
      intervals,
      (Game item) => item.releaseYear,
    );

  }

  List<int> intervalTimeCount(List<int> intervals) {

    return intervalCountWithInitialAndLast<int>(
      intervals,
      (Game item) => item.time.inHours,
    );

  }
}