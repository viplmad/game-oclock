import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart' show PurchaseID, StoreEntity, StoreEntityData, StoreID, StoreView;

import './query/query.dart' show StoreQuery, PurchaseQuery;
import 'item_repository.dart';


class StoreRepository extends ItemRepository<StoreEntity, StoreID> {
  const StoreRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  static const String _imagePrefix = 'icon';

  @override
  final String recordName = StoreEntityData.table;
  @override
  StoreEntity entityFromMap(Map<String, Object?> map) => StoreEntity.fromMap(map);
  @override
  StoreID idFromMap(Map<String, Object?> map) => StoreEntity.idFromMap(map);

  //#region CREATE
  @override
  Future<StoreEntity> create(StoreEntity entity) {

    final Query query = StoreQuery.create(entity);
    return createItem(
      query: query,
    );

  }

  Future<dynamic> relateStorePurchase(StoreID storeId, PurchaseID purchaseId) {

    final Query query = PurchaseQuery.updateStoreById(purchaseId, storeId);
    return itemConnector.execute(query);

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<StoreEntity> findById(StoreID id) {

    final Query query = StoreQuery.selectById(id);
    return readItem(
      query: query,
    );

  }

  @override
  Future<List<StoreEntity>> findAll() {

    final Query query = StoreQuery.selectAll();
    return readItemList(
      query: query,
    );

  }

  Future<List<StoreEntity>> findAllStoresWithView(StoreView storeView, [int? limit]) {

    final Query query = StoreQuery.selectAllInView(storeView, limit);
    return readItemList(
      query: query,
    );

  }

  Future<StoreEntity> findStoreFromPurchase(PurchaseID id) {

    final Query query = PurchaseQuery.selectStoreByPurchase(id);
    return readItem(
      query: query,
    );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<StoreEntity> update(StoreEntity entity, StoreEntity updatedEntity) {

    final StoreID id = entity.createId();
    final Query query = StoreQuery.updateById(id, entity, updatedEntity);
    return updateItem(
      query: query,
      id: id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteById(StoreID id) {

    final Query query = StoreQuery.deleteById(id);
    return itemConnector.execute(query);

  }

  Future<dynamic> unrelateStorePurchase(PurchaseID purchaseId) {

    final Query query = PurchaseQuery.updateStoreById(purchaseId, null);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Future<List<StoreEntity>> findAllStoresByName(String name, int limit) {

    final Query query = StoreQuery.selectAllByNameLike(name, limit);
    return readItemList(
      query: query,
    );

  }
  //#endregion SEARCH

  //#region IMAGE
  Future<StoreEntity> uploadStoreIcon(StoreID id, String uploadImagePath, [String? oldImageName]) {

    return setItemImage(
      uploadImagePath: uploadImagePath,
      initialImageName: _imagePrefix,
      oldImageName: oldImageName,
      queryBuilder: StoreQuery.updateIconById,
      id: id,
    );

  }

  Future<StoreEntity> renameStoreIcon(StoreID id, String imageName, String newImageName) {

    return renameItemImage(
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: StoreQuery.updateIconById,
      id: id,
    );

  }

  Future<StoreEntity> deleteStoreIcon(StoreID id, String imageName) {

    return deleteItemImage(
      imageName: imageName,
      queryBuilder: StoreQuery.updateIconById,
      id: id,
    );

  }
  //#endregion IMAGE
}