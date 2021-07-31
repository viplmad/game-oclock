import 'package:backend/entity/entity.dart' show GameEntity, lowPriorityValue, nextUpValue, playingValue, playedValue;
import 'package:backend/model/model.dart' show Game, GameStatus;


class GameMapper {
  GameMapper._();

  static const Map<GameStatus, String> statusToStringMap = <GameStatus, String> {
    GameStatus.LowPriority: lowPriorityValue,
    GameStatus.NextUp: nextUpValue,
    GameStatus.Playing: playingValue,
    GameStatus.Played: playedValue,
  };

  static const Map<String, GameStatus> stringToStatusMap = <String, GameStatus> {
    lowPriorityValue: GameStatus.LowPriority,
    nextUpValue: GameStatus.NextUp,
    playingValue: GameStatus.Playing,
    playedValue :GameStatus.Played,
  };

  static GameEntity modelToEntity(Game model) {

    return GameEntity(
      id: model.id,
      name: model.name,
      edition: model.edition,
      releaseYear: model.releaseYear,
      coverFilename: model.coverFilename,
      status: statusToStringMap[model.status]!,
      rating: model.rating,
      thoughts: model.thoughts,
      saveFolder: model.saveFolder,
      screenshotFolder: model.screenshotFolder,
      isBackup: model.isBackup,
      firstFinishDate: model.firstFinishDate,
      totalTime: model.totalTime,
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
      status: stringToStatusMap[entity.status]?? GameStatus.LowPriority,
      rating: entity.rating,
      thoughts: entity.thoughts,
      saveFolder: entity.saveFolder,
      screenshotFolder: entity.screenshotFolder,
      isBackup: entity.isBackup,
      firstFinishDate: entity.firstFinishDate,
      totalTime: entity.totalTime,
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