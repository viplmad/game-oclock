import 'package:query/query/block/block.dart';
import 'package:query/query.dart';

import '../util.dart';
import 'validator.dart';


class SQLQueryBuilder {
  SQLQueryBuilder._();

  static const String _INSERT_PARAM = 'insertParam';
  static const String _SET_PARAM = 'setParam';
  static const String _WHERE_PARAM = 'whereParam';

  static String buildString(Query query, SQLBuilderOptions options) {
    options.resetIndexes();

    return _buildString(query, options);
  }

  static String _buildString(Query query, SQLBuilderOptions options) {
    final List<String> results = <String>[];
    for (final Block block in query.blocks) {
      results.add(_buildBlockString(block, options));
    }

    return Util.joinNonEmpty(options.separator, results);
  }

  static Map<String, Object?> buildSubstitutionValues(Query query, SQLBuilderOptions options) {
    options.resetIndexes();

    return _buildSubstitutionValues(query, options);
  }

  static Map<String, Object?> _buildSubstitutionValues(Query query, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    for (final Block block in query.blocks) {
      result.addAll(_buildBlockSubstitutionValues(block, options));
    }

    return result;
  }

  // Build String
  static String _buildBlockString(Block block, SQLBuilderOptions options) {
    if(block is SelectBlock) {
      return 'SELECT';
    } else if(block is DeleteBlock) {
      return 'DELETE';
    } else if(block is UpdateBlock) {
      return 'UPDATE';
    } else if(block is InsertBlock) {
      return 'INSERT';
    } else if(block is DistinctBlock) {
      return _buildDistinctString(block, options);
    } else if(block is FromTableBlock) {
      return _buildFromTableString(block, options);
    } else if(block is GetFieldBlock) {
      return _buildGetFieldString(block, options);
    } else if(block is GroupBlock) {
      return _buildGroupString(block, options);
    } else if(block is InsertFieldValueBlock) {
      return _buildInsertFieldValueString(block, options);
    } else if(block is InsertFieldsFromQueryBlock) {
      return _buildInsertFieldsFromQueryString(block, options);
    } else if(block is IntoTableBlock) {
      return _buildIntoTableString(block, options);
    } else if(block is JoinBlock) {
      return _buildJoinString(block, options);
    } else if(block is LimitBlock) {
      return _buildLimitString(block, options);
    } else if(block is OffsetBlock) {
      return _buildOffsetString(block, options);
    } else if(block is OrderBlock) {
      return _buildOrderString(block, options);
    } else if(block is SetFieldBlock) {
      return _buildSetFieldString(block, options);
    } else if(block is UnionBlock) {
      return _buildUnionString(block, options);
    } else if(block is UpdateTableBlock) {
      return _buildUpdateTableString(block, options);
    } else if(block is WhereBlock) {
      return _buildWhereString(block, options);
    } else if(block is ReturningFieldBlock) {
      return _buildReturningFieldString(block, options);
    }

    return '';
  }

  static String _buildDistinctString(DistinctBlock block, SQLBuilderOptions options) {
    return block.isDistinct? 'DISTINCT' : '';
  }

  static String _buildFromTableString(FromTableBlock block, SQLBuilderOptions options) {
    return 'FROM ' + _tableToString(block, options);
  }

  static String _buildUpdateTableString(UpdateTableBlock block, SQLBuilderOptions options) {
    return _tableToString(block, options);
  }

  static String _tableToString(TableBlockBase block, SQLBuilderOptions options) {
    assert(block.tables.isNotEmpty);

    final List<String> tablesString = block.tables.map((TableNode node) {
      return _buildTableNodeString(node, options);
    }).toList(growable: false);

    return tablesString.join(', ');
  }

  static String _buildTableNodeString(TableNode node, SQLBuilderOptions options) {
    final StringBuffer sb = StringBuffer();

    if(node is TableStringNode) {
      final String table = Validator.sanitizeTable(node.table, options);
      sb.write(table);
    } else if(node is TableSubqueryNode) {
      sb.write('(');
      sb.write(_buildString(node.query, options));
      sb.write(')');
    }

    final String alias = Validator.sanitizeTableAlias(node.alias, options);
    if (alias.isNotEmpty) {
      sb.write(' ');
      sb.write(alias);
    }

    return sb.toString();
  }

  static String _buildGetFieldString(GetFieldBlock block, SQLBuilderOptions options) {
    if (block.fields.isEmpty) {
      return '*';
    }

    final List<String> fieldsString = block.fields.map((FieldNode node) {
      return _buildFieldNodeString(node, options);
    }).toList(growable: false);

    return fieldsString.join(', ');
  }

  static String _buildFieldNodeString(FieldNode node, SQLBuilderOptions options) {
    final StringBuffer sb = StringBuffer();

    if(node.function != FunctionType.NONE) {
      final String function = _functionTypeToString(node.function);
      sb.write('$function(');
    }

    if(node is FieldStringNode) {
      final String field = Validator.sanitizeTableDotField(node.table, node.name, options);

      if(node.type == double) {
        sb.write(field + '::float');
      } else if(node.type == Duration) {
        sb.write('(Extract(hours from ' + field + ') * 60 + EXTRACT(minutes from ' + field + '))::int');
      } else {
        sb.write(field);
      }
    } else if(node is FieldSubqueryNode) {
      sb.write('(');
      sb.write(_buildString(node.query, options));
      sb.write(')');
    }

    if(node.function != FunctionType.NONE) {
      sb.write(')');
    }

    final String alias = Validator.sanitizeFieldAlias(node.alias, options);
    if (alias.isNotEmpty) {
      sb.write(' AS ');
      sb.write(alias);
    }

    return sb.toString();
  }

  static String _buildGroupString(GroupBlock block, SQLBuilderOptions options) {
    if (block.groups.isEmpty) {
      return '';
    }

    final List<String> groupsString = block.groups.map((GroupNode node) {
      return _buildGroupNodeString(node, options);
    }).toList(growable: false);

    return 'GROUP BY ${groupsString.join(', ')}';
  }

  static String _buildGroupNodeString(GroupNode node, SQLBuilderOptions options) {
    final StringBuffer sb = StringBuffer();

    if (node is GroupStringNode) {
        final String field = Validator.sanitizeTableDotField(node.table, node.field, options);
        sb.write(field);
    } else if (node is GroupSubqueryNode) {
      sb.write('(');
      sb.write(_buildString(node.query, options));
      sb.write(')');
    }

    return sb.toString();
  }

  static String _buildInsertFieldValueString(InsertFieldValueBlock block, SQLBuilderOptions options) {
    if (block.sets.isEmpty) {
      return '';
    }

    final List<String> names = <String>[];
    final List<String> values = <String>[];

    for (final SetNode node in block.sets) {
      final String name = _buildSetNodeNameString(node, options);
      names.add(name);

      final String value = _buildInsertValueString(options);
      values.add(value);
    }

    return '(${names.join(', ')}) VALUES (${values.join(', ')})';
  }

  static String _buildSetNodeNameString(SetNode node, SQLBuilderOptions options) {
    return Validator.sanitizeField(node.field, options);
  }

  static String _buildInsertValueString(SQLBuilderOptions options) {
    options.incrementInsertParamIndex();
    return '@${_INSERT_PARAM}${options.insertParamIndex}';
  }

  static String _buildSetValueString(SQLBuilderOptions options) {
    options.incrementSetParamIndex();
    return '@${_SET_PARAM}${options.setParamIndex}';
  }

  static String _buildWhereValueString(SQLBuilderOptions options) {
    options.incrementWhereParamIndex();
    return '@${_WHERE_PARAM}${options.whereParamIndex}';
  }

  static String _buildInsertFieldsFromQueryString(InsertFieldsFromQueryBlock block, SQLBuilderOptions options) {
    if (block.fields.isEmpty || block.query == null) {
      return '';
    }

    return "(${block.fields.join(', ')}) (${_buildString(block.query!, options)})";
  }

  static String _buildIntoTableString(IntoTableBlock block, SQLBuilderOptions options) {
    assert(block.table != null && block.table!.isNotEmpty);

    final String table = Validator.sanitizeTable(block.table!, options);

    return 'INTO $table';
  }

  static String _buildLimitString(LimitBlock block, SQLBuilderOptions options) {
    return block.limit != null && block.limit! >= 0 ? 'LIMIT ${block.limit}' : '';
  }

  static String _buildOffsetString(OffsetBlock block, SQLBuilderOptions options) {
    return block.offset != null && block.offset! >= 0 ? 'OFFSET ${block.offset}' : '';
  }

  static String _buildOrderString(OrderBlock block, SQLBuilderOptions options) {
    if (block.orders.isEmpty) {
      return '';
    }

    final List<String> ordersString = block.orders.map((OrderNode node) {
      return _buildOrderNodeString(node, options);
    }).toList(growable: false);

    return 'ORDER BY ${ordersString.join(', ')}';
  }

  static String _buildOrderNodeString(OrderNode node, SQLBuilderOptions options) {
    final StringBuffer sb = StringBuffer();

    if(node is OrderFieldNode) {
      final String field = _buildFieldNodeString(node.field, options);

      sb.write(field);
    } else if(node is OrderSubqueryNode) {
      sb.write('(');
      sb.write(_buildString(node.query, options));
      sb.write(')');
    }
    sb.write(' ');
    sb.write(node.direction == SortOrder.ASC ? 'ASC' : 'DESC');
    sb.write(node.nullsLast ? ' NULLS LAST' : '');

    return sb.toString();
  }

  static String _buildSetFieldString(SetFieldBlock block, SQLBuilderOptions options) {
    assert(block.sets.isNotEmpty);

    final List<String> setsString = <String>[];

    for(final SetNode node in block.sets) {
      final String field = _buildSetNodeString(node, options);

      setsString.add(field);
    }

    return 'SET ${setsString.join(', ')}';
  }

  static String _buildSetNodeString(SetNode node, SQLBuilderOptions options) {
    final String name = _buildSetNodeNameString(node, options);
    final String value = _buildSetValueString(options);

    return '$name = $value';
  }

  static String _buildJoinString(JoinBlock block, SQLBuilderOptions options) {
    if (block.joins.isEmpty) {
      return '';
    }

    final List<String> joinsString = block.joins.map((JoinNode node) {
      return _buildJoinNodeString(node, options);
    }).toList(growable: false);

    return joinsString.join(' ');
  }

  static String _buildJoinNodeString(JoinNode node, SQLBuilderOptions options) {
    final StringBuffer sb = StringBuffer();

    sb.write(_joinTypeToString(node.type));
    sb.write(' JOIN ');

    if(node is JoinTableNode) {
      final String table = _buildTableNodeString(node.table, options);
      sb.write(table);
    } else if(node is JoinSubqueryNode) {
      sb.write('(');
      sb.write(_buildString(node.query, options));
      sb.write(')');
    }

    final String operator = _operatorTypeToString(node.condition.operator);

    final FieldStringNode fieldNode = node.condition.field;
    final String field = _buildFieldNodeString(fieldNode, options);

    final FieldStringNode joinFieldNode = node.condition.joinField;
    final String joinField = _buildFieldNodeString(joinFieldNode, options);

    sb.write(' ON (');
    sb.write('$field $operator $joinField');
    sb.write(')');

    return sb.toString();
  }

  static String _buildUnionString(UnionBlock block, SQLBuilderOptions options) {
    if (block.unions.isEmpty) {
      return '';
    }

    final List<String> unionsString = block.unions.map((UnionNode node) {
      return _buildUnionNodeString(node, options);
    }).toList(growable: false);

    return unionsString.join(' ');
  }

  static String _buildUnionNodeString(UnionNode node, SQLBuilderOptions options) {
    final StringBuffer sb = StringBuffer();

    sb.write(_unionTypeToString(node.type));
    sb.write(' ');

    if(node is UnionTableNode) {
      final String table = Validator.sanitizeTable(node.table, options);
      sb.write(table);
    } else if(node is UnionSubqueryNode) {
      sb.write('(');
      sb.write(_buildString(node.query, options));
      sb.write(')');
    }

    return sb.toString();
  }

  static String _buildWhereString(WhereBlock block, SQLBuilderOptions options) {
    if (block.wheres.isEmpty) {
      return '';
    }

    final StringBuffer sb = StringBuffer();

    for (final WhereNode node in block.wheres) {
      final String combiner = sb.length == 0? 'WHERE' : ' ' + _combinerTypeToString(node.combiner);

      if(node.divider == DividerType.START) {
        sb.write('$combiner ( ');
      } else {
        sb.write('$combiner ');
      }

      if(node is WhereValueNode) {
        final String operator = _operatorTypeToString(node.operator, isValueNull: node.value == null);

        if(node is WhereFieldValueNode) {
          String field = _buildFieldNodeString(node.field, options);

          if(node is WhereFieldDatePartNode) {
            field = _datePartToString(node.datePart, field);
          }

          sb.write(field);
        } else if(node is WhereSubqueryNode) {
          sb.write('(');
          sb.write(_buildString(node.query, options));
          sb.write(')');
        }
        sb.write(' $operator ');

        final String value = _buildWhereValueString(options);
        sb.write(value);
      } else if(node is WhereFieldsNode) {
          final String operator = _operatorTypeToString(node.operator);

          final String field = _buildFieldNodeString(node.field, options);
          final String otherField = _buildFieldNodeString(node.otherField, options);

          sb.write('$field $operator $otherField');
      }

      if(node.divider == DividerType.END) {
        sb.write(' ) ');
      }
    }

    return sb.toString();
  }

  static String _buildReturningFieldString(ReturningFieldBlock block, SQLBuilderOptions options) {
    if (block.fields.isEmpty) {
      return '';
    }

    final StringBuffer sb = StringBuffer();

    for (final String node in block.fields) {
      if (sb.length > 0) {
        sb.write(', ');
      }

      final String field = Validator.sanitizeField(node, options);

      sb.write(field);
    }

    return 'RETURNING $sb';
  }

  static String _joinTypeToString(JoinType type) {
    switch (type) {
      case JoinType.INNER:
        return 'INNER';
      case JoinType.LEFT:
        return 'LEFT';
      case JoinType.RIGHT:
        return 'RIGHT';
      case JoinType.FULL:
        return 'FULL';
      case JoinType.CROSS:
        return 'CROSS';
    }
  }

  static String _unionTypeToString(UnionType type) {
    switch (type) {
      case UnionType.UNION:
        return 'UNION';
      case UnionType.UNION_ALL:
        return 'UNION ALL';
    }
  }

  static String _operatorTypeToString(OperatorType type, {bool isValueNull = false}) {
    switch(type) {
      case OperatorType.EQ:
        return isValueNull? 'IS' : '=';
      case OperatorType.NOT_EQ:
        return isValueNull? 'IS NOT' : '!=';
      case OperatorType.LIKE:
        return 'ILIKE';
      case OperatorType.GREATER_THAN:
        return '>';
      case OperatorType.GREATER_THAN_EQUAL:
        return '>=';
      case OperatorType.LESS_THAN:
        return '<';
      case OperatorType.LESS_THAN_EQUAL:
        return '<=';
    }
  }

  static String _combinerTypeToString(CombinerType type) {
    switch(type){
      case CombinerType.AND:
        return 'AND';
      case CombinerType.OR:
        return 'OR';
    }
  }

  static String _datePartToString(DatePart datePart, String field) {
    switch(datePart) {
      case DatePart.DAY:
        return 'date_part(\'day\', $field)';
      case DatePart.MONTH:
        return 'date_part(\'month\', $field)';
      case DatePart.YEAR:
        return 'date_part(\'year\', $field)';
    }
  }

  static String _functionTypeToString(FunctionType type) {
    switch(type) {
      case FunctionType.NONE:
        return '';
      case FunctionType.COUNT:
        return 'COUNT';
      case FunctionType.SUM:
        return 'SUM';
      case FunctionType.MIN:
        return 'MIN';
      case FunctionType.MAX:
        return 'MAX';
      case FunctionType.AVERAGE:
        return 'AVG';
    }
  }

  // Build Substitution Values
  static Map<String, Object?> _buildBlockSubstitutionValues(Block block, SQLBuilderOptions options) {
    if(block is InsertFieldValueBlock) {
      return _buildInsertFieldSubstitutionValues(block, options);
    } else if(block is SetFieldBlock) {
      return _buildSetFieldSubstitutionValues(block, options);
    } else if(block is WhereBlock) {
      return _buildWhereSubstitutionValues(block, options);
    } else if(block is TableBlockBase) {
      return _buildTableSubstitutionValues(block, options);
    } else if(block is GetFieldBlock) {
      return _buildGetFieldSubstitutionValues(block, options);
    } else if(block is GroupBlock) {
      return _buildGroupSubstitutionValues(block, options);
    } else if(block is OrderBlock) {
      return _buildOrderSubstitutionValues(block, options);
    } else if(block is InsertFieldsFromQueryBlock) {
      return _buildInsertFieldsFromQuerySubstitutionValues(block, options);
    } else if(block is JoinBlock) {
      return _buildJoinSubstitutionValues(block, options);
    } else if(block is UnionBlock) {
      return _buildUnionSubstitutionValues(block, options);
    }

    return <String, Object?>{};
  }
  static Map<String, Object?> _buildInsertFieldSubstitutionValues(InsertFieldValueBlock block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.sets.isEmpty) {
      return result;
    }

    for(final SetNode node in block.sets) {
      final Object? value = Validator.formatValue(node.value, options);

      result.addAll(<String, Object?>{_buildInsertValueString(options): value});
    }

    return result;
  }

  static Map<String, Object?> _buildSetFieldSubstitutionValues(SetFieldBlock block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.sets.isEmpty) {
      return result;
    }

    for(final SetNode node in block.sets) {
      final Object? value = Validator.formatValue(node.value, options);

      result.addAll(<String, Object?>{_buildSetValueString(options): value});
    }

    return result;
  }

  static Map<String, Object?> _buildWhereSubstitutionValues(WhereBlock block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.wheres.isEmpty) {
      return result;
    }

    for(final WhereNode node in block.wheres) {
      if(node is WhereValueNode) {
        if(node is WhereSubqueryNode) {
          result.addAll(_buildSubstitutionValues(node.query, options));
        }

        Object? value = Validator.formatValue(node.value, options);

        if(node.operator == OperatorType.LIKE) {
          value = '%$value%';
        }

        result.addAll(<String, Object?>{_buildWhereValueString(options): value});
      }
    }

    return result;
  }

  static Map<String, Object?> _buildTableSubstitutionValues(TableBlockBase block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.tables.isEmpty) {
      return result;
    }

    for (final TableNode node in block.tables) {
      if(node is TableSubqueryNode) {
        result.addAll(_buildSubstitutionValues(node.query, options));
      }
    }

    return result;
  }

  static Map<String, Object?> _buildGetFieldSubstitutionValues(GetFieldBlock block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.fields.isEmpty) {
      return result;
    }

    for (final FieldNode node in block.fields) {
      if(node is FieldSubqueryNode) {
        result.addAll(_buildSubstitutionValues(node.query, options));
      }
    }

    return result;
  }

  static Map<String, Object?> _buildGroupSubstitutionValues(GroupBlock block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.groups.isEmpty) {
      return result;
    }

    for (final GroupNode node in block.groups) {
      if(node is GroupSubqueryNode) {
        result.addAll(_buildSubstitutionValues(node.query, options));
      }
    }

    return result;
  }

  static Map<String, Object?> _buildOrderSubstitutionValues(OrderBlock block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.orders.isEmpty) {
      return result;
    }

    for (final OrderNode node in block.orders) {
      if(node is OrderSubqueryNode) {
        result.addAll(_buildSubstitutionValues(node.query, options));
      }
    }

    return result;
  }

  static Map<String, Object?> _buildInsertFieldsFromQuerySubstitutionValues(InsertFieldsFromQueryBlock block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.query == null) {
      return result;
    }

    result.addAll(_buildSubstitutionValues(block.query!, options));

    return result;
  }

  static Map<String, Object?> _buildJoinSubstitutionValues(JoinBlock block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.joins.isEmpty) {
      return result;
    }

    for (final JoinNode node in block.joins) {
      if(node is JoinSubqueryNode) {
        result.addAll(_buildSubstitutionValues(node.query, options));
      }
    }

    return result;
  }

  static Map<String, Object?> _buildUnionSubstitutionValues(UnionBlock block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.unions.isEmpty) {
      return result;
    }

    for (final UnionNode node in block.unions) {
      if(node is UnionSubqueryNode) {
        result.addAll(_buildSubstitutionValues(node.query, options));
      }
    }

    return result;
  }
}