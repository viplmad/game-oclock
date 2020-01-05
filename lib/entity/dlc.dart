import 'package:flutter/material.dart';

import 'entity.dart';

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
}