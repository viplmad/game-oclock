import 'package:meta/meta.dart';

import 'entity.dart';


const String dlcTable = "DLC";

const List<String> dlcFields = [
  IDField,
  dlc_nameField,
  dlc_releaseYearField,
  dlc_coverField,
  dlc_finishDateField,
  dlc_baseGameField,
];

const String dlc_nameField = 'Name';
const String dlc_releaseYearField = 'Release Year';
const String dlc_coverField = 'Cover';
const String dlc_finishDateField = 'Finish Date';

const String dlc_baseGameField = 'Base Game';

class DLCEntity extends CollectionItemEntity {

  DLCEntity({
    @required int id,
    this.name,
    this.releaseYear,
    this.coverFilename,
    this.finishDate,

    this.baseGame,
  }) : super(id: id);

  final String name;
  final int releaseYear;
  final String coverFilename;
  final DateTime finishDate;

  final int baseGame;

  static DLCEntity fromDynamicMap(Map<String, dynamic> map) {

    return DLCEntity(
      id: map[IDField],
      name: map[dlc_nameField],
      releaseYear: map[dlc_releaseYearField],
      coverFilename: map[dlc_coverField],
      finishDate: map[dlc_finishDateField],

      baseGame: map[dlc_baseGameField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IDField : id,
      dlc_nameField : name,
      dlc_releaseYearField : releaseYear,
      dlc_coverField : coverFilename,
      dlc_finishDateField : finishDate,

      dlc_baseGameField : baseGame,
    };

  }

  static List<DLCEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<DLCEntity> dlcsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      DLCEntity dlc = DLCEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, dlcTable) );

      dlcsList.add(dlc);
    });

    return dlcsList;

  }

  @override
  List<Object> get props => [
    id,
    name,
    releaseYear,
    coverFilename,
    finishDate,
  ];

  @override
  String toString() {

    return '{$dlcTable}Entity { '
        '$IDField: $id, '
        '$dlc_nameField: $name, '
        '$dlc_releaseYearField: $releaseYear, '
        '$dlc_coverField: $coverFilename, '
        '$dlc_finishDateField: $finishDate'
        ' }';

  }

}