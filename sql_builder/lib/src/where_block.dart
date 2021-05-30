import 'block.dart';
import 'query_builder_options.dart';
import 'query_builder.dart';
import 'validator.dart';
import 'expression.dart';
import 'where_node.dart';

/// WHERE
class WhereBlock extends Block {
  WhereBlock(QueryBuilderOptions? options) :
        this.wheres = <WhereNode>[],
        this.wheresRawSql = <WhereRawNode>[],
        super(options);
  final List<WhereNode> wheres;
  final List<WhereRawNode> wheresRawSql;

  void setStartGroup() {
    wheres.add(WhereNode('', '', groupDivider: '('));
  }

  void setEndGroup() {
    wheres.add(WhereNode('', '', groupDivider: ')'));
  }

  /// Add a WHERE condition.
  /// @param condition Condition to add
  /// @param param Parameter to add to condition.
  /// @param <P> Type of the parameter to add.
  void setWhere(String condition, dynamic param, [String andOr = 'AND']) {
    doSetWhere(condition, param, andOr);
  }

  void setWhereRaw(String whereRawSql, [String andOr = 'AND']) {
    wheresRawSql.add(WhereRawNode(whereRawSql, andOr));
  }

  void setWhereSafe(String field, String operator, dynamic value) {
    wheres.add(WhereNode(field, value, operator: operator, andOr: 'AND'));
  }

  void setOrWhereSafe(String field, String operator, dynamic value) {
    wheres.add(WhereNode(field, value, operator: operator, andOr: 'OR'));
  }

  void setWhereWithExpression(Expression? condition, dynamic param, [String andOr = 'AND']) {
    assert(condition != null);
    doSetWhere(condition.toString(), param, andOr);
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    final StringBuffer sb = StringBuffer();

    if (wheresRawSql.isNotEmpty) {
      for (final WhereRawNode whereRaw in wheresRawSql) {
        if (sb.length > 0) {
          sb.write(' ${whereRaw.andOr} ');
        }

        sb.write(whereRaw.sqlString);
      }
      return 'WHERE $sb';
    }

    if (wheres.isEmpty) {
      return '';
    }

    final int length = wheres.length;

    for (int index = 0; index < length; index++) {
      final WhereNode where = wheres.elementAt(index);

      if (where.groupDivider == null) {
        if (where.operator == null) {
          sb.write(where.text.replaceAll('?', Validator.formatValue(where.param, options)));
        } else {
          final String text = Validator.formatString(where.text, options);
          sb.write('$text');
          sb.write(' ${where.operator} ');

          sb.write('@param${index}');
        }

        if (index < length - 1) {
          sb.write(' ${where.andOr} ');
        }
      } else {
        if (where.groupDivider == ')') {
          String str = sb.toString();
          final int lastIndexOf = str.contains('OR') ? str.lastIndexOf('OR') : str.lastIndexOf('or');
          str = str.substring(0, lastIndexOf);
          sb.clear();
          String andOr = where.andOr;
          if (index == length - 1) {
            andOr = '';
          }
          sb.write(' $str ) $andOr ');
        } else {
          sb.write(' ${where.groupDivider} ');
        }
      }
    }

    return 'WHERE $sb';
  }

  @override
  Map<String, dynamic> buildSubstitutionValues() {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (wheres.isEmpty) {
      return result;
    }

    for(int index = 0; index < wheres.length; index++) {
      final WhereNode item = wheres.elementAt(index);
      if (item.operator != null) {
        result.addAll(<String, dynamic>{'param${index}': item.param});
      }
    }

    return result;
  }

  void doSetWhere(String condition, dynamic param, [String andOr = 'AND']) {
    wheres.add(WhereNode(condition, param, andOr: andOr));
  }
}
