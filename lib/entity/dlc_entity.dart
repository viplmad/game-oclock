import 'package:meta/meta.dart';

import 'collection_item_entity.dart';


const String dlcTable = "DLC";

const List<String> dlcFields = [
  IDField,
  dlc_nameField,
  dlc_releaseYearField,
  dlc_finishDateField,
  dlc_baseGameField,
];

const String dlc_nameField = 'Name';
const String dlc_releaseYearField = 'Release Year';
const String dlc_finishDateField = 'Finish Date';

const String dlc_baseGameField = 'Base Game';

class DLCEntity extends CollectionItemEntity {

  DLCEntity({
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

  static DLCEntity fromDynamicMap(Map<String, dynamic> map) {

    return DLCEntity(
      ID: map[IDField],
      name: map[dlc_nameField],
      releaseYear: map[dlc_releaseYearField],
      finishDate: map[dlc_finishDateField],

      baseGame: map[dlc_baseGameField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IDField : ID,
      dlc_nameField : name,
      dlc_releaseYearField : releaseYear,
      dlc_finishDateField : finishDate,

      dlc_baseGameField : baseGame,
    };

  }

  static List<DLCEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<DLCEntity> dlcsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      DLCEntity dlc = DLCEntity.fromDynamicMap(map[dlcTable]);

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

    return '{$dlcTable}Entity { '
        '$IDField: $ID, '
        '$dlc_nameField: $name, '
        '$dlc_releaseYearField: $releaseYear, '
        '$dlc_finishDateField: $finishDate'
        ' }';

  }

}