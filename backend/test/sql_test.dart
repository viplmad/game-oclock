import 'package:flutter_test/flutter_test.dart';

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
    final String insertSql = 'SELECT "Store"."ID" FROM "Purchase"  INNER JOIN "Store" ON ("Purchase"."Store" = "Store"."ID") WHERE "Purchase"."ID" = @whereParam0';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'ID': String,
    };
    final int relationId = 1;
    final QueryBuilder generatedQueryBuilder = connector.selectWeakRelationQueryBuilder('Store', 'Purchase', 'ID', 'Store', relationId, true, selectFieldsAndTypes, null);

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
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Game', 'Game-Purchase', 'ID', 'Game_ID', 'Purchase_ID', relationId, selectFieldsAndTypes, null);

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
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('DLC', 'DLC-Purchase', 'ID', 'DLC_ID', 'Purchase_ID', relationId, selectFieldsAndTypes, null);

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
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Type', 'Purchase-Type', 'ID', 'Type_ID', 'Purchase_ID', relationId, selectFieldsAndTypes, null);

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

    final DateTime setValue = DateTime.now();
    final Map<String, dynamic> setFieldsAndValues = <String, dynamic>{
      'Date': setValue,
    };
    final int itemId = 1;
    final Map<String, dynamic> whereFieldsAndValues = <String, dynamic>{
      'ID': itemId,
    };
    final QueryBuilder generatedQueryBuilder = connector.updateQueryBuilder('Purchase', setFieldsAndValues, whereFieldsAndValues);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'setParam0' : setValue, 'whereParam0' : itemId}));
  });

  test('sql update 1', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'UPDATE "Purchase"  SET "Price" = @setParam0, "Date" = @setParam1 WHERE "ID" = @whereParam0';

    final double setValue0 = 5.60;
    final Map<String, dynamic> setFieldsAndValues = <String, dynamic>{
      'Price': setValue0,
      'Date': null,
    };
    final int itemId = 1;
    final Map<String, dynamic> whereFieldsAndValues = <String, dynamic>{
      'ID': itemId,
    };
    final QueryBuilder generatedQueryBuilder = connector.updateQueryBuilder('Purchase', setFieldsAndValues, whereFieldsAndValues);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'setParam0' : setValue0, 'setParam1' : 'NULL', 'whereParam0' : itemId}));
  });

  test('sql insert 1', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'INSERT INTO "Purchase" ("Description", "Price", "Date") VALUES (@insertParam0, @insertParam1, @insertParam2)';

    final String insertParam0 = 'description';
    final double insertParam1 = 5.60;
    final DateTime insertParam2 = DateTime.now();
    final Map<String, dynamic> insertFieldsAndValues = <String, dynamic>{
      'Description': insertParam0,
      'Price': insertParam1,
      'Date': insertParam2,
    };
    final QueryBuilder generatedQueryBuilder = connector.insertQueryBuilder('Purchase', insertFieldsAndValues);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'insertParam0' : insertParam0, 'insertParam1' : insertParam1, 'insertParam2' : insertParam2}));
  });

  test('sql delete 1', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'DELETE FROM "Platform"  WHERE "ID" = @whereParam0';

    final int whereParam0 = 1;
    final Map<String, dynamic> whereFieldsAndValues = <String, dynamic>{
      'ID': whereParam0,
    };
    final QueryBuilder generatedQueryBuilder = connector.deleteQueryBuilder('Platform', whereFieldsAndValues);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : whereParam0}));
  });

  test('sql select 9', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Platform"."Name" FROM "Platform"  WHERE "Platform"."Name" ILIKE @whereParam0 LIMIT 10';

    final String whereParam0 = 'smth';
    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'Name': String,
    };
    final QueryBuilder generatedQueryBuilder = connector.selectLikeQueryBuilder('Platform', selectFieldsAndTypes, 'Name', whereParam0, 10);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : '%$whereParam0%'}));
  });
}
