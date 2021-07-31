import 'model.dart' show Item, ItemImage, ItemData, YearData;


enum GameStatus {
  LowPriority,
  NextUp,
  Playing,
  Played,
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
    required this.saveFolder,
    required this.screenshotFolder,
    required this.isBackup,
    required this.firstFinishDate,
    required this.totalTime,
  }) : this.uniqueId = 'G$id';

  final int id;
  final String name;
  final String edition;
  final int? releaseYear;
  final String? coverURL;
  final String? coverFilename;
  final GameStatus status;
  final int rating;
  final String thoughts;
  final String saveFolder;
  final String screenshotFolder;
  final bool isBackup;
  final DateTime? firstFinishDate;
  final Duration totalTime;

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
    GameStatus? status,
    int? rating,
    String? thoughts,
    String? saveFolder,
    String? screenshotFolder,
    bool? isBackup,
    DateTime? firstFinishDate,
    Duration? totalTime,
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
      saveFolder: saveFolder?? this.saveFolder,
      screenshotFolder: screenshotFolder?? this.screenshotFolder,
      isBackup: isBackup?? this.isBackup,
      firstFinishDate: firstFinishDate?? this.firstFinishDate,
      totalTime: totalTime?? this.totalTime,
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
    saveFolder,
    screenshotFolder,
    isBackup,
    firstFinishDate?? DateTime(1970),
    totalTime,
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
        'Save Folder: $saveFolder, '
        'Screenshot Folder: $screenshotFolder, '
        'Backup: $isBackup, '
        'Total Time: $totalTime, '
        'First Finish Date: $firstFinishDate'
        ' }';

  }
}

class GamesData extends ItemData<Game> {
  GamesData(List<Game> items)
      : this.finishYears = (items.map<int>((Game item) => item.firstFinishDate?.year?? -1).toSet()..removeWhere((int? year) => year == -1)).toList(growable: false)..sort(),
        super(items);

  final List<int> finishYears;

  int lowPriorityCount() {
    final int lowPriorityCount = items.where((Game item) => item.status == GameStatus.LowPriority).length;

    return lowPriorityCount;
  }

  int nextUpCount() {
    final int nextUpCount = items.where((Game item) => item.status == GameStatus.NextUp).length;

    return nextUpCount;
  }

  int playingCount() {
    final int playingCount = items.where((Game item) => item.status == GameStatus.Playing).length;

    return playingCount;
  }

  int playedCount() {
    final int playedCount = items.where((Game item) => item.status == GameStatus.Played).length;

    return playedCount;
  }

  int minutesSum() {
    final int minutesSum = items.fold(0, (int previousMinutes, Game item) => previousMinutes + item.totalTime.inMinutes);

    return minutesSum;
  }

  int ratingSum() {
    final int ratingSum = items.fold(0, (int previousValue, Game item) => previousValue + item.rating);

    return ratingSum;
  }

  List<int> yearlyRatingAverage(List<int> years) {

    return yearlyFieldSum<int>(
      years,
      (Game item, int year) => item.firstFinishDate?.year == year,
      0,
      (Game item) => item.rating,
      sumOperation: (int yearSum, int length) => (length > 0)? yearSum ~/ length : 0,
    );

  }

  List<int> yearlyHoursSum(List<int> years) {

    return yearlyFieldSum<int>(
      years,
      (Game item, int year) => item.firstFinishDate?.year == year,
      0,
      (Game item) => item.totalTime.inMinutes,
      sumOperation: (int yearSum, int length) => yearSum ~/ 60,
    );

  }

  List<int> yearlyFinishDateCount(List<int> years) {

    return yearlyItemCount(
      years,
      (Game item, int year) => item.firstFinishDate?.year == year,
    );

  }

  YearData<int> monthlyHoursSum() {

    return monthlyFieldSum<int>(
      (Game item, int month) => item.firstFinishDate?.month == month,
      0,
      (Game item) => item.totalTime.inMinutes,
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
      (Game item) => item.totalTime.inHours,
    );

  }
}