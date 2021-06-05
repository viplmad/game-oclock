import 'package:test/test.dart';

import 'package:backend/connector/item/sql/postgres/postgres_connector.dart';
import 'package:sql_builder/sql_builder.dart';

void main() {
  const String _postgresConnectionString = 'postgres://user:pass@host:8080/db';
  test('sql select 1', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql =
        'SELECT "All-Playing"."ID", "All-Playing"."Name", "All-Playing"."Edition", "All-Playing"."Release Year", "All-Playing"."Cover", "All-Playing"."Status", "All-Playing"."Rating", "All-Playing"."Thoughts", (Extract(hours from "All-Playing"."Time") * 60 + EXTRACT(minutes from "All-Playing"."Time"))::int AS "Time", "All-Playing"."Save Folder", "All-Playing"."Screenshot Folder", "All-Playing"."Finish Date", "All-Playing"."Backup" FROM "All-Playing"';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'ID': String,
      'Name': String,
      'Edition': String,
      'Release Year': int,
      'Cover': String,
      'Status': String,
      'Rating': int,
      'Thoughts': String,
      'Time': Duration,
      'Save Folder': String,
      'Screenshot Folder': String,
      'Finish Date': DateTime,
      'Backup': bool,
    };
    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('All-Playing', selectFieldsAndTypes, null, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
  });

  test('sql select 2', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Purchase-Main"."ID", "Purchase-Main"."Description", "Purchase-Main"."Price"::float, "Purchase-Main"."External Credit"::float, "Purchase-Main"."Date", "Purchase-Main"."Original Price"::float, "Purchase-Main"."Store" FROM "Purchase-Main"';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'ID': String,
      'Description': String,
      'Price': double,
      'External Credit': double,
      'Date': DateTime,
      'Original Price': double,
      'Store': int,
    };
    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('Purchase-Main', selectFieldsAndTypes, null, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
  });

  test('sql select 3', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Store"."ID" FROM "Store"  INNER JOIN "Purchase" ON ("Store"."ID" = "Purchase"."Store") WHERE "Purchase"."ID" = @whereParam0';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'ID': String,
    };
    final int relationId = 1;
    final Map<String, dynamic> whereFieldsAndValues = <String, dynamic>{
      'ID': relationId,
    };
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Store', 'Purchase', 'ID', 'Store', selectFieldsAndTypes, whereFieldsAndValues, null, null, primaryResults: true);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : relationId}));
  });

  test('sql select 4', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Game"."ID", "Game"."Name", "Game"."Edition", "Game"."Release Year", "Game"."Cover", "Game"."Status", "Game"."Rating", "Game"."Thoughts", (Extract(hours from "Game"."Time") * 60 + EXTRACT(minutes from "Game"."Time"))::int AS "Time", "Game"."Save Folder", "Game"."Screenshot Folder", "Game"."Finish Date", "Game"."Backup" FROM "Game"  INNER JOIN "Game-Purchase" ON ("Game"."ID" = "Game-Purchase"."Game_ID") WHERE "Game-Purchase"."Purchase_ID" = @whereParam0';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'ID': String,
      'Name': String,
      'Edition': String,
      'Release Year': int,
      'Cover': String,
      'Status': String,
      'Rating': int,
      'Thoughts': String,
      'Time': Duration,
      'Save Folder': String,
      'Screenshot Folder': String,
      'Finish Date': DateTime,
      'Backup': bool,
    };
    final int relationId = 1;
    final Map<String, dynamic> whereFieldsAndVales = <String, dynamic>{
      'Purchase_ID': relationId,
    };
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Game', 'Game-Purchase', 'ID', 'Game_ID', selectFieldsAndTypes, whereFieldsAndVales, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : relationId}));
  });

  test('sql select 5', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "DLC"."ID", "DLC"."Name" FROM "DLC"  INNER JOIN "DLC-Purchase" ON ("DLC"."ID" = "DLC-Purchase"."DLC_ID") WHERE "DLC-Purchase"."Purchase_ID" = @whereParam0';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'ID': String,
      'Name': String,
    };
    final int relationId = 1;
    final Map<String, dynamic> whereFieldsAndValues = <String, dynamic>{
      'Purchase_ID': relationId,
    };
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('DLC', 'DLC-Purchase', 'ID', 'DLC_ID', selectFieldsAndTypes, whereFieldsAndValues, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : relationId}));
  });

  test('sql select 6', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Type"."ID", "Type"."Name" FROM "Type"  INNER JOIN "Purchase-Type" ON ("Type"."ID" = "Purchase-Type"."Type_ID") WHERE "Purchase-Type"."Purchase_ID" = @whereParam0';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'ID': String,
      'Name': String,
    };
    final int relationId = 1;
    final Map<String, dynamic> whereFieldsAndValues = <String, dynamic>{
      'Purchase_ID': relationId,
    };
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Type', 'Purchase-Type', 'ID', 'Type_ID', selectFieldsAndTypes, whereFieldsAndValues, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : relationId}));
  });

  test('sql select 7', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Purchase"."ID", "Purchase"."Description", "Purchase"."Price"::float, "Purchase"."External Credit"::float, "Purchase"."Date", "Purchase"."Original Price"::float, "Purchase"."Store" FROM "Purchase"  WHERE "Purchase"."ID" = @whereParam0';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'ID': String,
      'Description': String,
      'Price': double,
      'External Credit': double,
      'Date': DateTime,
      'Original Price': double,
      'Store': int,
    };
    final int itemId = 1;
    final Map<String, dynamic> whereFieldsAndValues = <String, dynamic>{
      'ID': itemId,
    };
    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('Purchase', selectFieldsAndTypes, whereFieldsAndValues, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : itemId}));
  });

  test('sql select 8', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'UPDATE "Purchase"  SET "Date" = @setParam0 WHERE "ID" = @whereParam0';

    final DateTime newDate = DateTime.now();
    final Map<String, dynamic> setFieldsAndValues = <String, dynamic>{
      'Date': newDate,
    };
    final int itemId = 1;
    final Map<String, dynamic> whereFieldsAndValues = <String, dynamic>{
      'ID': itemId,
    };
    final QueryBuilder generatedQueryBuilder = connector.updateQueryBuilder('Purchase', setFieldsAndValues, whereFieldsAndValues);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'setParam0' : newDate, 'whereParam0' : itemId}));
  });

  test('sql update 1', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'UPDATE "Purchase"  SET "Price" = @setParam0, "Date" = @setParam1 WHERE "ID" = @whereParam0';

    final double newPrice = 5.60;
    final Map<String, dynamic> setFieldsAndValues = <String, dynamic>{
      'Price': newPrice,
      'Date': null,
    };
    final int itemId = 1;
    final Map<String, dynamic> whereFieldsAndValues = <String, dynamic>{
      'ID': itemId,
    };
    final QueryBuilder generatedQueryBuilder = connector.updateQueryBuilder('Purchase', setFieldsAndValues, whereFieldsAndValues);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'setParam0' : newPrice, 'setParam1' : 'NULL', 'whereParam0' : itemId}));
  });

  test('sql insert 1', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'INSERT INTO "Purchase" ("Description", "Price", "Date") VALUES (@insertParam0, @insertParam1, @insertParam2)';

    final String newDescription = 'description';
    final double newPrice = 5.60;
    final DateTime newDate = DateTime.now();
    final Map<String, dynamic> insertFieldsAndValues = <String, dynamic>{
      'Description': newDescription,
      'Price': newPrice,
      'Date': newDate,
    };
    final QueryBuilder generatedQueryBuilder = connector.insertQueryBuilder('Purchase', insertFieldsAndValues);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'insertParam0' : newDescription, 'insertParam1' : newPrice, 'insertParam2' : newDate}));
  });

  test('sql delete 1', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'DELETE FROM "Platform"  WHERE "ID" = @whereParam0';

    final int itemId = 1;
    final Map<String, dynamic> whereFieldsAndValues = <String, dynamic>{
      'ID': itemId,
    };
    final QueryBuilder generatedQueryBuilder = connector.deleteQueryBuilder('Platform', whereFieldsAndValues);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : itemId}));
  });

  test('sql select 9', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Platform"."Name" FROM "Platform"  WHERE "Platform"."Name" ILIKE @whereParam0 LIMIT 10';

    final String name = 'smth';
    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'Name': String,
    };
    final QueryBuilder generatedQueryBuilder = connector.selectLikeQueryBuilder('Platform', selectFieldsAndTypes, 'Name', name, 10);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : '%$name%'}));
  });

  test('sql select 10', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "DLC"."Name" FROM "Game"  INNER JOIN "DLC" ON ("Game"."ID" = "DLC"."Base Game") WHERE "Game"."ID" = @whereParam0';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'Name': String,
    };
    final int itemId = 1;
    final Map<String, dynamic> whereFieldsAndValues = <String, dynamic>{
      'ID': itemId,
    };
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Game', 'DLC', 'ID', 'Base Game', selectFieldsAndTypes, whereFieldsAndValues, null, null, primaryResults: false);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : itemId}));
  });

  test('sql select 11', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Game"."ID", "Game"."Name", "Game"."Edition", "Game"."Release Year", "Game"."Cover", "Game"."Status", "Game"."Rating", "Game"."Thoughts", "Game"."Save Folder", "Game"."Screenshot Folder", "Game"."Backup", COALESCE(( SELECT sum("GameLog"."Time") AS sum FROM "GameLog" WHERE "GameLog"."Game_ID" = "Game"."ID"), \'00:00:00\'::interval) AS "Time", ( SELECT min("GameFinish"."Date") AS min FROM "GameFinish" WHERE "GameFinish"."Game_ID" = "Game"."ID") AS "Finish Date" FROM "Game"';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'ID': String,
      'Name': String,
      'Edition': String,
      'Release Year': int,
      'Cover': String,
      'Status': String,
      'Rating': int,
      'Thoughts': String,
      'Save Folder': String,
      'Screenshot Folder': String,
      'Backup': bool,
    };
    final List<String> rawSelects = <String>[
      'COALESCE(( SELECT sum("GameLog"."Time") AS sum FROM "GameLog" WHERE "GameLog"."Game_ID" = "Game"."ID"), \'00:00:00\'::interval) AS "Time"',
      '( SELECT min("GameFinish"."Date") AS min FROM "GameFinish" WHERE "GameFinish"."Game_ID" = "Game"."ID") AS "Finish Date"',
    ];
    final QueryBuilder generatedQueryBuilder = connector.selectSpecial('Game', selectFieldsAndTypes, rawSelects, null, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
  });
}
