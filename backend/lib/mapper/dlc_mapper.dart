import 'package:backend/entity/entity.dart' show DLCEntity;
import 'package:backend/model/model.dart' show DLC;

class DLCMapper {
  DLCMapper._();

  static DLCEntity modelToEntity(DLC model) {
    return DLCEntity(
      id: model.id,
      name: model.name,
      releaseYear: model.releaseYear,
      coverFilename: model.coverFilename,
      baseGame: model.baseGame,
      firstFinishDate: model.firstFinishDate,
    );
  }

  static DLC entityToModel(DLCEntity entity, [String? coverURL]) {
    return DLC(
      id: entity.id,
      name: entity.name,
      releaseYear: entity.releaseYear,
      coverURL: coverURL,
      coverFilename: entity.coverFilename,
      baseGame: entity.baseGame,
      firstFinishDate: entity.firstFinishDate,
    );
  }

  static Future<DLC> futureEntityToModel(
    Future<DLCEntity> entityFuture,
    String? Function(String?) coverFunction,
  ) {
    return entityFuture.asStream().map((DLCEntity entity) {
      return entityToModel(entity, coverFunction(entity.coverFilename));
    }).first;
  }

  static Future<List<DLC>> futureEntityListToModelList(
    Future<List<DLCEntity>> entityListFuture,
    String? Function(String?) coverFunction,
  ) {
    return entityListFuture.asStream().map((List<DLCEntity> entityList) {
      return entityList.map((DLCEntity entity) {
        return entityToModel(entity, coverFunction(entity.coverFilename));
      }).toList(growable: false);
    }).first;
  }
}
