import 'package:flutter/material.dart';

import 'entity.dart';
import 'package:game_collection/entity_view/game_view.dart';

const String gameTable = "Game";

const List<String> gameFields = [IDField, nameField, editionField, releaseYearField, coverField,
  statusField, ratingField, thoughtsField, timeField, saveFolderField,
  screenshotFolderField, finishDateField, backupField];

const String nameField = 'Name';
const String editionField = 'Edition';
const String releaseYearField = 'Release Year';
const String coverField = 'Cover';
const String statusField = 'Status';
const String ratingField = 'Rating';
const String thoughtsField = 'Thoughts';
const String timeField = 'Time';
const String saveFolderField = 'Save Folder';
const String screenshotFolderField = 'Screenshot Folder';
const String finishDateField = 'Finish Date';
const String backupField = 'Backup';

class Game extends Entity {

  final String name;
  final String edition;
  final int releaseYear;
  final dynamic cover;
  final String status;
  final int rating;
  final String thoughts;
  final int time;
  final String saveFolder;
  final String screenshotFolder;
  final DateTime finishDate;
  final bool isBackup;

  Game({@required int ID, this.name, this.edition, this.releaseYear, this.cover,
    this.status, this.rating, this.thoughts, this.time, this.saveFolder,
    this.screenshotFolder, this.finishDate, this.isBackup}) : super(ID: ID);

  factory Game.fromDynamicMap(Map<String, dynamic> map) {

    return Game(
      ID: map[IDField],
      name: map[nameField],
      edition: map[editionField],
      releaseYear: map[releaseYearField],
      cover: map[coverField],
      status: map[statusField],
      rating: map[ratingField],
      thoughts: map[thoughtsField],
      //time: map[timeField],
      saveFolder: map[saveFolderField],
      screenshotFolder: map[screenshotFolderField],
      finishDate: map[finishDateField],
      isBackup: map[backupField],
    );

  }

  static List<Game> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<Game> gamesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      Game game = Game.fromDynamicMap(map[gameTable]);

      gamesList.add(game);
    });

    return gamesList;

  }

  @override
  String getFormattedTitle() {

    if(this.edition == '') {
      return this.name;
    }

    return this.name + " - " + this.edition;

  }

  @override
  String getFormattedSubtitle() {

    return this.status;

  }

  @override
  Widget entityBuilder(BuildContext context) {

    return GameView(
      game: this,
    );

  }

}