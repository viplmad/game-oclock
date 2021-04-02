import 'entity.dart';


const String dlcTable = 'DLC';
const String dlcTableRead = '_DLC';

const List<String> dlcFields = [
  idField,
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

const String dlcFinishTable = 'DLCFinish';
const String dlcFinishTableRead = 'DLC-Finish';
const List<String> dlcFinishFields = [
  dlcFinish_dlcField,
  dlcFinish_dateField,
];
const String dlcFinish_dlcField = 'DLC_ID';
const String dlcFinish_dateField = 'Date';

class DLCEntity extends CollectionItemEntity {
  const DLCEntity({
    required int id,
    required this.name,
    required this.releaseYear,
    required this.coverFilename,
    required this.finishDate,

    required this.baseGame,
  }) : super(id: id);

  final String name;
  final int? releaseYear;
  final String? coverFilename;
  final DateTime? finishDate;

  final int? baseGame;

  static DLCEntity fromDynamicMap(Map<String, dynamic> map) {

    return DLCEntity(
      id: map[idField],
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
      idField : id,
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
  ];

  @override
  String toString() {

    return '{$dlcTable}Entity { '
        '$idField: $id, '
        '$dlc_nameField: $name, '
        '$dlc_releaseYearField: $releaseYear, '
        '$dlc_coverField: $coverFilename, '
        '$dlc_finishDateField: $finishDate'
        ' }';

  }
}