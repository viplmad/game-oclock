// ignore_for_file: overridden_fields

import 'package:postgres/postgres.dart';
import 'package:query/query.dart';

import '../item_connector.dart';


class PostgresConnector extends ItemConnector {
  PostgresConnector.fromConnectionString(String connectionString)
    : _instance = PostgresInstance.fromString(connectionString),
      _builderOptions = SQLBuilderOptions(quoteStringWithFieldsTablesSeparator: false) {

    createConnection();

  }

  final PostgresInstance _instance;
  late PostgreSQLConnection _connection;
  final SQLBuilderOptions _builderOptions;

  void createConnection() {

    _connection = PostgreSQLConnection(
      _instance.host,
      _instance.port,
      _instance.database,
      username: _instance.user,
      password: _instance.password,
      useSSL: true,
    );

  }

  @override
  Future<Object?> open() {

    return _connection.open();

  }

  @override
  Future<Object?> close() {

    return _connection.close();

  }

  @override
  bool isClosed() {

    return _connection.isClosed;

  }

  @override
  bool isOpen() {

    return !isClosed();

  }

  @override
  bool isUpdating() {

    return _connection.queueSize != 0;

  }

  @override
  void reconnect() {

    createConnection();

  }

  @override
  Future<List<Map<String, Map<String, Object?>>>> execute(Query query) {

    return _connection.mappedResultsQuery(
      SQLQueryBuilder.buildString(query, _builderOptions),
      substitutionValues: SQLQueryBuilder.buildSubstitutionValues(query, _builderOptions),
    );

  }
}

const String _postgresURIPattern = '^postgres:\\/\\/(?<user>[^:]*):(?<pass>[^@]*)@(?<host>[^:]*):(?<port>[^\\/]*)\\/(?<db>[^/]*)\$';

class PostgresInstance extends ProviderInstance {
  const PostgresInstance(this.host, this.port, this.database, this.user, this.password);

  final String host;
  final int port;
  final String database;
  final String user;
  final String password;

  factory PostgresInstance.fromString(String connectionString) {

    final RegExp pattern = RegExp(_postgresURIPattern);

    final RegExpMatch? match = pattern.firstMatch(connectionString);

    if (match == null) {
      throw const FormatException('Could not parse Postgres connection string.');
    }

    return PostgresInstance(
      match.namedGroup('host')?? '',
      int.parse(match.namedGroup('port')?? '-1'),
      match.namedGroup('db')?? '',
      match.namedGroup('user')?? '',
      match.namedGroup('pass')?? '',
    );

  }

  @override
  String connectionString() {

    return 'postgres://$user:$password@$host:$port/$database';

  }
}

class PostgresCredentials extends PostgresInstance {
  PostgresCredentials() : host = '', port = -1, database = '', user = '', password = '', super('', -1, '', '', '');

  @override
  String host;
  @override
  int port;
  @override
  String database;
  @override
  String user;
  @override
  String password;
}