import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart'
    show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart'
    show DLCEntity, DLCID, GameID, PurchaseID, DLCEntityData, DLCView;

import './query/query.dart' show DLCQuery, DLCPurchaseRelationQuery;
import 'item_repository.dart';

class DLCRepository extends ItemRepository<DLCEntity, DLCID> {
  const DLCRepository(
    ItemConnector itemConnector,
    ImageConnector? imageConnector,
  ) : super(
          itemConnector,
          imageConnector,
          recordName: DLCEntityData.table,
        );

  static const String _imagePrefix = 'header';

  @override
  DLCEntity entityFromMap(Map<String, Object?> map) => DLCEntity.fromMap(map);
  @override
  DLCID idFromMap(Map<String, Object?> map) => DLCEntity.idFromMap(map);

  //#region CREATE
  @override
  Future<DLCEntity> create(DLCEntity entity) {
    final Query query = DLCQuery.create(entity);
    return createItem(
      query: query,
    );
  }

  Future<Object?> relateDLCPurchase(DLCID dlcId, PurchaseID purchaseId) {
    final Query query = DLCPurchaseRelationQuery.create(dlcId, purchaseId);
    return itemConnector.execute(query);
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<DLCEntity> findById(DLCID id) {
    final Query query = DLCQuery.selectById(id);
    return readItem(
      query: query,
    );
  }

  @override
  Future<List<DLCEntity>> findAll([int? page]) {
    final Query query = DLCQuery.selectAll(page);
    return readItemList(
      query: query,
    );
  }

  Future<List<DLCEntity>> findAllWithView(DLCView dlcView, [int? page]) {
    final Query query = DLCQuery.selectAllInView(dlcView, page);
    return readItemList(
      query: query,
    );
  }

  Future<List<DLCEntity>> findFirstWithView(DLCView dlcView, int limit) {
    final Query query = DLCQuery.selectFirstInView(dlcView, limit);
    return readItemList(
      query: query,
    );
  }

  Future<List<DLCEntity>> findAllFromGame(GameID id) {
    final Query query = DLCQuery.selectAllByBaseGame(id);
    return readItemList(
      query: query,
    );
  }

  Future<List<DLCEntity>> findAllFromPurchase(PurchaseID id) {
    final Query query = DLCPurchaseRelationQuery.selectAllDLCsByPurchaseId(id);
    return readItemList(
      query: query,
    );
  }
  //#endregion CREATE

  //#region UPDATE
  @override
  Future<DLCEntity> update(DLCEntity entity, DLCEntity updatedEntity) {
    final DLCID id = entity.createId();
    final Query query = DLCQuery.updateById(id, entity, updatedEntity);
    return updateItem(
      query: query,
      id: id,
    );
  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<Object?> deleteById(DLCID id) {
    final Query query = DLCQuery.deleteById(id);
    return itemConnector.execute(query);
  }

  Future<Object?> unrelateDLCPurchase(DLCID dlcId, PurchaseID purchaseId) {
    final Query query = DLCPurchaseRelationQuery.deleteById(dlcId, purchaseId);
    return itemConnector.execute(query);
  }
  //#endregion DELETE

  //#region SEARCH
  Future<List<DLCEntity>> findFirstByName(String name, int limit) {
    final Query query = DLCQuery.selectFirstByNameLike(name, limit);
    return readItemList(
      query: query,
    );
  }

  Future<List<DLCEntity>> findFirstWithViewByName(
    DLCView dlcView,
    String name,
    int limit,
  ) {
    final Query query =
        DLCQuery.selectFirstInViewByNameLike(dlcView, name, limit);
    return readItemList(
      query: query,
    );
  }
  //#endregion SEARCH

  //#region IMAGE
  Future<DLCEntity> uploadCover(
    DLCID id,
    String uploadImagePath, [
    String? oldImageName,
  ]) {
    return setItemImage(
      uploadImagePath: uploadImagePath,
      initialImageName: _imagePrefix,
      oldImageName: oldImageName,
      queryBuilder: DLCQuery.updateCoverById,
      id: id,
    );
  }

  Future<DLCEntity> renameCover(
    DLCID id,
    String imageName,
    String newImageName,
  ) {
    return renameItemImage(
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: DLCQuery.updateCoverById,
      id: id,
    );
  }

  Future<DLCEntity> deleteCover(DLCID id, String imageName) {
    return deleteItemImage(
      imageName: imageName,
      queryBuilder: DLCQuery.updateCoverById,
      id: id,
    );
  }
  //#endregion IMAGE
}
