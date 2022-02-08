import 'model.dart' show Item, ItemImage;


enum GameStatus {
  lowPriority,
  nextUp,
  playing,
  played,
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
  }) : super(
    uniqueId: 'G$id',
    hasImage: true,
    queryableTerms: name + edition,
  );

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
  ItemImage get image => ItemImage(coverURL, coverFilename);

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