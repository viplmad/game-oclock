import 'model.dart' show Item, ItemImage;


class DLC extends Item {
  const DLC({
    required this.id,
    required this.name,
    required this.releaseYear,
    required this.coverURL,
    required this.coverFilename,
    required this.baseGame,
    required this.firstFinishDate,
  }) : super(
    uniqueId: 'D$id',
    hasImage: true,
    queryableTerms: name,
  );

  final int id;
  final String name;
  final int? releaseYear;
  final String? coverURL;
  final String? coverFilename;
  final int? baseGame;
  final DateTime? firstFinishDate;

  @override
  ItemImage get image => ItemImage(this.coverURL, this.coverFilename);

  @override
  DLC copyWith({
    String? name,
    int? releaseYear,
    String? coverURL,
    String? coverFilename,
    int? baseGame,
    DateTime? firstFinishDate,
  }) {

    return DLC(
      id: id,
      name: name?? this.name,
      releaseYear: releaseYear?? this.releaseYear,
      coverURL: coverURL?? this.coverURL,
      coverFilename: coverFilename?? this.coverFilename,
      baseGame: baseGame?? this.baseGame,
      firstFinishDate: firstFinishDate?? this.firstFinishDate,
    );

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
    releaseYear?? -1,
    coverURL?? '',
    firstFinishDate?? DateTime(1970),
  ];

  @override
  String toString() {

    return 'DLC { '
        'Id: $id, '
        'Name: $name, '
        'Release Year: $releaseYear, '
        'Cover URL: $coverURL, '
        'First Finish Date: $firstFinishDate'
        ' }';

  }
}