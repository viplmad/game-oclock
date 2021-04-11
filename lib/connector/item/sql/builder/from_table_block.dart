import 'table_block_base.dart';
import 'query_builder_options.dart';
import 'query_builder.dart';

/// FROM table
class FromTableBlock extends TableBlockBase {
  FromTableBlock(QueryBuilderOptions? options) : super(options);

  final String text = 'FROM';

  void setFrom(String table, String? alias) {
    super.setTable(table, alias);
  }

  void setFromSubQuery(QueryBuilder table, String? alias) {
    super.setTableFromQueryBuilder(table, alias);
  }

  @override
  void setFromRaw(String fromRawSqlString) {
    super.setFromRaw(fromRawSqlString);
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    assert(mTables.isNotEmpty);
    final String tables = super.buildStr(queryBuilder);
    return '$text $tables';
  }
}
