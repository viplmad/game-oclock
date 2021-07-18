import 'package:backend/game_collection_backend.dart';
import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/mapper/mapper.dart' show DLCMapper;
import 'package:backend/entity/entity.dart' show DLCEntity, DLCID, DLCEntityData;
import 'package:backend/model/model.dart' show DLC, DLCView;

import './query/query.dart' show DLCQuery, DLCPurchaseRelationQuery;
import 'item_repository.dart';

class DLCService {
  DLCService(this.dlcRepository);

  final DLCRepository dlcRepository;

  Future<DLC?> create(DLC item) {

    final DLCEntity entity = DLCMapper.modelToEntity(item);
    return dlcRepository.create(item).map( (DLCEntity dlcEntity) {
      return DLCMapper.entityToModel(dlcEntity, dlcRepository.getDLCCoverURL(dlcEntity.coverFilename));
    }).toList(growable: false);

  }

  Future<DLC?> update(DLC item, DLC updatedItem) {

    final DLCEntity entity = DLCMapper.modelToEntity(item);
    final DLCEntity updatedEntity = DLCMapper.modelToEntity(updatedItem);
    return dlcRepository.update(entity.createId(), entity, updatedEntity).map( (DLCEntity dlcEntity) {
      return DLCMapper.entityToModel(dlcEntity, dlcRepository.getDLCCoverURL(dlcEntity.coverFilename));
    }).toList(growable: false);

  }

  Future<Iterable<DLC>> findAll() {

    return dlcRepository.findAllDLCsWithView(DLCView.Main).map((List<DLCEntity> event) => event.map((DLCEntity e) => DLCMapper.entityToModel(e, dlcRepository.getDLCCoverURL(e.coverFilename)))).first;

  }

}

class DLCRepository extends ItemRepository<DLCEntity, DLCID> {
  const DLCRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  static const String _imagePrefix = 'header';

  //#region CREATE
  @override
  Future<DLCEntity?> create(DLCEntity entity) {

    final Query query = DLCQuery.create(entity);

    return createCollectionItem(
      query: query,
      dynamicToId: DLCEntity.idFromDynamicMap,
    );

  }

  Future<dynamic> relateDLCPurchase(DLCID dlcId, int purchaseId) {

    final Query query = DLCPurchaseRelationQuery.create(dlcId.id, purchaseId);
    return itemConnector.execute(query);

  }
  //#endregion CREATE

  //#region READ
  @override
  Stream<DLCEntity?> findById(DLCID id) {

    final Query query = DLCQuery.selectById(id.id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToSingle );

  }

  @override
  Stream<List<DLCEntity>> findAll() {

    final Query query = DLCQuery.selectAll();
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );
  }

  Stream<List<DLCEntity>> findAllDLCsWithView(DLCView dlcView, [int? limit]) {

    final Query query = DLCQuery.selectAllInView(dlcView, limit);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<DLCEntity>> findAllDLCsFromGame(int id) {

    final Query query = DLCQuery.selectAllByBaseGame(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<DLCEntity>> findAllDLCsFromPurchase(int id) {

    final Query query = DLCPurchaseRelationQuery.selectAllDLCsByPurchaseId(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion CREATE

  //#region UPDATE
  @override
  Future<DLCEntity?> update(DLCID id, DLCEntity entity, DLCEntity updatedEntity) {

    final Query query = DLCQuery.updateById(id.id, entity, updatedEntity);

    return updateCollectionItem(
      query: query,
      id: id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteById(DLCID id) {

    final Query query = DLCQuery.deleteById(id.id);
    return itemConnector.execute(query);

  }

  Future<dynamic> unrelateDLCPurchase(DLCID dlcId, int purchaseId) {

    final Query query = DLCPurchaseRelationQuery.deleteById(dlcId.id, purchaseId);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Stream<List<DLCEntity>> findAllDLCsByName(String name, int limit) {

    final Query query = DLCQuery.selectAllByNameLike(name, limit);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion SEARCH

  //#region IMAGE
  Future<DLCEntity?> uploadDLCCover(DLCID id, String uploadImagePath, [String? oldImageName]) {

    return uploadCollectionItemImage(
      tableName: DLCEntityData.table,
      uploadImagePath: uploadImagePath,
      initialImageName: _imagePrefix,
      oldImageName: oldImageName,
      queryBuilder: (DLCID dlcId, String? name) => DLCQuery.updateCoverById(dlcId.id, name),
      id: id,
    );

  }

  Future<DLCEntity?> renameDLCCover(DLCID id, String imageName, String newImageName) {

    return renameCollectionItemImage(
      tableName: DLCEntityData.table,
      oldImageName: imageName,
      newImageName: newImageName,
      queryBuilder: (DLCID dlcId, String? name) => DLCQuery.updateCoverById(dlcId.id, name),
      id: id,
    );

  }

  Future<DLCEntity?> deleteDLCCover(DLCID id, String imageName) {

    return deleteCollectionItemImage(
      tableName: DLCEntityData.table,
      imageName: imageName,
      queryBuilder: (DLCID dlcId, String? name) => DLCQuery.updateCoverById(dlcId.id, name),
      id: id,
    );

  }
  //#endregion IMAGE

  //#region DOWNLOAD
  String? getDLCCoverURL(String? dlcCoverName) {

    return dlcCoverName != null?
        imageConnector.getURI(
          tableName: DLCEntityData.table,
          imageFilename: dlcCoverName,
        )
        : null;

  }
  //#endregion DOWNLOAD

  @override
  List<DLCEntity> dynamicToList(List<Map<String, Map<String, dynamic>>> results) {

    return DLCEntity.fromDynamicMapList(results);

  }
}