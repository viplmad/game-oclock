import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum DLCView {
  Main,
  LastCreated,
}

class DLC extends CollectionItem {
  const DLC({
    required int id,
    required this.name,
    required this.releaseYear,
    required this.coverURL,
    required this.coverFilename,
    required this.finishDate,

    required this.baseGame,
  }) : this.uniqueId = 'D$id',
        super(id: id);

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

  static DLC fromEntity(DLCEntity entity, [String? coverURL]) {

    return DLC(
      id: entity.id,
      name: entity.name,
      releaseYear: entity.releaseYear,
      coverURL: coverURL,
      coverFilename: entity.coverFilename,
      finishDate: entity.finishDate,

      baseGame: entity.baseGame,
    );

  }

  @override
  DLCEntity toEntity() {

    return DLCEntity(
      id: this.id,
      name: this.name,
      releaseYear: this.releaseYear,
      coverFilename: this.coverFilename,
      finishDate: this.finishDate,

      baseGame: this.baseGame,
    );

  }

  @override
  DLC copyWith({
    String? name,
    int? releaseYear,
    String? coverURL,
    String? coverName,
    DateTime? finishDate,

    int? baseGame,
  }) {

    return DLC(
      id: id,
      name: name?? this.name,
      releaseYear: releaseYear?? this.releaseYear,
      coverURL: coverURL?? this.coverURL,
      coverFilename: coverName?? this.coverFilename,
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

    return '$dlcTable { '
        '$idField: $id, '
        '$dlc_nameField: $name, '
        '$dlc_releaseYearField: $releaseYear, '
        '$dlc_coverField: $coverURL, '
        '$dlc_finishDateField: $finishDate'
        ' }';

  }
}