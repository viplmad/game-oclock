import 'package:query/query.dart' show Query;

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;


abstract class ItemRepository<T extends ItemEntity, ID extends Object> {
  const ItemRepository(this.itemConnector, this.imageConnector);

  final ItemConnector itemConnector;
  final ImageConnector imageConnector;

  Future<dynamic> open() => itemConnector.open();
  Future<dynamic> close() => itemConnector.close();

  bool isOpen() => itemConnector.isOpen();
  bool isClosed() => itemConnector.isClosed();

  void reconnect() => itemConnector.reconnect();

  Future<T?> create(T entity);
  Stream<T?> findById(ID id);
  Stream<List<T>> findAll();
  Future<T?> update(ID id, T entity, T updatedEntity);
  Future<dynamic> deleteById(ID id);

  // Utils
  Future<T?> createCollectionItem({required Query query, required ID? Function(List<Map<String, Map<String, dynamic>>>) dynamicToId}) async {

    final ID? id = await itemConnector.execute(query)
      .asStream()
      .map( dynamicToId ).first;

    if(id != null) {
      return findById(id).first;
    } else {
      return Future<T?>.value(null);
    }

  }

  Future<T?> updateCollectionItem({required Query query, required ID id}) async {

    await itemConnector.execute(query);
    return findById(id).first;

  }

  Future<T?> uploadCollectionItemImage({required String tableName, required String uploadImagePath, required String initialImageName, required String? oldImageName, required Query Function(ID, String?) queryBuilder, required ID id}) async {

    if(oldImageName != null) {
      await imageConnector.delete(
        tableName: tableName,
        imageName: oldImageName,
      );
    }

    final String imageName = await imageConnector.set(
      imagePath: uploadImagePath,
      tableName: tableName,
      imageName: _getImageName(id, initialImageName),
    );

    return updateCollectionItem(
      query: queryBuilder(id, imageName),
      id: id,
    );

  }

  Future<T?> renameCollectionItemImage({required String tableName, required String oldImageName, required String newImageName, required Query Function(ID, String?) queryBuilder, required ID id}) async {

    final String imageName = await imageConnector.rename(
      tableName: tableName,
      oldImageName: oldImageName,
      newImageName: _getImageName(id, newImageName),
    );

    return updateCollectionItem(
      query: queryBuilder(id, imageName),
      id: id,
    );

  }

  Future<T?> deleteCollectionItemImage({required String tableName, required String imageName, required Query Function(ID, String?) queryBuilder, required ID id}) async {

    await imageConnector.delete(
      tableName: tableName,
      imageName: imageName,
    );

    return updateCollectionItem(
      query: queryBuilder(id, null),
      id: id,
    );

  }

  String _getImageName(ID id, String imageName) {

    return id.toString() + '-' + imageName;

  }

  // Mapper
  List<T> dynamicToList(List<Map<String, Map<String, dynamic>>> results);

  T? dynamicToSingle(List<Map<String, Map<String, dynamic>>> results) {
    T? singleItem;

    if(results.isNotEmpty) {
      singleItem = dynamicToList(results).first;
    }

    return singleItem;
  }
}