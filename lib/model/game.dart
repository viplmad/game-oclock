import 'package:meta/meta.dart';

import 'package:game_collection/entity/collection_item_entity.dart';
import 'package:game_collection/entity/game_entity.dart';

import 'collection_item.dart';


class Game extends CollectionItem {

  Game({
    @required int ID,
    this.name,
    this.edition,
    this.releaseYear,
    this.status,
    this.rating,
    this.thoughts,
    this.time,
    this.saveFolder,
    this.screenshotFolder,
    this.finishDate,
    this.isBackup,
  }) : super(ID: ID);

  final String name;
  final String edition;
  final int releaseYear;
  final String status;
  final int rating;
  final String thoughts;
  final Duration time;
  final String saveFolder;
  final String screenshotFolder;
  final DateTime finishDate;
  final bool isBackup;

  static Game fromEntity(GameEntity entity) {

    return Game(
      ID: entity.ID,
      name: entity.name,
      edition: entity.edition,
      releaseYear: entity.releaseYear,
      status: entity.status,
      rating: entity.rating,
      thoughts: entity.thoughts,
      time: entity.time,
      saveFolder: entity.saveFolder,
      screenshotFolder: entity.screenshotFolder,
      finishDate: entity.finishDate,
      isBackup: entity.isBackup,
    );

  }

  @override
  GameEntity toEntity() {

    return GameEntity(
      ID: this.ID,
      name: this.name,
      edition: this.edition,
      releaseYear: this.releaseYear,
      status: this.status,
      rating: this.rating,
      thoughts: this.thoughts,
      time: this.time,
      saveFolder: this.saveFolder,
      screenshotFolder: this.screenshotFolder,
      finishDate: this.finishDate,
      isBackup: this.isBackup,
    );

  }

  @override
  Game copyWith({
    String name,
    String edition,
    int releaseYear,
    String status,
    int rating,
    String thoughts,
    Duration time,
    String saveFolder,
    String screenshotFolder,
    DateTime finishDate,
    bool isBackup,
  }) {

    return Game(
      ID: ID,
      name: name?? this.name,
      edition: edition?? this.edition,
      releaseYear: releaseYear?? this.releaseYear,
      status: status?? this.status,
      rating: rating?? this.rating,
      thoughts: thoughts?? this.thoughts,
      time: time?? this.time,
      saveFolder: saveFolder?? this.saveFolder,
      screenshotFolder: screenshotFolder?? this.screenshotFolder,
      finishDate: finishDate?? this.finishDate,
      isBackup: isBackup?? this.isBackup,
    );

  }

  @override
  String getUniqueID() {

    return 'G' + this.ID.toString();

  }

  @override
  String getTitle() {

    if(this.edition == '') {
      return this.name;
    }

    return this.name + " - " + this.edition;

  }

  @override
  String getSubtitle() {

    return this.status?? "";

  }

  @override
  List<Object> get props => [
    ID,
    name,
    edition,
    releaseYear,
    status,
    rating,
    thoughts,
    time,
    saveFolder,
    screenshotFolder,
    finishDate,
    isBackup,
  ];

  @override
  String toString() {

    return '$gameTable { '
        '$IDField: $ID, '
        '$game_nameField: $name, '
        '$game_editionField: $edition, '
        '$game_releaseYearField: $releaseYear, '
        '$game_statusField: $status, '
        '$game_ratingField: $rating, '
        '$game_thoughtsField: $thoughts, '
        '$game_timeField: $time, '
        '$game_saveFolderField: $saveFolder, '
        '$game_screenshotFolderField: $screenshotFolder, '
        '$game_finishDateField: $finishDate, '
        '$game_backupField: $isBackup'
        ' }';

  }

}