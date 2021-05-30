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
    final String insertSql = 'SELECT "Store"."ID" FROM "Purchase"  INNER JOIN "Store" ON ("Purchase"."Store" = "Store"."ID") WHERE "Purchase"."ID" = @param0';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'ID': String,
    };
    final int relationId = 1;
    final QueryBuilder generatedQueryBuilder = connector.selectWeakRelationQueryBuilder('Store', 'Purchase', 'Store', relationId, true, selectFieldsAndTypes, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'param0' : relationId}));
  });

  test('sql select 4', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Game"."ID", "Game"."Name", "Game"."Edition", "Game"."Release Year", "Game"."Cover", "Game"."Status", "Game"."Rating", "Game"."Thoughts", (Extract(hours from "Game"."Time") * 60 + EXTRACT(minutes from "Game"."Time"))::int AS "Time", "Game"."Save Folder", "Game"."Screenshot Folder", "Game"."Finish Date", "Game"."Backup" FROM "Game"  INNER JOIN "Game-Purchase" ON ("Game"."ID" = "Game-Purchase"."Game_ID") WHERE "Game-Purchase"."Purchase_ID" = @param0';

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
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Game', 'Game-Purchase', 'Game_ID', 'Purchase_ID', relationId, selectFieldsAndTypes, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'param0' : relationId}));
  });

  test('sql select 5', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "DLC"."ID", "DLC"."Name" FROM "DLC"  INNER JOIN "DLC-Purchase" ON ("DLC"."ID" = "DLC-Purchase"."DLC_ID") WHERE "DLC-Purchase"."Purchase_ID" = @param0';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'ID': String,
      'Name': String,
    };
    final int relationId = 1;
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('DLC', 'DLC-Purchase', 'DLC_ID', 'Purchase_ID', relationId, selectFieldsAndTypes, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'param0' : relationId}));
  });

  test('sql select 6', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Type"."ID", "Type"."Name" FROM "Type"  INNER JOIN "Purchase-Type" ON ("Type"."ID" = "Purchase-Type"."Type_ID") WHERE "Purchase-Type"."Purchase_ID" = @param0';

    final Map<String, Type> selectFieldsAndTypes = <String, Type>{
      'ID': String,
      'Name': String,
    };
    final int relationId = 1;
    final QueryBuilder generatedQueryBuilder = connector.selectRelationQueryBuilder('Type', 'Purchase-Type', 'Type_ID', 'Purchase_ID', relationId, selectFieldsAndTypes, null);

    expect(generatedQueryBuilder.toSql(), equals(insertSql));
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'param0' : relationId}));
  });

  test('sql select 7', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "Purchase"."ID", "Purchase"."Description", "Purchase"."Price"::float, "Purchase"."External Credit"::float, "Purchase"."Date", "Purchase"."Original Price"::float, "Purchase"."Store" FROM "Purchase"  WHERE "Purchase"."ID" = @param0';

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
    expect(generatedQueryBuilder.buildSubstitutionValues(), equals(<String, dynamic> {'param0' : itemId}));
  });
}
