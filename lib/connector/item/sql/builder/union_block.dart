import 'block.dart';
import 'query_builder_options.dart';
import 'query_builder.dart';
import 'validator.dart';
import 'union_type.dart';

class UnionNode {
  UnionNode(this.table, this.unionType);
  final Object table;
  final UnionType unionType;
}

/// UNION
class UnionBlock extends Block {
  UnionBlock(QueryBuilderOptions? options) :
        this.unions = <UnionNode>[],
        super(options);

  final List<UnionNode> unions;

  /// Add a UNION with the given table/query.
  /// @param table Name of the table or query to union with.
  /// @param unionType Type of the union.
  void setUnion(String table, UnionType unionType) {
    final String tbl = Validator.sanitizeTable(table, options);
    unions.add(UnionNode(tbl, unionType));
  }

  void setUnionSubQuery(QueryBuilder table, UnionType unionType) {
    unions.add(UnionNode(table, unionType));
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    if (unions.isEmpty) {
      return '';
    }

    final StringBuffer sb = StringBuffer();
    for (final UnionNode j in unions) {
      if (sb.length > 0) {
        sb.write(' ');
      }

      sb.write(unionTypeToSql(j.unionType));
      sb.write(' ');

      if (j.table is String) {
        sb.write(j.table);
      } else {
        sb.write('(');
        sb.write(j.table.toString());
        sb.write(')');
      }
    }

    return sb.toString();
  }
}
