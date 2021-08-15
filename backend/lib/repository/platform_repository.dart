import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart' show GameID, PlatformEntity, PlatformEntityData, PlatformID, SystemID, PlatformView;

import './query/query.dart' show PlatformQuery, PlatformSystemRelationQuery, GamePlatformRelationQuery;
import 'item_repository.dart';


class PlatformRepository extends ItemRepository<PlatformEntity, PlatformID> {
  const PlatformRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  static const String _imagePrefix = 'icon';

  @override
  final String recordName = PlatformEntityData.table;
  @override
  PlatformEntity entityFromMap(Map<String, Object?> map) => PlatformEntity.fromMap(map);
  @override
  PlatformID idFromMap(Map<String, Object?> map) => PlatformEntity.idFromMap(map);

  //#region CREATE
  @override
  Future<PlatformEntity> create(PlatformEntity entity) {

    final Query query = PlatformQuery.create(entity);
    return createItem(
      query: query,
    );

  }

  Future<Object?> relatePlatformSystem(PlatformID platformId, SystemID systemId) {

    final Query query = PlatformSystemRelationQuery.create(platformId, systemId);
    return itemConnector.execute(query);

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<PlatformEntity> findById(PlatformID id) {

    final Query query = PlatformQuery.selectById(id);
    return readItem(
      query: query,
    );

  }

  @override
  Future<List<PlatformEntity>> findAll() {

    final Query query = PlatformQuery.selectAll();
    return readItemList(
      query: query,
    );

  }

  Future<List<PlatformEntity>> findAllWithView(PlatformView platformView, [int? limit]) {

    final Query query = PlatformQuery.selectAllInView(platformView, limit);
    return readItemList(
      query: query,
    );

  }

  Future<List<PlatformEntity>> findAllFromGame(GameID id) {

    final Query query = GamePlatformRelationQuery.selectAllPlatformsByGameId(id);
    return readItemList(
      query: query,
    );

  }

  Future<List<PlatformEntity>> findAllFromSystem(SystemID id) {

    final Query query = PlatformSystemRelationQuery.selectAllPlatformsBySystemId(id);
    return readItemList(
      query: query,
    );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<PlatformEntity> update(PlatformEntity entity, PlatformEntity updatedEntity) {

    final PlatformID id = entity.createId();
    final Query query = PlatformQuery.updateById(id, entity, updatedEntity);
    return updateItem(
      query: query,
      id: id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<Object?> deleteById(PlatformID id) {

    final Query query = PlatformQuery.deleteById(id);
    return itemConnector.execute(query);

  }

  Future<Object?> unrelatePlatformSystem(PlatformID platformId, SystemID systemId) {

    final Query query = PlatformSystemRelationQuery.deleteById(platformId, systemId);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Future<List<PlatformEntity>> findAllByName(String name, int limit) {

    final Query query = PlatformQuery.selectAllByNameLike(name, limit);
    return readItemList(
      query: query,
    );

  }
  //#endregion SEARCH

  //#region IMAGE
  Future<PlatformEntity> uploadIcon(PlatformID id, String uploadImagePath, [String? oldImageName]) {

    return setItemImage(
      uploadImagePath: uploadImagePath,
      initialImageName: _imagePrefix,
      oldImageName: oldImageName,
      queryBuilder: PlatformQuery.updateIconById,
      id: id,
    );

  }

  Future<PlatformEntity> renameIcon(PlatformID id, String imageName, String newImageName) {

    return renameItemImage(
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: PlatformQuery.updateIconById,
      id: id,
    );

  }

  Future<PlatformEntity> deleteIcon(PlatformID id, String imageName) {

    return deleteItemImage(
      imageName: imageName,
      queryBuilder: PlatformQuery.updateIconById,
      id: id,
    );

  }
  //#endregion IMAGE
}