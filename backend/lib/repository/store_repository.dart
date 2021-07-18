import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/mapper/mapper.dart' show StoreMapper;
import 'package:backend/entity/entity.dart' show StoreEntity, StoreEntityData;
import 'package:backend/model/model.dart' show Store, StoreView;

import './query/query.dart' show StoreQuery, PurchaseQuery;
import 'item_repository.dart';


class StoreRepository extends ItemRepository<Store> {
  const StoreRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  //#region CREATE
  @override
  Future<Store?> create(Store item) {

    final StoreEntity entity = StoreMapper.modelToEntity(item);
    final Query query = StoreQuery.create(entity);

    return createCollectionItem(
      query: query,
      dynamicToId: StoreEntity.idFromDynamicMap,
    );

  }

  Future<dynamic> relateStorePurchase(int storeId, int purchaseId) {

    final Query query = PurchaseQuery.updateStoreById(purchaseId, storeId);
    return itemConnector.execute(query);

  }
  //#endregion CREATE

  //#region READ
  @override
  Stream<Store?> findById(int id) {

    final Query query = StoreQuery.selectById(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToSingle );

  }

  @override
  Stream<List<Store>> findAll() {

    return findAllStoresWithView(StoreView.Main);

  }

  Stream<List<Store>> findAllStoresWithView(StoreView storeView, [int? limit]) {

    final Query query = StoreQuery.selectAllInView(storeView, limit);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<Store?> findStoreFromPurchase(int id) {

    final Query query = PurchaseQuery.selectStoreByPurchase(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToSingle );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<Store?> update(Store item, Store updatedItem) {

    final StoreEntity entity = StoreMapper.modelToEntity(item);
    final StoreEntity updatedEntity = StoreMapper.modelToEntity(updatedItem);
    final Query query = StoreQuery.updateById(item.id, entity, updatedEntity);

    return updateCollectionItem(
      query: query,
      id: item.id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteById(int id) {

    final Query query = StoreQuery.deleteById(id);
    return itemConnector.execute(query);

  }

  Future<dynamic> unrelateStorePurchase(int purchaseId) {

    final Query query = PurchaseQuery.updateStoreById(purchaseId, null);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Stream<List<Store>> findAllStoresByName(String name, int maxResults) {

    final Query query = StoreQuery.selectAllByNameLike(name, maxResults);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion SEARCH

  //#region IMAGE
  Future<Store?> uploadStoreIcon(int id, String uploadImagePath, [String? oldImageName]) {

    return uploadCollectionItemImage(
      tableName: StoreEntityData.table,
      uploadImagePath: uploadImagePath,
      initialImageName: 'icon',
      oldImageName: oldImageName,
      queryBuilder: StoreQuery.updateIconById,
      id: id,
    );

  }

  Future<Store?> renameStoreIcon(int id, String imageName, String newImageName) {

    return renameCollectionItemImage(
      tableName: StoreEntityData.table,
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: StoreQuery.updateIconById,
      id: id,
    );

  }

  Future<Store?> deleteStoreIcon(int id, String imageName) {

    return deleteCollectionItemImage(
      tableName: StoreEntityData.table,
      imageName: imageName,
      queryBuilder: StoreQuery.updateIconById,
      id: id,
    );

  }
  //#endregion IMAGE

  //#region DOWNLOAD
  String? _getStoreIconURL(String? storeIconName) {

    return storeIconName != null?
        imageConnector.getURI(
          tableName: StoreEntityData.table,
          imageFilename: storeIconName,
        )
        : null;

  }
  //#endregion DOWNLOAD

  @override
  List<Store> dynamicToList(List<Map<String, Map<String, dynamic>>> results) {

    return StoreEntity.fromDynamicMapList(results).map( (StoreEntity storeEntity) {
      return StoreMapper.entityToModel(storeEntity, _getStoreIconURL(storeEntity.iconFilename));
    }).toList(growable: false);

  }
}