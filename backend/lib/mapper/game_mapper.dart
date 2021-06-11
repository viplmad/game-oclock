import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart';


class GameMapper {
  GameMapper._();

  static GameEntity modelToEntity(Game model) {

    return GameEntity(
      id: model.id,
      name: model.name,
      edition: model.edition,
      releaseYear: model.releaseYear,
      coverFilename: model.coverFilename,
      status: model.status,
      rating: model.rating,
      thoughts: model.thoughts,
      time: model.time,
      saveFolder: model.saveFolder,
      screenshotFolder: model.screenshotFolder,
      finishDate: model.finishDate,
      isBackup: model.isBackup,
    );

  }

  static Game entityToModel(GameEntity entity, [String? coverURL]) {

    return Game(
      id: entity.id,
      name: entity.name,
      edition: entity.edition,
      releaseYear: entity.releaseYear,
      coverURL: coverURL,
      coverFilename: entity.coverFilename,
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

  static GameFinishEntity finishModelToEntity(GameFinish model) {

    return GameFinishEntity(
      dateTime: model.dateTime,
    );

  }

  static GameFinish finishEntityToModel(GameFinishEntity entity) {

    return GameFinish(
      dateTime: entity.dateTime,
    );

  }

  static GameTimeLogEntity logModelToEntity(GameTimeLog model) {

    return GameTimeLogEntity(
      dateTime: model.dateTime,
      time: model.time,
    );

  }

  static GameTimeLog logEntityToModel(GameTimeLogEntity entity) {

    return GameTimeLog(
      dateTime: entity.dateTime,
      time: entity.time,
    );

  }

  static GameWithLogsEntity gameWithLogModelToEntity(GameWithLogs model) {

    return GameWithLogsEntity(
      game: modelToEntity(model.game),
      timeLogs: model.timeLogs.map<GameTimeLogEntity>( logModelToEntity ).toList(growable: false),
    );

  }

  static GameWithLogs gameWithLogEntityToModel(GameWithLogsEntity entity, [String? coverURL]) {

    return GameWithLogs(
      game: entityToModel(entity.game, coverURL),
      timeLogs: entity.timeLogs.map<GameTimeLog>( logEntityToModel ).toList(),
    );

  }
}