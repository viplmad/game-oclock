import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/entity/entity.dart' show GameTagEntity;
import 'package:backend/model/model.dart' show Tag, TagView;

import './query/query.dart' show GameTagQuery, GameTagRelationQuery;
import 'item_repository.dart';


class GameTagRepository extends ItemRepository<Tag> {
  const GameTagRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  //#region CREATE
  @override
  Future<Tag?> create(Tag item) {

    final GameTagEntity entity = GameTagMapper.modelToEntity(item);
    final Query query = GameTagQuery.create(entity);

    return createCollectionItem(
      query: query,
      dynamicToId: GameTagEntity.idFromDynamicMap,
    );

  }
  //#endregion CREATE

  //#region READ
  @override
  Stream<Tag?> findById(int id) {

    final Query query = GameTagQuery.selectById(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToSingle );

  }

  @override
  Stream<List<Tag>> findAll() {

    return findAllGameTagsWithView(TagView.Main);

  }

  Stream<List<Tag>> findAllGameTagsWithView(TagView tagView, [int? limit]) {

    final Query query = GameTagQuery.selectAllInView(tagView, limit);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Tag>> findAllGameTagsFromGame(int id) {

    final Query query = GameTagRelationQuery.selectAllTagsByGameId(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<Tag?> update(Tag item, Tag updatedItem) {

    final GameTagEntity entity = GameTagMapper.modelToEntity(item);
    final GameTagEntity updatedEntity = GameTagMapper.modelToEntity(updatedItem);
    final Query query = GameTagQuery.updateById(item.id, entity, updatedEntity);

    return updateCollectionItem(
      query: query,
      id: item.id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteById(int id) {

    final Query query = GameTagQuery.deleteById(id);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Stream<List<Tag>> findAllGameTagsByName(String name, int maxResults) {

    final Query query = GameTagQuery.selectAllByNameLike(name, maxResults);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#region SEARCH

  List<Tag> dynamicToList(List<Map<String, Map<String, dynamic>>> results) {

    return GameTagEntity.fromDynamicMapList(results).map( GameTagMapper.entityToModel ).toList(growable: false);

  }
}