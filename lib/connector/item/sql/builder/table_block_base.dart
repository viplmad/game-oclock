import 'block.dart';
import 'query_builder_options.dart';
import 'query_builder.dart';
import 'validator.dart';

class TableNode {
  TableNode(this.table, this.alias, {this.fromRawSql});
  final Object table;
  final String? alias;
  String? fromRawSql;
}

/// Table base class
abstract class TableBlockBase extends Block {
  TableBlockBase(QueryBuilderOptions? options) :
        this.mTables = <TableNode>[],
        super(options);

  final List<TableNode> mTables; // TODO

  void setTable(String table, String? alias) {
    final String tbl = Validator.sanitizeTable(table, options);
    final String als = Validator.sanitizeTableAlias(alias, options);
    doSetTable(tbl, als);
  }

  void setTableFromQueryBuilder(QueryBuilder table, String? alias) {
    final String als = Validator.sanitizeTableAlias(alias, options);
    doSetTable(table, als);
  }

  void setFromRaw(String fromRawSqlString) {
    mTables.add(TableNode('', '', fromRawSql: fromRawSqlString));
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    assert(mTables.isNotEmpty);

    final StringBuffer sb = StringBuffer();
    for (final TableNode tab in mTables) {
      if (tab.fromRawSql == null) {
        if (sb.length > 0) {
          sb.write(', ');
        }

        if (tab.table is String) {
          sb.write(tab.table.toString());
        } else {
          sb.write('(');
          sb.write(tab.table.toString());
          sb.write(')');
        }

        if (tab.alias != null) {
          sb.write(' ');
          sb.write(tab.alias);
        }
      } else {
        sb.write(' ');
        sb.write(tab.fromRawSql);
      }
    }

    return sb.toString();
  }

  void doSetTable(Object table, String alias) {
    mTables.add(TableNode(table, alias));
  }
}
