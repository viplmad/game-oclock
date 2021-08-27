import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart' show SystemEntity, SystemID, PlatformID, SystemEntityData, SystemView;

import './query/query.dart' show SystemQuery, PlatformSystemRelationQuery;
import 'item_repository.dart';


class SystemRepository extends ItemRepository<SystemEntity, SystemID> {
  const SystemRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector, recordName: SystemEntityData.table);

  static const String _imagePrefix = 'icon';

  @override
  SystemEntity entityFromMap(Map<String, Object?> map) => SystemEntity.fromMap(map);
  @override
  SystemID idFromMap(Map<String, Object?> map) => SystemEntity.idFromMap(map);

  //#region CREATE
  @override
  Future<SystemEntity> create(SystemEntity entity) {

    final Query query = SystemQuery.create(entity);
    return createItem(
      query: query,
    );

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<SystemEntity> findById(SystemID id) {

    final Query query = SystemQuery.selectById(id);
    return readItem(
      query: query,
    );

  }

  @override
  Future<List<SystemEntity>> findAll() {

    final Query query = SystemQuery.selectAll();
    return readItemList(
      query: query,
    );

  }

  Future<List<SystemEntity>> findAllWithView(SystemView systemView, [int? limit]) {

    final Query query = SystemQuery.selectAllInView(systemView, limit);
    return readItemList(
      query: query,
    );
  }

  Future<List<SystemEntity>> findAllFromPlatform(PlatformID id) {

    final Query query = PlatformSystemRelationQuery.selectAllSystemsByPlatformId(id);
    return readItemList(
      query: query,
    );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<SystemEntity> update(SystemEntity entity, SystemEntity updatedEntity) {

    final SystemID id = entity.createId();
    final Query query = SystemQuery.updateById(id, entity, updatedEntity);
    return updateItem(
      query: query,
      id: id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<Object?> deleteById(SystemID id) {

    final Query query = SystemQuery.deleteById(id);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Future<List<SystemEntity>> findAllByName(String name, int limit) {

    final Query query = SystemQuery.selectAllByNameLike(name, limit);
    return readItemList(
      query: query,
    );

  }
  //#endregion SEARCH

  //#region IMAGE
  Future<SystemEntity> uploadIcon(SystemID id, String uploadImagePath, [String? oldImageName]) {

    return setItemImage(
      uploadImagePath: uploadImagePath,
      initialImageName: _imagePrefix,
      oldImageName: oldImageName,
      queryBuilder: SystemQuery.updateIconById,
      id: id,
    );

  }

  Future<SystemEntity> renameIcon(SystemID id, String imageName, String newImageName) {

    return renameItemImage(
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: SystemQuery.updateIconById,
      id: id,
    );

  }

  Future<SystemEntity> deleteIcon(SystemID id, String imageName) {

    return deleteItemImage(
      imageName: imageName,
      queryBuilder: SystemQuery.updateIconById,
      id: id,
    );

  }
  //#endregion IMAGE
}