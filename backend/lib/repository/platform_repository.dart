import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/mapper/mapper.dart' show PlatformMapper;
import 'package:backend/entity/entity.dart' show PlatformEntity, PlatformEntityData;
import 'package:backend/model/model.dart' show Platform, PlatformView;

import './query/query.dart' show PlatformQuery, PlatformSystemRelationQuery, GamePlatformRelationQuery;
import 'item_repository.dart';


class PlatformRepository extends ItemRepository<Platform> {
  const PlatformRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  static const String _imagePrefix = 'icon';

  //#region CREATE
  @override
  Future<Platform?> create(Platform item) {

    final PlatformEntity entity = PlatformMapper.modelToEntity(item);
    final Query query = PlatformQuery.create(entity);

    return createCollectionItem(
      query: query,
      dynamicToId: PlatformEntity.idFromDynamicMap,
    );

  }

  Future<dynamic> relatePlatformSystem(int platformId, int systemId) {

    final Query query = PlatformSystemRelationQuery.create(platformId, systemId);
    return itemConnector.execute(query);

  }
  //#endregion CREATE

  //#region READ
  @override
  Stream<Platform?> findById(int id) {

    final Query query = PlatformQuery.selectById(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToSingle );

  }

  @override
  Stream<List<Platform>> findAll() {

    return findAllPlatformsWithView(PlatformView.Main);

  }

  Stream<List<Platform>> findAllPlatformsWithView(PlatformView platformView, [int? limit]) {

    final Query query = PlatformQuery.selectAllInView(platformView, limit);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Platform>> findAllPlatformsFromGame(int id) {

    final Query query = GamePlatformRelationQuery.selectAllPlatformsByGameId(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Platform>> findAllPlatformsFromSystem(int id) {

    final Query query = PlatformSystemRelationQuery.selectAllPlatformsBySystemId(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<Platform?> update(Platform item, Platform updatedItem) {

    final PlatformEntity entity = PlatformMapper.modelToEntity(item);
    final PlatformEntity updatedEntity = PlatformMapper.modelToEntity(updatedItem);
    final Query query = PlatformQuery.updateById(item.id, entity, updatedEntity);

    return updateCollectionItem(
      query: query,
      id: item.id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteById(int id) {

    final Query query = PlatformQuery.deleteById(id);
    return itemConnector.execute(query);

  }

  Future<dynamic> unrelatePlatformSystem(int platformId, int systemId) {

    final Query query = PlatformSystemRelationQuery.deleteById(platformId, systemId);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Stream<List<Platform>> findAllPlatformsByName(String name, int maxResults) {

    final Query query = PlatformQuery.selectAllByNameLike(name, maxResults);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion SEARCH

  //#region IMAGE
  Future<Platform?> uploadPlatformIcon(int id, String uploadImagePath, [String? oldImageName]) {

    return uploadCollectionItemImage(
      tableName: PlatformEntityData.table,
      uploadImagePath: uploadImagePath,
      initialImageName: _imagePrefix,
      oldImageName: oldImageName,
      queryBuilder: PlatformQuery.updateIconById,
      id: id,
    );

  }

  Future<Platform?> renamePlatformIcon(int id, String imageName, String newImageName) {

    return renameCollectionItemImage(
      tableName: PlatformEntityData.table,
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: PlatformQuery.updateIconById,
      id: id,
    );

  }

  Future<Platform?> deletePlatformIcon(int id, String imageName) {

    return deleteCollectionItemImage(
      tableName: PlatformEntityData.table,
      imageName: imageName,
      queryBuilder: PlatformQuery.updateIconById,
      id: id,
    );

  }
  //#endregion IMAGE

  //#region DOWNLOAD
  String? _getPlatformIconURL(String? platformIconName) {

    return platformIconName != null?
        imageConnector.getURI(
          tableName: PlatformEntityData.table,
          imageFilename: platformIconName,
        )
        : null;

  }
  //#endregion DOWNLOAD

  @override
  List<Platform> dynamicToList(List<Map<String, Map<String, dynamic>>> results) {

    return PlatformEntity.fromDynamicMapList(results).map( (PlatformEntity platformEntity) {
      return PlatformMapper.entityToModel(platformEntity, _getPlatformIconURL(platformEntity.iconFilename));
    }).toList(growable: false);

  }
}