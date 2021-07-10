import 'package:query/query.dart';

import 'block/block.dart';
import 'divider_type.dart';
import 'exception.dart';
import 'join_type.dart';
import 'sort_order.dart';
import 'union_type.dart';
import 'operator_type.dart';


abstract class Query {
  Query(List<Block>? blocks) {
    this.blocks = blocks ?? <Block>[];
  }

  late final List<Block> blocks;

  //
  // DISTINCT
  //
  Query distinct() {
    throw UnsupportedOperationException('`distinct` not implemented');
  }

  //
  // FROM
  //
  Query from(String table, {String? alias}) {
    throw UnsupportedOperationException('`from` not implemented');
  }

  Query fromSubquery(Query query, {String? alias}) {
    throw UnsupportedOperationException('`fromSubquery` not implemented');
  }

  //
  // GET FIELDS
  //
  Query field(String field, {Type? type, String? table, String? alias}) {
    throw UnsupportedOperationException('`field` not implemented');
  }

  Query fieldSubquery(Query query, {String? alias}) {
    throw UnsupportedOperationException('`fieldSubquery` not implemented');
  }

  Query fields(Iterable<String> fields, {String? table}) {
    throw UnsupportedOperationException('`fields` not implemented');
  }

  //
  // RETURNING FIELDS
  //
  Query returningField(String field) {
    throw UnsupportedOperationException('`returningField` not implemented');
  }

  //
  // GROUP
  //
  Query group(String field, {String? table}) {
    throw UnsupportedOperationException('`group` not implemented');
  }

  Query groupSubquery(Query query) {
    throw UnsupportedOperationException('`groupSubquery` not implemented');
  }

  Query groups(Iterable<String> fields, {String? table}) {
    throw UnsupportedOperationException('`groups` not implemented');
  }

  //
  // JOIN
  //
  Query join(String table, String? alias, String field, String joinTable, String joinField, {JoinType type = JoinType.INNER}) {
    throw UnsupportedOperationException('`join` not implemented');
  }

  Query joinSubquery(Query query, String alias, String field, String joinTable, String joinField, {JoinType type = JoinType.INNER}) {
    throw UnsupportedOperationException('`joinSubquery` not implemented');
  }

  //
  // WHERE
  //
  Query where(String field, Object? value, {Type? type, String? table, OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    throw UnsupportedOperationException('`where` not implemented');
  }

  Query orWhere(String field, Object? value, {Type? type, String? table, OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    throw UnsupportedOperationException('`orWhere` not implemented');
  }

  Query whereDatePart(String field, int value, DatePart datePart, {String? table, OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    throw UnsupportedOperationException('`where` not implemented');
  }

  Query orWhereDatePart(String field, int value, DatePart datePart, {String? table, OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    throw UnsupportedOperationException('`orWhere` not implemented');
  }

  Query whereSubquery(Query query, Object? value, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    throw UnsupportedOperationException('`whereSubquery` not implemented');
  }

  Query orWhereSubquery(Query query, Object? value, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    throw UnsupportedOperationException('`orWhereSubquery` not implemented');
  }

  //
  // LIMIT
  //
  Query limit(int? value) {
    throw UnsupportedOperationException('`limit` not implemented');
  }

  //
  // ORDER BY
  //
  Query order(String field, String? table, {SortOrder direction = SortOrder.ASC, bool nullsLast = false}) {
    throw UnsupportedOperationException('`order` not implemented');
  }

  Query orderSubquery(Query query, {SortOrder direction = SortOrder.ASC, bool nullsLast = false}) {
    throw UnsupportedOperationException('`orderSubquery` not implemented');
  }

  //
  // OFFSET
  //
  Query offset(int value) {
    throw UnsupportedOperationException('`offset` not implemented');
  }

  //
  // UNION
  //
  Query union(String table, {UnionType unionType = UnionType.UNION}) {
    throw UnsupportedOperationException('union not implemented');
  }

  Query unionSubquery(Query query, {UnionType unionType = UnionType.UNION}) {
    throw UnsupportedOperationException('unionSubQuery not implemented');
  }

  //
  // TABLE
  //
  Query table(String table, {String? alias}) {
    throw UnsupportedOperationException('`table` not implemented');
  }

  Query tableSubquery(Query query, {String? alias}) {
    throw UnsupportedOperationException('`tableSubquery` not implemented');
  }

  //
  // SET
  //
  Query set(String field, Object? value) {
    throw UnsupportedOperationException('`set` not implemented');
  }

  Query sets(Map<String, Object?> fieldsAndValues) {
    throw UnsupportedOperationException('`sets` not implemented');
  }

  //
  // INTO
  //
  Query into(String table) {
    throw UnsupportedOperationException('`into` not implemented');
  }

  //
  // `FROM QUERY`
  //
  Query fromQuery(Iterable<String> fields, Query query) {
    throw UnsupportedOperationException('`fromQuery` not implemented');
  }
}
