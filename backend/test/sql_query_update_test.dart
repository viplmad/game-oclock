// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:query/query.dart' show Query, SQLQueryBuilder, SQLBuilderOptions;

import 'package:backend/repository/query/query.dart';
import 'package:backend/entity/entity.dart';


void main() {
  final SQLBuilderOptions _builderOptions = SQLBuilderOptions(quoteStringWithFieldsTablesSeparator: false);

  void printQuery(Query query) {
    final String sqlString = SQLQueryBuilder.buildString(query, _builderOptions);
    print('SQL: $sqlString');

    final Map<String, Object?> sqlSubstitutionValues = SQLQueryBuilder.buildSubstitutionValues(query, _builderOptions);
    print('Substitution values: $sqlSubstitutionValues');

    print('------------------------------------------------------------------------------------------------');
  }

  test('DLC Query test', () {
    final DLCEntity entity = DLCEntity(id: 1, name: 'name', releaseYear: 1994, coverFilename: 'coverFilename', baseGame: 2, firstFinishDate: DateTime.now());
    final DLCEntity updatedEntity = DLCEntity(id: 1, name: 'name2', releaseYear: 1996, coverFilename: 'coverFilename', baseGame: 2, firstFinishDate: DateTime.now().subtract(const Duration(days: 6)));
    final DLCID id = entity.createId();

    //printQuery(DLCQuery.updateById(id, entity, entity));
    printQuery(DLCQuery.updateById(id, entity, updatedEntity));
  });

  test('Game Query test', () {
    final GameEntity entity = GameEntity(id: 1, name: 'name', edition: 'edition', releaseYear: 1999, coverFilename: 'coverFilename', status: 'status', rating: 8, thoughts: 'thoughts', saveFolder: 'saveFolder', screenshotFolder: 'screenshotFolder', isBackup: false, firstFinishDate: DateTime.now(), totalTime: const Duration(minutes: 156));
    final GameEntity updatedEntity = GameEntity(id: 1, name: 'name2', edition: 'edition2', releaseYear: 2010, coverFilename: 'coverFilename', status: 'status', rating: 8, thoughts: 'thoughts', saveFolder: 'saveFolder', screenshotFolder: 'screenshotFolder', isBackup: true, firstFinishDate: DateTime.now().subtract(const Duration(days: 6)), totalTime: const Duration(minutes: 90));
    final GameID id = entity.createId();

    //printQuery(GameQuery.updateById(id, entity, entity));
    printQuery(GameQuery.updateById(id, entity, updatedEntity));
  });

  test('Platform Query test', () {
    const PlatformEntity entity = PlatformEntity(id: 1, name: 'name', iconFilename: 'iconFilename', type: 'type');
    const PlatformEntity updatedEntity = PlatformEntity(id: 1, name: 'name2', iconFilename: 'iconFilename', type: 'type2');
    final PlatformID id = entity.createId();

    //printQuery(PlatformQuery.updateById(id, entity, entity));
    printQuery(PlatformQuery.updateById(id, entity, updatedEntity));
  });

  test('Purchase Query test', () {
    final PurchaseEntity entity = PurchaseEntity(id: 1, description: 'description', price: 4.82, externalCredit: 1.00, date: DateTime.now(), originalPrice: 10.35, store: 2);
    final PurchaseEntity updatedEntity = PurchaseEntity(id: 1, description: 'description2', price: 9, externalCredit: 1.10, date: DateTime.now().subtract(const Duration(days: 6)), originalPrice: 11.50, store: 2);
    final PurchaseID id = entity.createId();

    //printQuery(PurchaseQuery.updateById(id, entity, entity));
    printQuery(PurchaseQuery.updateById(id, entity, updatedEntity));
  });

  test('Store Query test', () {
    const StoreEntity entity = StoreEntity(id: 1, name: 'name', iconFilename: 'iconFilename');
    const StoreEntity updatedEntity = StoreEntity(id: 1, name: 'name2', iconFilename: 'iconFilename');
    final StoreID id = entity.createId();

    //printQuery(StoreQuery.updateById(id, entity, entity));
    printQuery(StoreQuery.updateById(id, entity, updatedEntity));
  });

  test('System Query test', () {
    const SystemEntity entity = SystemEntity(id: 1, name: 'name', iconFilename: 'iconFilename', generation: 6, manufacturer: 'manufacturer');
    const SystemEntity updatedEntity = SystemEntity(id: 1, name: 'name2', iconFilename: 'iconFilename', generation: 1, manufacturer: 'manufacturer2');
    final SystemID id = entity.createId();

    //printQuery(SystemQuery.updateById(id, entity, entity));
    printQuery(SystemQuery.updateById(id, entity, updatedEntity));
  });

  test('Game Tag Query test', () {
    const GameTagEntity entity = GameTagEntity(id: 1, name: 'name');
    const GameTagEntity updatedEntity = GameTagEntity(id: 1, name: 'name2');
    final GameTagID id = entity.createId();

    //printQuery(GameTagQuery.updateById(id, entity, entity));
    printQuery(GameTagQuery.updateById(id, entity, updatedEntity));
  });

  test('Purchase Type Query test', () {
    const PurchaseTypeEntity entity = PurchaseTypeEntity(id: 1, name: 'name');
    const PurchaseTypeEntity updatedEntity = PurchaseTypeEntity(id: 1, name: 'name2');
    final PurchaseTypeID id = entity.createId();

    //printQuery(PurchaseTypeQuery.updateById(id, entity, entity));
    printQuery(PurchaseTypeQuery.updateById(id, entity, updatedEntity));
  });

  test('DLC Finish Query test', () {
    final DLCFinishEntity entity = DLCFinishEntity(dlcId: 1, dateTime: DateTime.now());
    final DLCFinishEntity updatedEntity = DLCFinishEntity(dlcId: 1, dateTime: DateTime.now().subtract(const Duration(days: 6)));
    final DLCFinishID id = entity.createId();

    //printQuery(DLCFinishQuery.updateById(id, entity, entity));
    printQuery(DLCFinishQuery.updateById(id, entity, updatedEntity));
  });

  test('Game Finish Query test', () {
    final GameFinishEntity entity = GameFinishEntity(gameId: 1, dateTime: DateTime.now());
    final GameFinishEntity updatedEntity = GameFinishEntity(gameId: 1, dateTime: DateTime.now().subtract(const Duration(days: 6)));
    final GameFinishID id = entity.createId();

    //printQuery(GameFinishQuery.updateById(id, entity, entity));
    printQuery(GameFinishQuery.updateById(id, entity, updatedEntity));
  });

  test('Game Time Log Query test', () {
    final GameTimeLogEntity entity = GameTimeLogEntity(gameId: 1, dateTime: DateTime.now(), time: const Duration(minutes: 29));
    final GameTimeLogEntity updatedEntity = GameTimeLogEntity(gameId: 1, dateTime: DateTime.now().subtract(const Duration(days: 6)), time: const Duration(minutes: 90));
    final GameTimeLogID id = entity.createId();

    //printQuery(GameTimeLogQuery.updateById(id, entity, entity));
    printQuery(GameTimeLogQuery.updateById(id, entity, updatedEntity));
  });
}