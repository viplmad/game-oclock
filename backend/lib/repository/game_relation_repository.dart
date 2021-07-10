import 'package:query/query.dart';

import 'package:backend/entity/entity.dart';
import 'repository.dart';


class GamePlatformRelationRepository {
  GamePlatformRelationRepository._();

  static Query create(int gameId, int plaformId) {
    final Query query = FluentQuery
      .insert()
      .into(GamePlatformRelationData.table)
      .set(GamePlatformRelationData.gameField, gameId)
      .set(GamePlatformRelationData.platformField, plaformId);

    return query;
  }

  static Query deleteById(int gameId, int platformId) {
    final Query query = FluentQuery
      .delete()
      .from(GamePlatformRelationData.table);

    _addIdWhere(gameId, platformId, query);

    return query;
  }

  static Query selectAllGamesByPlatformId(int id) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table)
      .join(GamePlatformRelationData.table, null, GamePlatformRelationData.gameField, GameEntityData.table, GameEntityData.idField)
      .where(GamePlatformRelationData.platformField, id, type: int, table: GamePlatformRelationData.table);

    GameRepository.addFields(query);

    return query;
  }

  static Query selectAllPlatformsByGameId(int id) {
    final Query query = FluentQuery
      .select()
      .from(PlatformEntityData.table)
      .join(GamePlatformRelationData.table, null, GamePlatformRelationData.platformField, PlatformEntityData.table, PlatformEntityData.idField)
      .where(GamePlatformRelationData.gameField, id, type: int, table: GamePlatformRelationData.table);

    PlatformRepository.addFields(query);

    return query;
  }

  static void _addIdWhere(int gameId, int platformId, Query query) {
    query.where(GamePlatformRelationData.gameField, gameId, type: int, table: GamePlatformRelationData.table);
    query.where(GamePlatformRelationData.platformField, platformId, type: int, table: GamePlatformRelationData.table);
  }
}

class GamePurchaseRelationRepository {
  GamePurchaseRelationRepository._();

  static Query create(int gameId, int purchaseId) {
    final Query query = FluentQuery
      .insert()
      .into(GamePurchaseRelationData.table)
      .set(GamePurchaseRelationData.gameField, gameId)
      .set(GamePurchaseRelationData.purchaseField, purchaseId);

    return query;
  }

  static Query deleteById(int gameId, int purchaseId) {
    final Query query = FluentQuery
      .delete()
      .from(GamePurchaseRelationData.table);

    _addIdWhere(gameId, purchaseId, query);

    return query;
  }

  static Query selectAllGamesByPurchaseId(int id) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table)
      .join(GamePurchaseRelationData.table, null, GamePurchaseRelationData.gameField, GameEntityData.table, GameEntityData.idField)
      .where(GamePurchaseRelationData.purchaseField, id, type: int, table: GamePurchaseRelationData.table);

    GameRepository.addFields(query);

    return query;
  }

  static Query selectAllPurchasesByGameId(int id) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseEntityData.table)
      .join(GamePurchaseRelationData.table, null, GamePurchaseRelationData.purchaseField, PurchaseEntityData.table, PurchaseEntityData.idField)
      .where(GamePurchaseRelationData.gameField, id, type: int, table: GamePurchaseRelationData.table);

    PurchaseRepository.addFields(query);

    return query;
  }

  static void _addIdWhere(int gameId, int purchaseId, Query query) {
    query.where(GamePurchaseRelationData.gameField, gameId, type: int, table: GamePurchaseRelationData.table);
    query.where(GamePurchaseRelationData.purchaseField, purchaseId, type: int, table: GamePurchaseRelationData.table);
  }
}

class GameTagRelationRepository {
  GameTagRelationRepository._();

  static Query create(int gameId, int tagId) {
    final Query query = FluentQuery
      .insert()
      .into(GameTagRelationData.table)
      .set(GameTagRelationData.gameField, gameId)
      .set(GameTagRelationData.tagField, tagId);

    return query;
  }

  static Query deleteById(int gameId, int tagId) {
    final Query query = FluentQuery
      .delete()
      .from(GameTagRelationData.table);

    _addIdWhere(gameId, tagId, query);

    return query;
  }

  static Query selectAllGamesByTagId(int id) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table)
      .join(GameTagRelationData.table, null, GameTagRelationData.gameField, GameEntityData.table, GameEntityData.idField)
      .where(GameTagRelationData.tagField, id, type: int, table: GameTagRelationData.table);

    GameRepository.addFields(query);

    return query;
  }

  static Query selectAllTagsByGameId(int id) {
    final Query query = FluentQuery
      .select()
      .from(GameTagEntityData.table)
      .join(GameTagRelationData.table, null, GameTagRelationData.tagField, GameTagEntityData.table, GameTagEntityData.idField)
      .where(GameTagRelationData.gameField, id, type: int, table: GameTagRelationData.table);

    GameTagRepository.addFields(query);

    return query;
  }

  static void _addIdWhere(int gameId, int tagId, Query query) {
    query.where(GameTagRelationData.gameField, gameId, type: int, table: GameTagRelationData.table);
    query.where(GameTagRelationData.tagField, tagId, type: int, table: GameTagRelationData.table);
  }
}