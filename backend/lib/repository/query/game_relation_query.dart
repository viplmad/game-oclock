import 'package:query/query.dart';

import 'package:backend/entity/entity.dart'
    show
        GameEntityData,
        GameID,
        GamePlatformRelationData,
        GamePurchaseRelationData,
        GameTagEntityData,
        GameTagID,
        GameTagRelationData,
        PlatformEntityData,
        PlatformID,
        PurchaseEntityData,
        PurchaseID;
import 'query.dart' show GameQuery, PlatformQuery, PurchaseQuery, GameTagQuery;

class GamePlatformRelationQuery {
  GamePlatformRelationQuery._();

  static Query create(GameID gameId, PlatformID platformId) {
    final Query query = FluentQuery.insert()
        .into(GamePlatformRelationData.table)
        .set(GamePlatformRelationData.gameField, gameId.id)
        .set(GamePlatformRelationData.platformField, platformId.id);

    return query;
  }

  static Query deleteById(GameID gameId, PlatformID platformId) {
    final Query query =
        FluentQuery.delete().from(GamePlatformRelationData.table);

    _addIdWhere(gameId, platformId, query);

    return query;
  }

  static Query selectAllGamesByPlatformId(PlatformID id) {
    final Query query = FluentQuery.select()
        .from(GameEntityData.table)
        .join(
          GamePlatformRelationData.table,
          null,
          GamePlatformRelationData.gameField,
          GameEntityData.table,
          GameEntityData.idField,
        )
        .where(
          GamePlatformRelationData.platformField,
          id.id,
          type: int,
          table: GamePlatformRelationData.table,
        );

    GameQuery.addFields(query);

    return query;
  }

  static Query selectAllPlatformsByGameId(GameID id) {
    final Query query = FluentQuery.select()
        .from(PlatformEntityData.table)
        .join(
          GamePlatformRelationData.table,
          null,
          GamePlatformRelationData.platformField,
          PlatformEntityData.table,
          PlatformEntityData.idField,
        )
        .where(
          GamePlatformRelationData.gameField,
          id.id,
          type: int,
          table: GamePlatformRelationData.table,
        );

    PlatformQuery.addFields(query);

    return query;
  }

  static void _addIdWhere(GameID gameId, PlatformID platformId, Query query) {
    query.where(
      GamePlatformRelationData.gameField,
      gameId.id,
      type: int,
      table: GamePlatformRelationData.table,
    );
    query.where(
      GamePlatformRelationData.platformField,
      platformId.id,
      type: int,
      table: GamePlatformRelationData.table,
    );
  }
}

class GamePurchaseRelationQuery {
  GamePurchaseRelationQuery._();

  static Query create(GameID gameId, PurchaseID purchaseId) {
    final Query query = FluentQuery.insert()
        .into(GamePurchaseRelationData.table)
        .set(GamePurchaseRelationData.gameField, gameId.id)
        .set(GamePurchaseRelationData.purchaseField, purchaseId.id);

    return query;
  }

  static Query deleteById(GameID gameId, PurchaseID purchaseId) {
    final Query query =
        FluentQuery.delete().from(GamePurchaseRelationData.table);

    _addIdWhere(gameId, purchaseId, query);

    return query;
  }

  static Query selectAllGamesByPurchaseId(PurchaseID id) {
    final Query query = FluentQuery.select()
        .from(GameEntityData.table)
        .join(
          GamePurchaseRelationData.table,
          null,
          GamePurchaseRelationData.gameField,
          GameEntityData.table,
          GameEntityData.idField,
        )
        .where(
          GamePurchaseRelationData.purchaseField,
          id.id,
          type: int,
          table: GamePurchaseRelationData.table,
        );

    GameQuery.addFields(query);

    return query;
  }

  static Query selectAllPurchasesByGameId(GameID id) {
    final Query query = FluentQuery.select()
        .from(PurchaseEntityData.table)
        .join(
          GamePurchaseRelationData.table,
          null,
          GamePurchaseRelationData.purchaseField,
          PurchaseEntityData.table,
          PurchaseEntityData.idField,
        )
        .where(
          GamePurchaseRelationData.gameField,
          id.id,
          type: int,
          table: GamePurchaseRelationData.table,
        );

    PurchaseQuery.addFields(query);

    return query;
  }

  static void _addIdWhere(GameID gameId, PurchaseID purchaseId, Query query) {
    query.where(
      GamePurchaseRelationData.gameField,
      gameId.id,
      type: int,
      table: GamePurchaseRelationData.table,
    );
    query.where(
      GamePurchaseRelationData.purchaseField,
      purchaseId.id,
      type: int,
      table: GamePurchaseRelationData.table,
    );
  }
}

class GameTagRelationQuery {
  GameTagRelationQuery._();

  static Query create(GameID gameId, GameTagID tagId) {
    final Query query = FluentQuery.insert()
        .into(GameTagRelationData.table)
        .set(GameTagRelationData.gameField, gameId.id)
        .set(GameTagRelationData.tagField, tagId.id);

    return query;
  }

  static Query deleteById(GameID gameId, GameTagID tagId) {
    final Query query = FluentQuery.delete().from(GameTagRelationData.table);

    _addIdWhere(gameId, tagId, query);

    return query;
  }

  static Query selectAllGamesByTagId(GameTagID id) {
    final Query query = FluentQuery.select()
        .from(GameEntityData.table)
        .join(
          GameTagRelationData.table,
          null,
          GameTagRelationData.gameField,
          GameEntityData.table,
          GameEntityData.idField,
        )
        .where(
          GameTagRelationData.tagField,
          id.id,
          type: int,
          table: GameTagRelationData.table,
        );

    GameQuery.addFields(query);

    return query;
  }

  static Query selectAllTagsByGameId(GameID id) {
    final Query query = FluentQuery.select()
        .from(GameTagEntityData.table)
        .join(
          GameTagRelationData.table,
          null,
          GameTagRelationData.tagField,
          GameTagEntityData.table,
          GameTagEntityData.idField,
        )
        .where(
          GameTagRelationData.gameField,
          id.id,
          type: int,
          table: GameTagRelationData.table,
        );

    GameTagQuery.addFields(query);

    return query;
  }

  static void _addIdWhere(GameID gameId, GameTagID tagId, Query query) {
    query.where(
      GameTagRelationData.gameField,
      gameId.id,
      type: int,
      table: GameTagRelationData.table,
    );
    query.where(
      GameTagRelationData.tagField,
      tagId.id,
      type: int,
      table: GameTagRelationData.table,
    );
  }
}
