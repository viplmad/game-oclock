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

    for (int i = 0; i < length; i++) {
      final WhereNode where = wheres[i];

      if (where.groupDivider == null) {
        if (where.operator == null) {
          sb.write(where.text.replaceAll('?', Validator.formatValue(where.param, options)));
        } else {
          sb.write('${where.text}');
          sb.write(' ${where.operator} ');

          final String substitutionValue = _getSubstitutionValue(where.text);
          sb.write('@$substitutionValue');
        }

        if (i < length - 1) {
          sb.write(' ${where.andOr} ');
        }
      } else {
        if (where.groupDivider == ')') {
          String str = sb.toString();
          final int lastIndexOf = str.contains('OR') ? str.lastIndexOf('OR') : str.lastIndexOf('or');
          str = str.substring(0, lastIndexOf);
          sb.clear();
          String andOr = where.andOr;
          if (i == length - 1) {
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

  String _getSubstitutionValue(String text) {
    String substitutionValue = text;
    if (text.contains('.') == true) {
      final List<String> parts = text.split('.');
      substitutionValue = parts[1];
    }
    if (text.startsWith('"') == true && text.endsWith('"') == true) {
      substitutionValue = substitutionValue.substring(1, substitutionValue.length - 1);
    }
    return substitutionValue;
  }

  @override
  Map<String, dynamic> buildSubstitutionValues() {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (wheres.isEmpty) {
      return result;
    }

    for (final WhereNode item in wheres) {
      if (item.operator != null) {
        final String v = Validator.formatValue(item.param, options);

        final String substitutionValue = _getSubstitutionValue(item.text);

        result.addAll(<String, dynamic>{'$substitutionValue': v});
      }
    }

    return result;
  }

  void doSetWhere(String condition, dynamic param, [String andOr = 'AND']) {
    wheres.add(WhereNode(condition, param, andOr: andOr));
  }
}
