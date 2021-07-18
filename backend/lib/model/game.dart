import 'package:backend/entity/entity.dart';

import 'model.dart';


enum GameView {
  Main,
  LastCreated,
  Playing,
  NextUp,
  LastPlayed,
  LastFinished,
  Review,
}

class GameID {
  GameID(this.id);

  final int id;
}

class Game extends Item {
  const Game({
    required this.id,
    required this.name,
    required this.edition,
    required this.releaseYear,
    required this.coverURL,
    required this.coverFilename,
    required this.status,
    required this.rating,
    required this.thoughts,
    required this.time,
    required this.saveFolder,
    required this.screenshotFolder,
    required this.finishDate,
    required this.isBackup,
  }) : this.uniqueId = 'G$id';

  final GameID id;
  final String name;
  final String edition;
  final int? releaseYear;
  final String? coverURL;
  final String? coverFilename;
  final String status;
  final int rating;
  final String thoughts;
  final Duration time;
  final String saveFolder;
  final String screenshotFolder;
  final DateTime? finishDate;
  final bool isBackup;

  @override
  final String uniqueId;

  @override
  final bool hasImage = true;
  @override
  ItemImage get image => ItemImage(this.coverURL, this.coverFilename);

  @override
  String get queryableTerms => <String>[this.name, this.edition].join(',');

  @override
  Game copyWith({
    String? name,
    String? edition,
    int? releaseYear,
    String? coverURL,
    String? coverFilename,
    String? status,
    int? rating,
    String? thoughts,
    Duration? time,
    String? saveFolder,
    String? screenshotFolder,
    DateTime? finishDate,
    bool? isBackup,
  }) {

    return Game(
      id: id,
      name: name?? this.name,
      edition: edition?? this.edition,
      releaseYear: releaseYear?? this.releaseYear,
      coverURL: coverURL?? this.coverURL,
      coverFilename: coverFilename?? this.coverFilename,
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
  List<Object> get props => <Object>[
    id,
    name,
    edition,
    releaseYear?? -1,
    coverURL?? '',
    status,
    rating,
    thoughts,
    time,
    saveFolder,
    screenshotFolder,
    finishDate?? DateTime(1970),
    isBackup,
  ];

  @override
  String toString() {

    return 'Game { '
        'Id: $id, '
        'Name: $name, '
        'Edition: $edition, '
        'Release Year: $releaseYear, '
        'Cover URL: $coverURL, '
        'Status: $status, '
        'Rating: $rating, '
        'Thoughts: $thoughts, '
        'Time: $time, '
        'Save Folder: $saveFolder, '
        'Screenshot Folder: $screenshotFolder, '
        'Finish Date: $finishDate, '
        'Backup: $isBackup'
        ' }';

  }
}

class GamesData extends ItemData<Game> {
  GamesData(List<Game> items)
      : this.finishYears = (items.map<int>((Game item) => item.finishDate?.year?? -1).toSet()..removeWhere((int? year) => year == -1)).toList(growable: false)..sort(),
        super(items);

  final List<int> finishYears;

  int lowPriorityCount() {
    final int lowPriorityCount = items.where((Game item) => item.status == statuses.elementAt(0)).length;

    return lowPriorityCount;
  }

  int nextUpCount() {
    final int nextUpCount = items.where((Game item) => item.status == statuses.elementAt(1)).length;

    return nextUpCount;
  }

  int playingCount() {
    final int playingCount = items.where((Game item) => item.status == statuses.elementAt(2)).length;

    return playingCount;
  }

  int playedCount() {
    final int playedCount = items.where((Game item) => item.status == statuses.elementAt(3)).length;

    return playedCount;
  }

  int minutesSum() {
    final int minutesSum = items.fold(0, (int previousMinutes, Game item) => previousMinutes + item.time.inMinutes);

    return minutesSum;
  }

  int ratingSum() {
    final int ratingSum = items.fold(0, (int previousValue, Game item) => previousValue + item.rating);

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
      (Game item) => item.releaseYear?? -1,
    );

  }

  List<int> intervalTimeCount(List<int> intervals) {

    return intervalCountWithInitialAndLast<int>(
      intervals,
      (Game item) => item.time.inHours,
    );

  }
}