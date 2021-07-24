import 'package:backend/entity/entity.dart' show DLCFinishEntity;
import 'package:backend/model/model.dart' show DLCFinish;


class DLCFinishMapper {
  DLCFinishMapper._();

  static DLCFinishEntity modelToEntity(int dlcId, DLCFinish model) {

    return DLCFinishEntity(
      dlcId: dlcId,
      dateTime: model.dateTime,
    );

  }

  static DLCFinish entityToModel(DLCFinishEntity entity) {

    return DLCFinish(
      dateTime: entity.dateTime,
    );

  }

  static Future<DLCFinish> futureEntityToModel(Future<DLCFinishEntity> entityFuture) {

    return entityFuture.asStream().map( entityToModel ).first;

  }

  static Future<List<DLCFinish>> futureEntityListToModelList(Future<List<DLCFinishEntity>> entityListFuture) {

    return entityListFuture.asStream().map( (List<DLCFinishEntity> entityList) {
      return entityList.map( entityToModel ).toList(growable: false);
    }).first;

  }
}