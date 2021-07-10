import 'query.dart';
import 'select.dart';
import 'update.dart';
import 'insert.dart';
import 'delete.dart';
import 'raw.dart';

/// API-functions exposed.
class FluentQuery {
  FluentQuery._();

  /// Starts the SELECT-query chain with the provided options
  /// @param options Options to use for query generation.
  /// @return QueryBuilder
  static Query select() {
    return Select();
  }

  /// Starts the UPDATE-query.
  /// @param options Options to use for query generation.
  /// @return QueryBuilder
  static Query update() {
    return Update();
  }

  /// Starts the INSERT-query with the provided options.
  /// @param options Options to use for query generation.
  /// @return QueryBuilder
  static Query insert() {
    return Insert();
  }

  /// Starts the DELETE-query with the provided options.
  /// @param options Options to use for query generation.
  /// @return QueryBuilder
  static Query delete() {
    return Delete();
  }

  /// Starts the DELETE-query with the provided options.
  /// @param options Options to use for query generation.
  /// @return QueryBuilder
  static Query raw(String rawQuery) {
    return Raw(rawQuery);
  }
}
