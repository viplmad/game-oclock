import 'package:flutter_test/flutter_test.dart';

import 'package:backend/connector/item/sql/postgres/postgres_connector.dart';
import 'package:sql_builder/sql_builder.dart';

void main() {
  const String _postgresConnectionString = 'postgres://user:pass@host:8080/db';
  test('sql insert', () {
    final PostgresConnector connector = PostgresConnector.fromConnectionString(_postgresConnectionString);
    final String insertSql = 'SELECT "ID", "Name", "Edition", "Release Year", "Cover", "Status", "Rating", "Thoughts", (Extract(hours from "Time") * 60 + EXTRACT(minutes from "Time"))::int AS "Time", "Save Folder", "Screenshot Folder", "Finish Date", "Backup" FROM "All-Playing"';

    final QueryBuilder generatedQueryBuilder = connector.selectTableQueryBuilder('All-Playing', <String, Type>{'ID' : String, 'Name' : String, 'Edition' : String, 'Status' : String, 'Rating' : int, 'Thoughts' : String, 'Time' : Duration, 'Save Folder' : String, 'Screenshot Folder' : String, 'Finish Date' : DateTime, 'Backup' : bool}, null, null, null);

    expect(generatedQueryBuilder.toSql(), insertSql);
  });
}
