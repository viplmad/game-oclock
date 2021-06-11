import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart';


class DLCMapper {
  DLCMapper._();

  static DLCEntity modelToEntity(DLC model) {

    return DLCEntity(
      id: model.id,
      name: model.name,
      releaseYear: model.releaseYear,
      coverFilename: model.coverFilename,
      finishDate: model.finishDate,

      baseGame: model.baseGame,
    );

  }

  static DLC entityToModel(DLCEntity entity, [String? coverURL]) {

    return DLC(
      id: entity.id,
      name: entity.name,
      releaseYear: entity.releaseYear,
      coverURL: coverURL,
      coverFilename: entity.coverFilename,
      finishDate: entity.finishDate,

      baseGame: entity.baseGame,
    );

  }

  static DLCFinishEntity finishModelToEntity(DLCFinish model) {

    return DLCFinishEntity(
      dateTime: model.dateTime,
    );

  }

  static DLCFinish finishEntityToModel(DLCFinishEntity entity) {

    return DLCFinish(
      dateTime: entity.dateTime,
    );

  }

}