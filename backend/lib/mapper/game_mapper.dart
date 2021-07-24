import 'package:backend/entity/entity.dart' show GameEntity;
import 'package:backend/model/model.dart' show Game;


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

  static Future<Game> futureEntityToModel(Future<GameEntity> entityFuture, String? Function(String?) coverFunction) {

    return entityFuture.asStream().map( (GameEntity entity) {
      return entityToModel(entity, coverFunction(entity.coverFilename));
    }).first;

  }

  static Future<List<Game>> futureEntityListToModelList(Future<List<GameEntity>> entityListFuture, String? Function(String?) coverFunction) {

    return entityListFuture.asStream().map( (List<GameEntity> entityList) {
      return entityList.map( (GameEntity entity) {
        return entityToModel(entity, coverFunction(entity.coverFilename));
      }).toList(growable: false);
    }).first;

  }
}