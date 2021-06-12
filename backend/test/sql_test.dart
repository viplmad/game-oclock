import 'package:flutter_test/flutter_test.dart';

import 'package:sql_builder/sql_builder.dart';

import 'package:backend/connector/item/sql/postgres/postgres_connector.dart';
import 'package:backend/query/query.dart';
import 'package:backend/query/fields.dart';


void main() {
  const String _postgresConnectionString = 'postgres://user:pass@host:8080/db';
  test('sql select 1', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql =
        'SELECT "All-Playing"."ID", "All-Playing"."Name", "All-Playing"."Edition", "All-Playing"."Release Year", "All-Playing"."Cover", "All-Playing"."Status", "All-Playing"."Rating", "All-Playing"."Thoughts", (Extract(hours from "All-Playing"."Time") * 60 + EXTRACT(minutes from "All-Playing"."Time"))::int AS "Time", "All-Playing"."Save Folder", "All-Playing"."Screenshot Folder", "All-Playing"."Finish Date", "All-Playing"."Backup" FROM "All-Playing"';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    selectFields.add('Name', String);
    selectFields.add('Edition', String);
    selectFields.add('Release Year', int);
    selectFields.add('Cover', String);
    selectFields.add('Status', String);
    selectFields.add('Rating', int);
    selectFields.add('Thoughts', String);
    selectFields.add('Time', Duration);
    selectFields.add('Save Folder', String);
    selectFields.add('Screenshot Folder', String);
    selectFields.add('Finish Date', DateTime);
    selectFields.add('Backup', bool);
    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('All-Playing', selectFields, null, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
  });

  test('sql select 2', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Purchase-Main"."ID", "Purchase-Main"."Description", "Purchase-Main"."Price"::float, "Purchase-Main"."External Credit"::float, "Purchase-Main"."Date", "Purchase-Main"."Original Price"::float, "Purchase-Main"."Store" FROM "Purchase-Main"';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    selectFields.add('Description', String);
    selectFields.add('Price', double);
    selectFields.add('External Credit', double);
    selectFields.add('Date', DateTime);
    selectFields.add('Original Price', double);
    selectFields.add('Store', int);
    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('Purchase-Main', selectFields, null, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
  });

  test('sql select 3', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Store"."ID" FROM "Store"  INNER JOIN "Purchase" ON ("Store"."ID" = "Purchase"."Store") WHERE "Purchase"."ID" = @whereParam0';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    final int relationId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('ID', relationId);
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Store', 'Purchase', 'ID', 'Store', selectFields, whereQuery, null, null, primaryResults: true);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : relationId}));
  });

  test('sql select 4', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Game"."ID", "Game"."Name", "Game"."Edition", "Game"."Release Year", "Game"."Cover", "Game"."Status", "Game"."Rating", "Game"."Thoughts", (Extract(hours from "Game"."Time") * 60 + EXTRACT(minutes from "Game"."Time"))::int AS "Time", "Game"."Save Folder", "Game"."Screenshot Folder", "Game"."Finish Date", "Game"."Backup" FROM "Game"  INNER JOIN "Game-Purchase" ON ("Game"."ID" = "Game-Purchase"."Game_ID") WHERE "Game-Purchase"."Purchase_ID" = @whereParam0';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    selectFields.add('Name', String);
    selectFields.add('Edition', String);
    selectFields.add('Release Year', int);
    selectFields.add('Cover', String);
    selectFields.add('Status', String);
    selectFields.add('Rating', int);
    selectFields.add('Thoughts', String);
    selectFields.add('Time', Duration);
    selectFields.add('Save Folder', String);
    selectFields.add('Screenshot Folder', String);
    selectFields.add('Finish Date', DateTime);
    selectFields.add('Backup', bool);
    final int relationId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('Purchase_ID', relationId);
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Game', 'Game-Purchase', 'ID', 'Game_ID', selectFields, whereQuery, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : relationId}));
  });

  test('sql select 5', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "DLC"."ID", "DLC"."Name" FROM "DLC"  INNER JOIN "DLC-Purchase" ON ("DLC"."ID" = "DLC-Purchase"."DLC_ID") WHERE "DLC-Purchase"."Purchase_ID" = @whereParam0';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    selectFields.add('Name', String);
    final int relationId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('Purchase_ID', relationId);
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('DLC', 'DLC-Purchase', 'ID', 'DLC_ID', selectFields, whereQuery, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : relationId}));
  });

  test('sql select 6', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Type"."ID", "Type"."Name" FROM "Type"  INNER JOIN "Purchase-Type" ON ("Type"."ID" = "Purchase-Type"."Type_ID") WHERE "Purchase-Type"."Purchase_ID" = @whereParam0';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    selectFields.add('Name', String);
    final int relationId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('Purchase_ID', relationId);
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Type', 'Purchase-Type', 'ID', 'Type_ID', selectFields, whereQuery, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : relationId}));
  });

  test('sql select 7', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Purchase"."ID", "Purchase"."Description", "Purchase"."Price"::float, "Purchase"."External Credit"::float, "Purchase"."Date", "Purchase"."Original Price"::float, "Purchase"."Store" FROM "Purchase"  WHERE "Purchase"."ID" = @whereParam0';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    selectFields.add('Description', String);
    selectFields.add('Price', double);
    selectFields.add('External Credit', double);
    selectFields.add('Date', DateTime);
    selectFields.add('Original Price', double);
    selectFields.add('Store', int);
    final int itemId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('ID', itemId);
    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('Purchase', selectFields, whereQuery, null, null);

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
    final Query whereQuery = Query();
    whereQuery.addAnd('ID', itemId);
    final QueryBuilder generatedQueryBuilder = connector.updateQueryBuilder('Purchase', setFieldsAndValues, whereQuery);

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
    final Query whereQuery = Query();
    whereQuery.addAnd('ID', itemId);
    final QueryBuilder generatedQueryBuilder = connector.updateQueryBuilder('Purchase', setFieldsAndValues, whereQuery);

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
    final Query whereQuery = Query();
    whereQuery.addAnd('ID', itemId);
    final QueryBuilder generatedQueryBuilder = connector.deleteQueryBuilder('Platform', whereQuery);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : itemId}));
  });

  test('sql select 9', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Platform"."Name" FROM "Platform"  WHERE "Platform"."Name" ILIKE @whereParam0 LIMIT 10';

    final Fields selectFields = Fields();
    selectFields.add('Name', String);
    final String name = 'smth';
    final Query whereQuery = Query();
    whereQuery.addAnd('Name', name, QueryComparator.LIKE);
    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('Platform', selectFields, whereQuery, null, 10);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : '%$name%'}));
  });

  test('sql select 10', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "DLC"."Name" FROM "Game"  INNER JOIN "DLC" ON ("Game"."ID" = "DLC"."Base Game") WHERE "Game"."ID" = @whereParam0';

    final Fields selectFields = Fields();
    selectFields.add('Name', String);
    final int itemId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('ID', itemId);
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Game', 'DLC', 'ID', 'Base Game', selectFields, whereQuery, null, null, primaryResults: false);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : itemId}));
  });

  test('sql select 11', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Game"."ID", "Game"."Name", "Game"."Edition", "Game"."Release Year", "Game"."Cover", "Game"."Status", "Game"."Rating", "Game"."Thoughts", "Game"."Save Folder", "Game"."Screenshot Folder", "Game"."Backup", COALESCE(( SELECT sum("GameLog"."Time") AS sum FROM "GameLog" WHERE "GameLog"."Game_ID" = "Game"."ID"), \'00:00:00\'::interval) AS "Time", ( SELECT min("GameFinish"."Date") AS min FROM "GameFinish" WHERE "GameFinish"."Game_ID" = "Game"."ID") AS "Finish Date" FROM "Game"';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    selectFields.add('Name', String);
    selectFields.add('Edition', String);
    selectFields.add('Release Year', int);
    selectFields.add('Cover', String);
    selectFields.add('Status', String);
    selectFields.add('Rating', int);
    selectFields.add('Thoughts', String);
    selectFields.add('Save Folder', String);
    selectFields.add('Screenshot Folder', String);
    selectFields.add('Backup', bool);
    selectFields.addRaw('COALESCE(( SELECT sum("GameLog"."Time") AS sum FROM "GameLog" WHERE "GameLog"."Game_ID" = "Game"."ID"), \'00:00:00\'::interval) AS "Time"');
    selectFields.addRaw('( SELECT min("GameFinish"."Date") AS min FROM "GameFinish" WHERE "GameFinish"."Game_ID" = "Game"."ID") AS "Finish Date"');
    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('Game', selectFields, null, null, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
  });

  test('sql select 12', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    // TODO revise from bloc branch
    final String insertSql = 'SELECT "ID", "Name", "Edition", "Release Year", "Cover", "Status", "Rating", "Thoughts", "Save Folder", "Screenshot Folder", "Backup" FROM  "Owned-Year In Review"(2020)';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    selectFields.add('Name', String);
    selectFields.add('Edition', String);
    selectFields.add('Release Year', int);
    selectFields.add('Cover', String);
    selectFields.add('Status', String);
    selectFields.add('Rating', int);
    selectFields.add('Thoughts', String);
    selectFields.add('Save Folder', String);
    selectFields.add('Screenshot Folder', String);
    selectFields.add('Backup', bool);
    final QueryBuilder generatedQueryBuilder = connector.selectFunctionQueryBuilder('Owned-Year In Review', <dynamic>[2020], selectFields, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
  });
}
