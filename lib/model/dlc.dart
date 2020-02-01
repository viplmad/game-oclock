import 'package:meta/meta.dart';

import 'entity.dart';

const String dlcTable = "DLC";

const List<String> dlcFields = [
  IDField,
  nameField,
  releaseYearField,
  coverField,
  finishDateField,
  baseGameField,
];

const String nameField = 'Name';
const String releaseYearField = 'Release Year';
const String coverField = 'Cover';
const String finishDateField = 'Finish Date';

const String baseGameField = 'Base Game';

class DLC extends Entity {

  final String name;
  final int releaseYear;
  final DateTime finishDate;

  final int baseGame;

  DLC({
    @required int ID,
    this.name,
    this.releaseYear,
    this.finishDate,

    this.baseGame,
  }) : super(ID: ID);

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

  static DLC fromDynamicMap(Map<String, dynamic> map) {

    return DLC(
      ID: map[IDField],
      name: map[nameField],
      releaseYear: map[releaseYearField],
      finishDate: map[finishDateField],

      baseGame: map[baseGameField],
    );

  }

  static List<DLC> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<DLC> dlcsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      DLC dlc = DLC.fromDynamicMap(map[dlcTable]);

      dlcsList.add(dlc);
    });

    return dlcsList;

  }

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
        '$nameField: $name, '
        '$releaseYearField: $releaseYear, '
        '$finishDateField: $finishDate'
        ' }';

  }

}