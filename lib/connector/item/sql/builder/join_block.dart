import 'block.dart';
import 'query_builder_options.dart';
import 'query_builder.dart';
import 'join_type.dart';
import 'validator.dart';
import 'expression.dart';

class JoinNode {
  JoinNode(this.table, this.alias, this.condition, this.type);
  final JoinType type;
  final Object table;
  final String? alias;
  final Object? condition;
}

/// JOIN
class JoinBlock extends Block {
  JoinBlock(QueryBuilderOptions? options) :
        this.joins = <JoinNode>[],
        super(options);
  final String text = 'JOIN';
  final List<JoinNode> joins;

  /// Add a JOIN with the given table.
  /// @param table Name of the table to setJoin with.
  /// @param alias Optional alias for the table name.
  /// @param condition Optional condition (containing an SQL expression) for the JOIN.
  /// @param type Join Type.
  void setJoin(String table, String? alias, String condition, JoinType? type) {
    final String tbl = Validator.sanitizeTable(table, options);
    final String als = Validator.sanitizeTableAlias(alias, options);
    doJoin(tbl, als, condition, type);
  }

  void setJoinWithExpression(
      String table, String? alias, Expression condition, JoinType? type) {
    final String tbl = Validator.sanitizeTable(table, options);
    final String als = Validator.sanitizeTableAlias(alias, options);
    doJoin(tbl, als, condition, type);
  }

  void setJoinWithSubQuery(
      QueryBuilder table, String? alias, String condition, JoinType? type) {
    final String als = Validator.sanitizeTableAlias(alias, options);
    doJoin(table, als, condition, type);
  }

  void setJoinWithQueryWithExpr(
      QueryBuilder table, String? alias, Expression condition, JoinType? type) {
    final String als = Validator.sanitizeTableAlias(alias, options);
    doJoin(table, als, condition, type);
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    if (joins.isEmpty) {
      return '';
    }

    final StringBuffer sb = StringBuffer();
    for (final JoinNode j in joins) {
      if (sb.length > 0) {
        sb.write(' ');
      }

      sb.write(joinTypeToSql(j.type));
      sb.write(' $text ');

      if (j.table is String) {
        sb.write(j.table);
      } else {
        sb.write('(');
        sb.write(j.table.toString());
        sb.write(')');
      }

      if (j.alias != null && j.alias!.isNotEmpty) {
        sb.write(' ');
        sb.write(j.alias);
      }

      if (j.condition != null) {
        String conditionStr;
        if (j.condition is String) {
          conditionStr = j.condition.toString();
        } else {
          conditionStr = j.condition.toString();
        }

        if (conditionStr.isNotEmpty) {
          sb.write(' ON (');
          sb.write(conditionStr);
          sb.write(')');
        }
      }
    }

    return sb.toString();
  }

  void doJoin(Object table, String alias, Object condition, JoinType? type) {
    final JoinType t = type?? JoinType.INNER;
    joins.add(JoinNode(table, alias, condition, t));
  }
}
