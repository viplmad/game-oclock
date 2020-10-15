import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum DLCView {
  Main,
  LastCreated,
}

class DLC extends CollectionItem {

  DLC({
    @required int id,
    this.name,
    this.releaseYear,
    this.coverURL,
    this.coverFilename,
    this.finishDate,

    this.baseGame,
  }) : super(id: id);

  final String name;
  final int releaseYear;
  final String coverURL;
  final String coverFilename;
  final DateTime finishDate;

  final int baseGame;

  static DLC fromEntity(DLCEntity entity, [String coverURL]) {

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
    String name,
    int releaseYear,
    String coverURL,
    String coverName,
    DateTime finishDate,

    int baseGame,
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
  String getUniqueId() {

    return 'D' + this.id.toString();

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
    id,
    name,
    releaseYear,
    coverURL,
    finishDate,
  ];

  @override
  String toString() {

    return '$dlcTable { '
        '$IdField: $id, '
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