import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/mapper/mapper.dart' show SystemMapper;
import 'package:backend/entity/entity.dart' show SystemEntity, SystemEntityData;
import 'package:backend/model/model.dart' show System, SystemView;

import './query/query.dart' show SystemQuery, PlatformSystemRelationQuery;
import 'item_repository.dart';


class SystemRepository extends ItemRepository<System> {
  const SystemRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  static const String _imagePrefix = 'icon';

  //#region CREATE
  @override
  Future<System?> create(System item) {

    final SystemEntity entity = SystemMapper.modelToEntity(item);
    final Query query = SystemQuery.create(entity);

    return createCollectionItem(
      query: query,
      dynamicToId: SystemEntity.idFromDynamicMap,
    );

  }
  //#endregion CREATE

  //#region READ
  @override
  Stream<System?> findById(int id) {

    final Query query = SystemQuery.selectById(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToSingle );

  }

  @override
  Stream<List<System>> findAll() {

    return findAllSystemsWithView(SystemView.Main);

  }

  Stream<List<System>> findAllSystemsWithView(SystemView systemView, [int? limit]) {

    final Query query = SystemQuery.selectAllInView(systemView, limit);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );
  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<System?> update(System item, System updatedItem) {

    final SystemEntity entity = SystemMapper.modelToEntity(item);
    final SystemEntity updatedEntity = SystemMapper.modelToEntity(updatedItem);
    final Query query = SystemQuery.updateById(item.id, entity, updatedEntity);

    return updateCollectionItem(
      query: query,
      id: item.id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteById(int id) {

    final Query query = SystemQuery.deleteById(id);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Stream<List<System>> findAllSystemsByName(String name, int maxResults) {

    final Query query = SystemQuery.selectAllByNameLike(name, maxResults);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<System>> findAllSystemsFromPlatform(int id) {

    final Query query = PlatformSystemRelationQuery.selectAllSystemsByPlatformId(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion SEARCH

  //#region IMAGE
  Future<System?> uploadSystemIcon(int id, String uploadImagePath, [String? oldImageName]) {

    return uploadCollectionItemImage(
      tableName: SystemEntityData.table,
      uploadImagePath: uploadImagePath,
      initialImageName: _imagePrefix,
      oldImageName: oldImageName,
      queryBuilder: SystemQuery.updateIconById,
      id: id,
    );

  }

  Future<System?> renameSystemIcon(int id, String imageName, String newImageName) {

    return renameCollectionItemImage(
      tableName: SystemEntityData.table,
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: SystemQuery.updateIconById,
      id: id,
    );

  }

  Future<System?> deleteSystemIcon(int id, String imageName) {

    return deleteCollectionItemImage(
      tableName: SystemEntityData.table,
      imageName: imageName,
      queryBuilder: SystemQuery.updateIconById,
      id: id,
    );

  }
  //#endregion IMAGE

  //#region DOWNLOAD
  String? _getSystemIconURL(String? systemIconName) {

    return systemIconName != null?
        imageConnector.getURI(
          tableName: SystemEntityData.table,
          imageFilename: systemIconName,
        )
        : null;

  }
  //#endregion DOWNLOAD

  @override
  List<System> dynamicToList(List<Map<String, Map<String, dynamic>>> results) {

    return SystemEntity.fromDynamicMapList(results).map( (SystemEntity systemEntity) {
      return SystemMapper.entityToModel(systemEntity, _getSystemIconURL(systemEntity.iconFilename));
    }).toList(growable: false);

  }
}