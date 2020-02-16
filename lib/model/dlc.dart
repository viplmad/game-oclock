import 'package:meta/meta.dart';

import 'package:game_collection/entity/collection_item_entity.dart';
import 'package:game_collection/entity/dlc_entity.dart';

import 'collection_item.dart';


enum DLCView {
  Main,
}

const List<String> dlcViews = [
  "Main",
];

class DLC extends CollectionItem {

  DLC({
    @required int ID,
    this.name,
    this.releaseYear,
    this.finishDate,

    this.baseGame,
  }) : super(ID: ID);

  final String name;
  final int releaseYear;
  final DateTime finishDate;

  final int baseGame;

  static DLC fromEntity(DLCEntity entity) {

    return DLC(
      ID: entity.ID,
      name: entity.name,
      releaseYear: entity.releaseYear,
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
      finishDate: this.finishDate,

      baseGame: this.baseGame,
    );

  }

  @override
  DLC copyWith({
    String name,
    int releaseYear,
    DateTime finishDate,

    int baseGame,
  }) {

    return DLC(
      ID: ID,
      name: name?? this.name,
      releaseYear: releaseYear?? this.releaseYear,
      finishDate: finishDate?? this.finishDate,

      baseGame: baseGame?? this.baseGame,
    );

  }

  @override
  String getUniqueID() {

    return 'D' + this.ID.toString();

  }

  @override
  String getTitle() => this.name;

  @override
  List<Object> get props => [
    ID,
    name,
    releaseYear,
    finishDate,
  ];

  @override
  String toString() {

    return '$dlcTable { '
        '$IDField: $ID, '
        '$dlc_nameField: $name, '
        '$dlc_releaseYearField: $releaseYear, '
        '$dlc_finishDateField: $finishDate'
        ' }';

  }

}