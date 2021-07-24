import 'model.dart' show Item, ItemImage;


class DLC extends Item {
  const DLC({
    required this.id,
    required this.name,
    required this.releaseYear,
    required this.coverURL,
    required this.coverFilename,
    required this.finishDate,

    required this.baseGame,
  }) : this.uniqueId = 'D$id';

  final int id;
  final String name;
  final int? releaseYear;
  final String? coverURL;
  final String? coverFilename;
  final DateTime? finishDate;

  final int? baseGame;

  @override
  final String uniqueId;

  @override
  final bool hasImage = true;
  @override
  ItemImage get image => ItemImage(this.coverURL, this.coverFilename);

  @override
  String get queryableTerms => this.name;

  @override
  DLC copyWith({
    String? name,
    int? releaseYear,
    String? coverURL,
    String? coverFilename,
    DateTime? finishDate,

    int? baseGame,
  }) {

    return DLC(
      id: id,
      name: name?? this.name,
      releaseYear: releaseYear?? this.releaseYear,
      coverURL: coverURL?? this.coverURL,
      coverFilename: coverFilename?? this.coverFilename,
      finishDate: finishDate?? this.finishDate,

      baseGame: baseGame?? this.baseGame,
    );

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
    releaseYear?? -1,
    coverURL?? '',
    finishDate?? DateTime(1970),
  ];

  @override
  String toString() {

    return 'DLC { '
        'Id: $id, '
        'Name: $name, '
        'Release Year: $releaseYear, '
        'Cover URL: $coverURL, '
        'Finish Date: $finishDate'
        ' }';

  }
}