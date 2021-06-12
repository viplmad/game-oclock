import 'package:flutter_test/flutter_test.dart';

import 'package:sql_builder/sql_builder.dart';

import 'package:backend/connector/item/sql/postgres/postgres_connector.dart';
import 'package:backend/utils/query.dart';
import 'package:backend/utils/fields.dart';


void main() {
  const String _postgresConnectionString = 'postgres://user:pass@host:8080/db';
  test('sql select 1', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql =
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

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {}));
  });

  test('sql select 2', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "Purchase-Main"."ID", "Purchase-Main"."Description", "Purchase-Main"."Price"::float, "Purchase-Main"."External Credit"::float, "Purchase-Main"."Date", "Purchase-Main"."Original Price"::float, "Purchase-Main"."Store" FROM "Purchase-Main"';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    selectFields.add('Description', String);
    selectFields.add('Price', double);
    selectFields.add('External Credit', double);
    selectFields.add('Date', DateTime);
    selectFields.add('Original Price', double);
    selectFields.add('Store', int);
    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('Purchase-Main', selectFields, null, null, null);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {}));
  });

  test('sql select 3', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "Store"."ID" FROM "Store"  INNER JOIN "Purchase" ON ("Store"."ID" = "Purchase"."Store") WHERE "Purchase"."ID" = @whereParam0';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    final int relationId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('ID', relationId);
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Store', 'Purchase', 'ID', 'Store', selectFields, whereQuery, null, null, primaryResults: true);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : relationId}));
  });

  test('sql select 4', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "Game"."ID", "Game"."Name", "Game"."Edition", "Game"."Release Year", "Game"."Cover", "Game"."Status", "Game"."Rating", "Game"."Thoughts", (Extract(hours from "Game"."Time") * 60 + EXTRACT(minutes from "Game"."Time"))::int AS "Time", "Game"."Save Folder", "Game"."Screenshot Folder", "Game"."Finish Date", "Game"."Backup" FROM "Game"  INNER JOIN "Game-Purchase" ON ("Game"."ID" = "Game-Purchase"."Game_ID") WHERE "Game-Purchase"."Purchase_ID" = @whereParam0';

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

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : relationId}));
  });

  test('sql select 5', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "DLC"."ID", "DLC"."Name" FROM "DLC"  INNER JOIN "DLC-Purchase" ON ("DLC"."ID" = "DLC-Purchase"."DLC_ID") WHERE "DLC-Purchase"."Purchase_ID" = @whereParam0';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    selectFields.add('Name', String);
    final int relationId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('Purchase_ID', relationId);
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('DLC', 'DLC-Purchase', 'ID', 'DLC_ID', selectFields, whereQuery, null, null);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : relationId}));
  });

  test('sql select 6', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "Type"."ID", "Type"."Name" FROM "Type"  INNER JOIN "Purchase-Type" ON ("Type"."ID" = "Purchase-Type"."Type_ID") WHERE "Purchase-Type"."Purchase_ID" = @whereParam0';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    selectFields.add('Name', String);
    final int relationId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('Purchase_ID', relationId);
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Type', 'Purchase-Type', 'ID', 'Type_ID', selectFields, whereQuery, null, null);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : relationId}));
  });

  test('sql select 7', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "Purchase"."ID", "Purchase"."Description", "Purchase"."Price"::float, "Purchase"."External Credit"::float, "Purchase"."Date", "Purchase"."Original Price"::float, "Purchase"."Store" FROM "Purchase"  WHERE "Purchase"."ID" = @whereParam0';

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

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : itemId}));
  });

  test('sql select 8', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'UPDATE "Purchase"  SET "Date" = @setParam0 WHERE "ID" = @whereParam0';

    final DateTime newDate = DateTime.now();
    final Map<String, dynamic> setFieldsAndValues = <String, dynamic>{
      'Date': newDate,
    };
    final int itemId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('ID', itemId);
    final QueryBuilder generatedQueryBuilder = connector.updateQueryBuilder('Purchase', setFieldsAndValues, whereQuery);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'setParam0' : newDate, 'whereParam0' : itemId}));
  });

  test('sql update 1', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'UPDATE "Purchase"  SET "Price" = @setParam0, "Date" = @setParam1 WHERE "ID" = @whereParam0';

    final double newPrice = 5.60;
    final Map<String, dynamic> setFieldsAndValues = <String, dynamic>{
      'Price': newPrice,
      'Date': null,
    };
    final int itemId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('ID', itemId);
    final QueryBuilder generatedQueryBuilder = connector.updateQueryBuilder('Purchase', setFieldsAndValues, whereQuery);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'setParam0' : newPrice, 'setParam1' : 'NULL', 'whereParam0' : itemId}));
  });

  test('sql insert 1', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'INSERT INTO "Purchase" ("Description", "Price", "Date") VALUES (@insertParam0, @insertParam1, @insertParam2)';

    final String newDescription = 'description';
    final double newPrice = 5.60;
    final DateTime newDate = DateTime.now();
    final Map<String, dynamic> insertFieldsAndValues = <String, dynamic>{
      'Description': newDescription,
      'Price': newPrice,
      'Date': newDate,
    };
    final QueryBuilder generatedQueryBuilder = connector.insertQueryBuilder('Purchase', insertFieldsAndValues);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'insertParam0' : newDescription, 'insertParam1' : newPrice, 'insertParam2' : newDate}));
  });

  test('sql delete 1', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'DELETE FROM "Platform"  WHERE "ID" = @whereParam0';

    final int itemId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('ID', itemId);
    final QueryBuilder generatedQueryBuilder = connector.deleteQueryBuilder('Platform', whereQuery);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : itemId}));
  });

  test('sql select 9', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "Platform"."Name" FROM "Platform"  WHERE "Platform"."Name" ILIKE @whereParam0 LIMIT 10';

    final Fields selectFields = Fields();
    selectFields.add('Name', String);
    final String name = 'smth';
    final Query whereQuery = Query();
    whereQuery.addAnd('Name', name, QueryComparator.LIKE);
    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('Platform', selectFields, whereQuery, null, 10);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : '%$name%'}));
  });

  test('sql select 10', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "DLC"."Name" FROM "Game"  INNER JOIN "DLC" ON ("Game"."ID" = "DLC"."Base Game") WHERE "Game"."ID" = @whereParam0';

    final Fields selectFields = Fields();
    selectFields.add('Name', String);
    final int itemId = 1;
    final Query whereQuery = Query();
    whereQuery.addAnd('ID', itemId);
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Game', 'DLC', 'ID', 'Base Game', selectFields, whereQuery, null, null, primaryResults: false);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : itemId}));
  });

  test('sql select 11', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "Game"."ID", "Game"."Name", "Game"."Edition", "Game"."Release Year", "Game"."Cover", "Game"."Status", "Game"."Rating", "Game"."Thoughts", "Game"."Save Folder", "Game"."Screenshot Folder", "Game"."Backup", COALESCE(( SELECT sum("GameLog"."Time") AS sum FROM "GameLog" WHERE "GameLog"."Game_ID" = "Game"."ID"), \'00:00:00\'::interval) AS "Time", ( SELECT min("GameFinish"."Date") AS min FROM "GameFinish" WHERE "GameFinish"."Game_ID" = "Game"."ID") AS "Finish Date" FROM "Game"';

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

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {}));
  });

  test('sql select 12', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "ID", "Name", "Edition", "Release Year", "Cover", "Status", "Rating", "Thoughts", (Extract(hours from "Time") * 60 + EXTRACT(minutes from "Time"))::int AS "Time", "Save Folder", "Screenshot Folder", "Finish Date", "Backup" FROM  "All-Year In Review"(2016)';

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
    final QueryBuilder generatedQueryBuilder = connector.selectFunctionQueryBuilder('All-Year In Review', <dynamic>[2016], selectFields, null);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {}));
  });

  test('sql select 13', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "ID", "Description", "Price"::float, "External Credit"::float, "Date", "Original Price"::float, "Store" FROM  "Purchase-Year In Review"(2019)';

    final Fields selectFields = Fields();
    selectFields.add('ID', String);
    selectFields.add('Description', String);
    selectFields.add('Price', double);
    selectFields.add('External Credit', double);
    selectFields.add('Date', DateTime);
    selectFields.add('Original Price', double);
    selectFields.add('Store', int);
    final QueryBuilder generatedQueryBuilder = connector.selectFunctionQueryBuilder('Purchase-Year In Review', <dynamic>[2019], selectFields, null);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {}));
  });

  test('sql select 14', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "Game-Log"."Game_ID", "Game-Log"."DateTime", (Extract(hours from "Game-Log"."Time") * 60 + EXTRACT(minutes from "Game-Log"."Time"))::int AS "Time" FROM "Game-Log"  WHERE "Game-Log"."Game_ID" = @whereParam0';

    final Fields selectFields = Fields();
    selectFields.add('Game_ID', int);
    selectFields.add('DateTime', DateTime);
    selectFields.add('Time', Duration);
    final int itemId = 13;
    final Query whereQuery = Query();
    whereQuery.addAnd('Game_ID', itemId);
    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('Game-Log', selectFields, whereQuery, null, null);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : itemId}));
  });

  test('sql select 15', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "Game-Finish"."Game_ID", "Game-Finish"."Date" FROM "Game-Finish"  WHERE "Game-Finish"."Game_ID" = @whereParam0';

    final Fields selectFields = Fields();
    selectFields.add('Game_ID', int);
    selectFields.add('Date', DateTime);
    final int itemId = 13;
    final Query whereQuery = Query();
    whereQuery.addAnd('Game_ID', itemId);
    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('Game-Finish', selectFields, whereQuery, null, null);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : itemId}));
  });

  test('sql select 16', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String sql = 'SELECT "Game"."ID", "Game"."Name", "Game"."Edition", "Game"."Release Year", "Game"."Cover", "Game"."Status", "Game"."Rating", "Game"."Thoughts", "Game"."Save Folder", "Game"."Screenshot Folder", "Game"."Finish Date", "Game"."Backup", "GameLog"."Game_ID", "GameLog"."DateTime", (Extract(hours from "GameLog"."Time") * 60 + EXTRACT(minutes from "GameLog"."Time"))::int AS "Time" FROM "Game"  LEFT JOIN "GameLog" ON ("Game"."ID" = "GameLog"."Game_ID") WHERE date_part(\'year\', "DateTime") = @whereParam0 ORDER BY "Game_ID" ASC';

    final Fields leftSelectFields = Fields();
    leftSelectFields.add('ID', String);
    leftSelectFields.add('Name', String);
    leftSelectFields.add('Edition', String);
    leftSelectFields.add('Release Year', int);
    leftSelectFields.add('Cover', String);
    leftSelectFields.add('Status', String);
    leftSelectFields.add('Rating', int);
    leftSelectFields.add('Thoughts', String);
    leftSelectFields.add('Save Folder', String);
    leftSelectFields.add('Screenshot Folder', String);
    leftSelectFields.add('Finish Date', DateTime);
    leftSelectFields.add('Backup', bool);
    final Fields rightSelectFields = Fields();
    rightSelectFields.add('Game_ID', int);
    rightSelectFields.add('DateTime', DateTime);
    rightSelectFields.add('Time', Duration);
    final int year = 2021;
    final Query whereQuery = Query();
    whereQuery.addAndDatePart('DateTime', year, DatePart.YEAR);
    final QueryBuilder generatedQueryBuilder = connector.selectJoinQueryBuilder('Game', 'GameLog', 'ID', 'Game_ID', leftSelectFields, rightSelectFields, whereQuery, <String>['Game_ID'], null);

    expect(generatedQueryBuilder.toSql(), equals(sql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'whereParam0' : year}));
  });
}
