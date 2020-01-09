import 'package:flutter/material.dart';

import 'entity.dart';
import 'package:game_collection/entity_view/dlc_view.dart';

const String dlcTable = "DLC";

const List<String> dlcFields = [IDField, nameField, releaseYearField,
  coverField, finishDateField, baseGameField];

const String nameField = 'Name';
const String releaseYearField = 'Release Year';
const String coverField = 'Cover';
const String finishDateField = 'Finish Date';

const String baseGameField = 'Base Game';

class DLC extends Entity {

  final String name;
  final int releaseYear;
  final dynamic cover;
  final DateTime finishDate;

  final int baseGame;

  DLC({@required int ID, this.name, this.releaseYear, this.cover, this.finishDate,
    this.baseGame}) : super(ID: ID);

  factory DLC.fromDynamicMap(Map<String, dynamic> map) {

    return DLC(
      ID: map[IDField],
      name: map[nameField],
      releaseYear: map[releaseYearField],
      cover: map[coverField],
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
  Widget getEssentialInfo({Function handleDelete}) {
    return ListTile(
      title: Text(this.name),
      trailing: FlatButton(
        child: Text("Delete", style: TextStyle(color: Colors.white),),
        color: Colors.red,
        onPressed: handleDelete,
      ),
    );
  }

  @override
  Widget getCard(BuildContext context, {Function handleDelete}) {

    return GestureDetector(
      child: Card(
        child: ListTile(
          title: this.getEssentialInfo(handleDelete: handleDelete),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) =>
              DLCView(
                dlc: this,
              )
          ),
        );
      },
    );

  }

}