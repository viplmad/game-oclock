import 'package:flutter_test/flutter_test.dart';
import 'package:query/query.dart' show Query, SQLQueryBuilder, SQLBuilderOptions;

import 'package:backend/repository/query/query.dart';
import 'package:backend/entity/entity.dart';


void main() {
  final SQLBuilderOptions _builderOptions = SQLBuilderOptions(quoteStringWithFieldsTablesSeparator: false);

  void printQuery(Query query) {
    final String sqlString = SQLQueryBuilder.buildString(query, _builderOptions);
    // ignore: avoid_print
    print('SQL: $sqlString');

    final Map<String, Object?> sqlSubstitutionValues = SQLQueryBuilder.buildSubstitutionValues(query, _builderOptions);
    // ignore: avoid_print
    print('Substitution values: $sqlSubstitutionValues');
  }

  test('DLC Query test', () {
    final DLCEntity entity = DLCEntity(id: 1, name: 'name', releaseYear: 1994, coverFilename: 'coverFilename', finishDate: DateTime.now(), baseGame: 2);
    final DLCID id = entity.createId();
    final GameID gameId = GameID(99);

    printQuery(DLCQuery.create(entity));
    printQuery(DLCQuery.deleteById(id));
    printQuery(DLCQuery.selectAll());
    printQuery(DLCQuery.selectAllByBaseGame(gameId));
    printQuery(DLCQuery.selectAllByNameLike('name', 50));
    printQuery(DLCQuery.selectById(id));
    printQuery(DLCQuery.selectGameByDLC(id));
    printQuery(DLCQuery.updateBaseGameById(id, gameId));
    //printQuery(DLCQuery.updateById(id, entity, updatedEntity));
    printQuery(DLCQuery.updateCoverById(id, 'newCoverName'));

    printQuery(DLCQuery.selectAllInView(DLCView.LastCreated));
    printQuery(DLCQuery.selectAllInView(DLCView.Main));
  });

  test('Game Query test', () {
    final GameEntity entity = GameEntity(id: 1, name: 'name', edition: 'edition', releaseYear: 1999, coverFilename: 'coverFilename', status: 'status', rating: 8, thoughts: 'thoughts', time: const Duration(minutes: 156), saveFolder: 'saveFolder', screenshotFolder: 'screenshotFolder', finishDate: DateTime.now(), isBackup: false);
    final GameID id = entity.createId();

    printQuery(GameQuery.create(entity));
    printQuery(GameQuery.deleteById(id));
    printQuery(GameQuery.selectById(id));
    printQuery(GameQuery.selectAll());
    printQuery(GameQuery.selectAllByNameLike('name', 50));
    //printQuery(GameQuery.updateById(id, entity, updatedEntity));
    printQuery(GameQuery.updateCoverById(id, 'newCoverName'));

    printQuery(GameQuery.selectAllInView(GameView.LastCreated));
    printQuery(GameQuery.selectAllInView(GameView.LastFinished));
    printQuery(GameQuery.selectAllInView(GameView.LastPlayed));
    printQuery(GameQuery.selectAllInView(GameView.Main));
    printQuery(GameQuery.selectAllInView(GameView.NextUp));
    printQuery(GameQuery.selectAllInView(GameView.Playing));
    printQuery(GameQuery.selectAllInView(GameView.Review));


    printQuery(GameQuery.selectAllOwnedInView(GameView.LastCreated));
    printQuery(GameQuery.selectAllOwnedInView(GameView.LastFinished));
    printQuery(GameQuery.selectAllOwnedInView(GameView.LastPlayed));
    printQuery(GameQuery.selectAllOwnedInView(GameView.Main));
    printQuery(GameQuery.selectAllOwnedInView(GameView.NextUp));
    printQuery(GameQuery.selectAllOwnedInView(GameView.Playing));
    printQuery(GameQuery.selectAllOwnedInView(GameView.Review));

    printQuery(GameQuery.selectAllRomInView(GameView.LastCreated));
    printQuery(GameQuery.selectAllRomInView(GameView.LastFinished));
    printQuery(GameQuery.selectAllRomInView(GameView.LastPlayed));
    printQuery(GameQuery.selectAllRomInView(GameView.Main));
    printQuery(GameQuery.selectAllRomInView(GameView.NextUp));
    printQuery(GameQuery.selectAllRomInView(GameView.Playing));
    printQuery(GameQuery.selectAllRomInView(GameView.Review));
  });

  test('Platform Query test', () {
    final PlatformEntity entity = const PlatformEntity(id: 1, name: 'name', iconFilename: 'iconFilename', type: 'type');
    final PlatformID id = entity.createId();

    printQuery(PlatformQuery.create(entity));
    printQuery(PlatformQuery.deleteById(id));
    printQuery(PlatformQuery.selectAll());
    printQuery(PlatformQuery.selectAllByNameLike('name', 50));
    printQuery(PlatformQuery.selectById(id));
    //printQuery(PlatformQuery.updateById(id, entity, updatedEntity));
    printQuery(PlatformQuery.updateIconById(id, 'newIconName'));

    printQuery(PlatformQuery.selectAllInView(PlatformView.LastCreated));
    printQuery(PlatformQuery.selectAllInView(PlatformView.Main));
  });

  test('Purchase Query test', () {
    final PurchaseEntity entity = PurchaseEntity(id: 1, description: 'description', price: 4.82, externalCredit: 1.00, date: DateTime.now(), originalPrice: 10.35, store: 2);
    final PurchaseID id = entity.createId();
    final StoreID storeId = StoreID(99);

    printQuery(PurchaseQuery.create(entity));
    printQuery(PurchaseQuery.deleteById(id));
    printQuery(PurchaseQuery.selectAll());
    printQuery(PurchaseQuery.selectAllByDescriptionLike('description', 50));
    printQuery(PurchaseQuery.selectAllByStore(storeId));
    printQuery(PurchaseQuery.selectById(id));
    printQuery(PurchaseQuery.selectStoreByPurchase(id));
    //printQuery(PurchaseQuery.updateById(id, entity, updatedEntity));
    printQuery(PurchaseQuery.updateStoreById(id, storeId));

    printQuery(PurchaseQuery.selectAllInView(PurchaseView.LastCreated));
    printQuery(PurchaseQuery.selectAllInView(PurchaseView.LastPurchased));
    printQuery(PurchaseQuery.selectAllInView(PurchaseView.Main));
    printQuery(PurchaseQuery.selectAllInView(PurchaseView.Pending));
    printQuery(PurchaseQuery.selectAllInView(PurchaseView.Review));
  });

  test('Store Query test', () {
    final StoreEntity entity = const StoreEntity(id: 1, name: 'name', iconFilename: 'iconFilename');
    final StoreID id = entity.createId();

    printQuery(StoreQuery.create(entity));
    printQuery(StoreQuery.deleteById(id));
    printQuery(StoreQuery.selectAll());
    printQuery(StoreQuery.selectAllByNameLike('name', 50));
    printQuery(StoreQuery.selectById(id));
    //printQuery(StoreQuery.updateById(id, entity, updatedEntity));
    printQuery(StoreQuery.updateIconById(id, 'newIconName'));

    printQuery(StoreQuery.selectAllInView(StoreView.LastCreated));
    printQuery(StoreQuery.selectAllInView(StoreView.Main));
  });

  test('System Query test', () {
    final SystemEntity entity = const SystemEntity(id: 1, name: 'name', iconFilename: 'iconFilename', generation: 6, manufacturer: 'manufacturer');
    final SystemID id = entity.createId();

    printQuery(SystemQuery.create(entity));
    printQuery(SystemQuery.deleteById(id));
    printQuery(SystemQuery.selectAll());
    printQuery(SystemQuery.selectAllByNameLike('name', 50));
    printQuery(SystemQuery.selectById(id));
    //printQuery(SystemQuery.updateById(id, entity, updatedEntity));
    printQuery(SystemQuery.updateIconById(id, 'newIconName'));

    printQuery(SystemQuery.selectAllInView(SystemView.LastCreated));
    printQuery(SystemQuery.selectAllInView(SystemView.Main));
  });

  test('Game Tag Query test', () {
    final GameTagEntity entity = const GameTagEntity(id: 1, name: 'name');
    final GameTagID id = entity.createId();

    printQuery(GameTagQuery.create(entity));
    printQuery(GameTagQuery.deleteById(id));
    printQuery(GameTagQuery.selectAll());
    printQuery(GameTagQuery.selectAllByNameLike('name', 50));
    printQuery(GameTagQuery.selectById(id));
    //printQuery(GameTagQuery.updateById(id, entity, updatedEntity));

    printQuery(GameTagQuery.selectAllInView(GameTagView.LastCreated));
    printQuery(GameTagQuery.selectAllInView(GameTagView.Main));
  });

  test('Purchase Type Query test', () {
    final PurchaseTypeEntity entity = const PurchaseTypeEntity(id: 1, name: 'name');
    final PurchaseTypeID id = entity.createId();

    printQuery(PurchaseTypeQuery.create(entity));
    printQuery(PurchaseTypeQuery.deleteById(id));
    printQuery(PurchaseTypeQuery.selectAll());
    printQuery(PurchaseTypeQuery.selectAllByNameLike('name', 50));
    printQuery(PurchaseTypeQuery.selectById(id));
    //printQuery(PurchaseTypeQuery.updateById(id, entity, updatedEntity));

    printQuery(PurchaseTypeQuery.selectAllInView(PurchaseTypeView.LastCreated));
    printQuery(PurchaseTypeQuery.selectAllInView(PurchaseTypeView.Main));
  });

  test('DLC Finish Query test', () {
    final DLCFinishEntity entity = DLCFinishEntity(dlcId: 1, dateTime: DateTime.now());
    final DLCFinishID id = entity.createId();

    printQuery(DLCFinishQuery.create(entity));
    printQuery(DLCFinishQuery.deleteById(id));
    printQuery(DLCFinishQuery.selectAll());
    printQuery(DLCFinishQuery.selectAllByDLC(id.dlcId));
    printQuery(DLCFinishQuery.selectById(id));
    //printQuery(DLCFinishQuery.updateById(id, entity, updatedEntity));
  });

  test('Game Finish Query test', () {
    final GameFinishEntity entity = GameFinishEntity(gameId: 1, dateTime: DateTime.now());
    final GameFinishID id = entity.createId();

    printQuery(GameFinishQuery.create(entity));
    printQuery(GameFinishQuery.deleteById(id));
    printQuery(GameFinishQuery.selectAll());
    printQuery(GameFinishQuery.selectAllByGame(id.gameId));
    printQuery(GameFinishQuery.selectById(id));
    //printQuery(GameFinishQuery.updateById(id, entity, updatedEntity));
  });

  test('Game Time Log Query test', () {
    final GameTimeLogEntity entity = GameTimeLogEntity(gameId: 1, dateTime: DateTime.now(), time: const Duration(minutes: 29));
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
    printQuery(GamePlatformRelationQuery.selectAllGamesByPlatformId(platformId));
    printQuery(GamePlatformRelationQuery.selectAllPlatformsByGameId(gameId));


    final PurchaseID purchaseId = PurchaseID(9);

    printQuery(GamePurchaseRelationQuery.create(gameId, purchaseId));
    printQuery(GamePurchaseRelationQuery.deleteById(gameId, purchaseId));
    printQuery(GamePurchaseRelationQuery.selectAllGamesByPurchaseId(purchaseId));
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
    printQuery(PlatformSystemRelationQuery.selectAllPlatformsBySystemId(systemId));
    printQuery(PlatformSystemRelationQuery.selectAllSystemsByPlatformId(platformId));
  });

  test('Purchase Relation Query test', () {
    final PurchaseID purchaseId = PurchaseID(5);
    final PurchaseTypeID typeId = PurchaseTypeID(9);

    printQuery(PurchaseTypeRelationQuery.create(purchaseId, typeId));
    printQuery(PurchaseTypeRelationQuery.deleteById(purchaseId, typeId));
    printQuery(PurchaseTypeRelationQuery.selectAllPurchasesByTypeId(typeId));
    printQuery(PurchaseTypeRelationQuery.selectAllTypesByPurchaseId(purchaseId));
  });
}