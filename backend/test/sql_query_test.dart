// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:query/query.dart'
    show Query, SQLQueryBuilder, SQLBuilderOptions;

import 'package:backend/repository/query/query.dart';
import 'package:backend/entity/entity.dart';

void main() {
  final SQLBuilderOptions _builderOptions =
      SQLBuilderOptions(quoteStringWithFieldsTablesSeparator: false);

  void printQuery(Query query) {
    final String sqlString =
        SQLQueryBuilder.buildString(query, _builderOptions);
    print('SQL: $sqlString');

    final Map<String, Object?> sqlSubstitutionValues =
        SQLQueryBuilder.buildSubstitutionValues(query, _builderOptions);
    print('Substitution values: $sqlSubstitutionValues');

    print(
      '------------------------------------------------------------------------------------------------',
    );
  }

  test('DLC Query test', () {
    final DLCEntity entity = DLCEntity(
      id: 1,
      name: 'name',
      releaseYear: 1994,
      coverFilename: 'coverFilename',
      baseGame: 2,
      firstFinishDate: DateTime.now(),
    );
    final DLCID id = entity.createId();
    final GameID gameId = GameID(99);

    printQuery(DLCQuery.create(entity));
    printQuery(DLCQuery.deleteById(id));
    printQuery(DLCQuery.selectAll());
    printQuery(DLCQuery.selectAllByBaseGame(gameId));
    printQuery(DLCQuery.selectFirstByNameLike('name', 50));
    printQuery(DLCQuery.selectById(id));
    printQuery(DLCQuery.selectGameByDLC(id));
    printQuery(DLCQuery.updateBaseGameById(id, gameId));
    //printQuery(DLCQuery.updateById(id, entity, updatedEntity));
    printQuery(DLCQuery.updateCoverById(id, 'newCoverName'));

    printQuery(DLCQuery.selectAllInView(DLCView.lastCreated));
    printQuery(DLCQuery.selectAllInView(DLCView.main));
  });

  test('Game Query test', () {
    final GameEntity entity = GameEntity(
      id: 1,
      name: 'name',
      edition: 'edition',
      releaseYear: 1999,
      coverFilename: 'coverFilename',
      status: 'status',
      rating: 8,
      thoughts: 'thoughts',
      saveFolder: 'saveFolder',
      screenshotFolder: 'screenshotFolder',
      isBackup: false,
      firstFinishDate: DateTime.now(),
      totalTime: const Duration(minutes: 156),
    );
    final GameID id = entity.createId();

    printQuery(GameQuery.create(entity));
    printQuery(GameQuery.deleteById(id));
    printQuery(GameQuery.selectById(id));
    printQuery(GameQuery.selectAll());
    printQuery(GameQuery.selectFirstByNameLike('name', 50));
    //printQuery(GameQuery.updateById(id, entity, updatedEntity));
    printQuery(GameQuery.updateCoverById(id, 'newCoverName'));

    printQuery(GameQuery.selectAllInView(GameView.lastCreated));
    printQuery(GameQuery.selectAllInView(GameView.lastFinished));
    printQuery(GameQuery.selectAllInView(GameView.lastPlayed));
    printQuery(GameQuery.selectAllInView(GameView.main));
    printQuery(GameQuery.selectAllInView(GameView.nextUp));
    printQuery(GameQuery.selectAllInView(GameView.playing));
    printQuery(GameQuery.selectAllInView(GameView.review));

    printQuery(GameQuery.selectAllOwnedInView(GameView.lastCreated));
    printQuery(GameQuery.selectAllOwnedInView(GameView.lastFinished));
    printQuery(GameQuery.selectAllOwnedInView(GameView.lastPlayed));
    printQuery(GameQuery.selectAllOwnedInView(GameView.main));
    printQuery(GameQuery.selectAllOwnedInView(GameView.nextUp));
    printQuery(GameQuery.selectAllOwnedInView(GameView.playing));
    printQuery(GameQuery.selectAllOwnedInView(GameView.review));

    printQuery(GameQuery.selectAllRomInView(GameView.lastCreated));
    printQuery(GameQuery.selectAllRomInView(GameView.lastFinished));
    printQuery(GameQuery.selectAllRomInView(GameView.lastPlayed));
    printQuery(GameQuery.selectAllRomInView(GameView.main));
    printQuery(GameQuery.selectAllRomInView(GameView.nextUp));
    printQuery(GameQuery.selectAllRomInView(GameView.playing));
    printQuery(GameQuery.selectAllRomInView(GameView.review));
  });

  test('Platform Query test', () {
    const PlatformEntity entity = PlatformEntity(
      id: 1,
      name: 'name',
      iconFilename: 'iconFilename',
      type: 'type',
    );
    final PlatformID id = entity.createId();

    printQuery(PlatformQuery.create(entity));
    printQuery(PlatformQuery.deleteById(id));
    printQuery(PlatformQuery.selectAll());
    printQuery(PlatformQuery.selectFirstByNameLike('name', 50));
    printQuery(PlatformQuery.selectById(id));
    //printQuery(PlatformQuery.updateById(id, entity, updatedEntity));
    printQuery(PlatformQuery.updateIconById(id, 'newIconName'));

    printQuery(PlatformQuery.selectAllInView(PlatformView.lastCreated));
    printQuery(PlatformQuery.selectAllInView(PlatformView.main));
  });

  test('Purchase Query test', () {
    final PurchaseEntity entity = PurchaseEntity(
      id: 1,
      description: 'description',
      price: 4.82,
      externalCredit: 1.00,
      date: DateTime.now(),
      originalPrice: 10.35,
      store: 2,
    );
    final PurchaseID id = entity.createId();
    final StoreID storeId = StoreID(99);

    printQuery(PurchaseQuery.create(entity));
    printQuery(PurchaseQuery.deleteById(id));
    printQuery(PurchaseQuery.selectAll());
    printQuery(PurchaseQuery.selectFirstByDescriptionLike('description', 50));
    printQuery(PurchaseQuery.selectAllByStore(storeId));
    printQuery(PurchaseQuery.selectById(id));
    printQuery(PurchaseQuery.selectStoreByPurchase(id));
    //printQuery(PurchaseQuery.updateById(id, entity, updatedEntity));
    printQuery(PurchaseQuery.updateStoreById(id, storeId));

    printQuery(PurchaseQuery.selectAllInView(PurchaseView.lastCreated));
    printQuery(PurchaseQuery.selectAllInView(PurchaseView.lastPurchased));
    printQuery(PurchaseQuery.selectAllInView(PurchaseView.main));
    printQuery(PurchaseQuery.selectAllInView(PurchaseView.pending));
    printQuery(PurchaseQuery.selectAllInView(PurchaseView.review));
  });

  test('Store Query test', () {
    const StoreEntity entity =
        StoreEntity(id: 1, name: 'name', iconFilename: 'iconFilename');
    final StoreID id = entity.createId();

    printQuery(StoreQuery.create(entity));
    printQuery(StoreQuery.deleteById(id));
    printQuery(StoreQuery.selectAll());
    printQuery(StoreQuery.selectFirstByNameLike('name', 50));
    printQuery(StoreQuery.selectById(id));
    //printQuery(StoreQuery.updateById(id, entity, updatedEntity));
    printQuery(StoreQuery.updateIconById(id, 'newIconName'));

    printQuery(StoreQuery.selectAllInView(StoreView.lastCreated));
    printQuery(StoreQuery.selectAllInView(StoreView.main));
  });

  test('System Query test', () {
    const SystemEntity entity = SystemEntity(
      id: 1,
      name: 'name',
      iconFilename: 'iconFilename',
      generation: 6,
      manufacturer: 'manufacturer',
    );
    final SystemID id = entity.createId();

    printQuery(SystemQuery.create(entity));
    printQuery(SystemQuery.deleteById(id));
    printQuery(SystemQuery.selectAll());
    printQuery(SystemQuery.selectFirstByNameLike('name', 50));
    printQuery(SystemQuery.selectById(id));
    //printQuery(SystemQuery.updateById(id, entity, updatedEntity));
    printQuery(SystemQuery.updateIconById(id, 'newIconName'));

    printQuery(SystemQuery.selectAllInView(SystemView.lastCreated));
    printQuery(SystemQuery.selectAllInView(SystemView.main));
  });

  test('Game Tag Query test', () {
    const GameTagEntity entity = GameTagEntity(id: 1, name: 'name');
    final GameTagID id = entity.createId();

    printQuery(GameTagQuery.create(entity));
    printQuery(GameTagQuery.deleteById(id));
    printQuery(GameTagQuery.selectAll());
    printQuery(GameTagQuery.selectFirstByNameLike('name', 50));
    printQuery(GameTagQuery.selectById(id));
    //printQuery(GameTagQuery.updateById(id, entity, updatedEntity));

    printQuery(GameTagQuery.selectAllInView(GameTagView.lastCreated));
    printQuery(GameTagQuery.selectAllInView(GameTagView.main));
  });

  test('Purchase Type Query test', () {
    const PurchaseTypeEntity entity = PurchaseTypeEntity(id: 1, name: 'name');
    final PurchaseTypeID id = entity.createId();

    printQuery(PurchaseTypeQuery.create(entity));
    printQuery(PurchaseTypeQuery.deleteById(id));
    printQuery(PurchaseTypeQuery.selectAll());
    printQuery(PurchaseTypeQuery.selectFirstByNameLike('name', 50));
    printQuery(PurchaseTypeQuery.selectById(id));
    //printQuery(PurchaseTypeQuery.updateById(id, entity, updatedEntity));

    printQuery(PurchaseTypeQuery.selectAllInView(PurchaseTypeView.lastCreated));
    printQuery(PurchaseTypeQuery.selectAllInView(PurchaseTypeView.main));
  });

  test('DLC Finish Query test', () {
    final DLCFinishEntity entity =
        DLCFinishEntity(dlcId: 1, dateTime: DateTime.now());
    final DLCFinishID id = entity.createId();

    printQuery(DLCFinishQuery.create(entity));
    printQuery(DLCFinishQuery.deleteById(id));
    printQuery(DLCFinishQuery.selectAll());
    printQuery(DLCFinishQuery.selectAllByDLC(id.dlcId));
    printQuery(DLCFinishQuery.selectById(id));
    //printQuery(DLCFinishQuery.updateById(id, entity, updatedEntity));
  });

  test('Game Finish Query test', () {
    final GameFinishEntity entity =
        GameFinishEntity(gameId: 1, dateTime: DateTime.now());
    final GameFinishID id = entity.createId();

    printQuery(GameFinishQuery.create(entity));
    printQuery(GameFinishQuery.deleteById(id));
    printQuery(GameFinishQuery.selectAll());
    printQuery(GameFinishQuery.selectAllByGame(id.gameId));
    printQuery(GameFinishQuery.selectById(id));
    //printQuery(GameFinishQuery.updateById(id, entity, updatedEntity));
  });

  test('Game Time Log Query test', () {
    final GameTimeLogEntity entity = GameTimeLogEntity(
      gameId: 1,
      dateTime: DateTime.now(),
      time: const Duration(minutes: 29),
    );
    final GameTimeLogID id = entity.createId();

    printQuery(GameTimeLogQuery.create(entity));
    printQuery(GameTimeLogQuery.deleteById(id));
    printQuery(GameTimeLogQuery.selectAll());
    printQuery(GameTimeLogQuery.selectAllByGame(id.gameId));
    printQuery(GameTimeLogQuery.selectAllWithGameByYear(2010));
    printQuery(GameTimeLogQuery.selectById(id));
    //printQuery(GameTimeLogQuery.updateById(id, entity, updatedEntity));
  });

  test('DLC Relation Query test', () {
    final DLCID dlcId = DLCID(5);
    final PurchaseID purchaseId = PurchaseID(9);

    printQuery(DLCPurchaseRelationQuery.create(dlcId, purchaseId));
    printQuery(DLCPurchaseRelationQuery.deleteById(dlcId, purchaseId));
    printQuery(DLCPurchaseRelationQuery.selectAllDLCsByPurchaseId(purchaseId));
    printQuery(DLCPurchaseRelationQuery.selectAllPurchasesByDLCId(dlcId));
  });

  test('Game Relation Query test', () {
    final GameID gameId = GameID(5);
    final PlatformID platformId = PlatformID(9);

    printQuery(GamePlatformRelationQuery.create(gameId, platformId));
    printQuery(GamePlatformRelationQuery.deleteById(gameId, platformId));
    printQuery(
      GamePlatformRelationQuery.selectAllGamesByPlatformId(platformId),
    );
    printQuery(GamePlatformRelationQuery.selectAllPlatformsByGameId(gameId));

    final PurchaseID purchaseId = PurchaseID(9);

    printQuery(GamePurchaseRelationQuery.create(gameId, purchaseId));
    printQuery(GamePurchaseRelationQuery.deleteById(gameId, purchaseId));
    printQuery(
      GamePurchaseRelationQuery.selectAllGamesByPurchaseId(purchaseId),
    );
    printQuery(GamePurchaseRelationQuery.selectAllPurchasesByGameId(gameId));

    final GameTagID tagId = GameTagID(9);

    printQuery(GameTagRelationQuery.create(gameId, tagId));
    printQuery(GameTagRelationQuery.deleteById(gameId, tagId));
    printQuery(GameTagRelationQuery.selectAllGamesByTagId(tagId));
    printQuery(GameTagRelationQuery.selectAllTagsByGameId(gameId));
  });

  test('Platform Relation Query test', () {
    final PlatformID platformId = PlatformID(5);
    final SystemID systemId = SystemID(9);

    printQuery(PlatformSystemRelationQuery.create(platformId, systemId));
    printQuery(PlatformSystemRelationQuery.deleteById(platformId, systemId));
    printQuery(
      PlatformSystemRelationQuery.selectAllPlatformsBySystemId(systemId),
    );
    printQuery(
      PlatformSystemRelationQuery.selectAllSystemsByPlatformId(platformId),
    );
  });

  test('Purchase Relation Query test', () {
    final PurchaseID purchaseId = PurchaseID(5);
    final PurchaseTypeID typeId = PurchaseTypeID(9);

    printQuery(PurchaseTypeRelationQuery.create(purchaseId, typeId));
    printQuery(PurchaseTypeRelationQuery.deleteById(purchaseId, typeId));
    printQuery(PurchaseTypeRelationQuery.selectAllPurchasesByTypeId(typeId));
    printQuery(
      PurchaseTypeRelationQuery.selectAllTypesByPurchaseId(purchaseId),
    );
  });
}
