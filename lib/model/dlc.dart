import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum DLCView {
  Main,
  LastCreated,
}

class DLC extends CollectionItem {

  DLC({
    @required int ID,
    this.name,
    this.releaseYear,
    this.coverURL,
    this.coverFilename,
    this.finishDate,

    this.baseGame,
  }) : super(ID: ID);

  final String name;
  final int releaseYear;
  final String coverURL;
  final String coverFilename;
  final DateTime finishDate;

  final int baseGame;

  static DLC fromEntity(DLCEntity entity, [String coverURL]) {

    return DLC(
      ID: entity.ID,
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
      ID: this.ID,
      name: this.name,
      releaseYear: this.releaseYear,
      coverFilename: this.coverFilename,
      finishDate: this.finishDate,

      baseGame: this.baseGame,
    );

  }

  @override
  DLC copyWith({
    String name,
    int releaseYear,
    String coverURL,
    String coverName,
    DateTime finishDate,

    int baseGame,
  }) {

    return DLC(
      ID: ID,
      name: name?? this.name,
      releaseYear: releaseYear?? this.releaseYear,
      coverURL: coverURL?? this.coverURL,
      coverFilename: coverName?? this.coverFilename,
      finishDate: finishDate?? this.finishDate,

      baseGame: baseGame?? this.baseGame,
    );

  }

  @override
  String getUniqueID() {

    return 'D' + this.ID.toString();

  }

  @override
  String getTitle() {

    return this.name;

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
    releaseYear,
    coverURL,
    finishDate,
  ];

  @override
  String toString() {

    return '$dlcTable { '
        '$IDField: $ID, '
        '$dlc_nameField: $name, '
        '$dlc_releaseYearField: $releaseYear, '
        '$dlc_coverField: $coverURL, '
        '$dlc_finishDateField: $finishDate'
        ' }';

  }

}

class DLCsData {

  DLCsData({
    this.dlcs,
  });

  final List<DLC> dlcs;

}