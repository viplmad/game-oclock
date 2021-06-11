import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart';


class StoreMapper {
  StoreMapper._();

  static StoreEntity modelToEntity(Store model) {

    return StoreEntity(
      id: model.id,
      name: model.name,
      iconFilename: model.iconFilename,
    );

  }

  static Store entityToModel(StoreEntity entity, [String? iconURL]) {

    return Store(
      id: entity.id,
      name: entity.name,
      iconURL: iconURL,
      iconFilename: entity.iconFilename,
    );

  }
}