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
    final List<String> results = <String>[];
    for (final Block block in query.blocks) {
      results.add(_buildBlockString(block, options));
    }

    return Util.joinNonEmpty(options.separator, results);
  }

  static Map<String, Object?> buildSubstitutionValues(Query query, SQLBuilderOptions options) {
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

    final StringBuffer sb = StringBuffer();

    for (final TableNode node in block.tables) {
      if (sb.length > 0) {
        sb.write(', ');
      }

      if(node is TableStringNode) {
        final String table = Validator.sanitizeTable(node. table, options);
        sb.write(table);
      } else if(node is TableSubqueryNode) {
        sb.write('(');
        sb.write(buildString(node.query, options));
        sb.write(')');
      }

      final String alias = Validator.sanitizeTableAlias(node.alias, options);
      if (alias.isNotEmpty) {
        sb.write(' ');
        sb.write(alias);
      }
    }

    return sb.toString();
  }

  static String _buildGetFieldString(GetFieldBlock block, SQLBuilderOptions options) {
    if (block.fields.isEmpty) {
      return '*';
    }

    final StringBuffer sb = StringBuffer();

    for (final FieldNode node in block.fields) {
      if (sb.length > 0) {
        sb.write(', ');
      }

      if(node is FieldStringNode) {
        final String field = Validator.sanitizeTableDotField(node.table, node.name, options);

        if(node.type is double) {
          sb.write(field + '::float');
        } else if(node.type is Duration) {
          sb.write('(Extract(hours from ' + field + ') * 60 + EXTRACT(minutes from ' + field + '))::int');
        } else {
          sb.write(field);
        }
      } else if(node is FieldSubqueryNode) {
        sb.write('(');
        sb.write(buildString(node.query, options));
        sb.write(')');
      }

      final String alias = Validator.sanitizeFieldAlias(node.alias, options);
      if (alias.isNotEmpty) {
        sb.write(' AS ');
        sb.write(alias);
      }
    }

    return sb.toString();
  }

  static String _buildGroupString(GroupBlock block, SQLBuilderOptions options) {
    final StringBuffer sb = StringBuffer();

    if (block.groups.isEmpty) {
      return '';
    }

    for (final GroupNode node in block.groups) {
      if (sb.length > 0) {
        sb.write(', ');
      }

      if (node is GroupStringNode) {
        final String field = Validator.sanitizeTableDotField(node.table, node.field, options);
        sb.write(field);
      } else if (node is GroupSubqueryNode) {
        sb.write('(');
        sb.write(buildString(node.query, options));
        sb.write(')');
      }
    }

    return 'GROUP BY $sb';
  }

  static String _buildInsertFieldValueString(InsertFieldValueBlock block, SQLBuilderOptions options) {
    if (block.sets.isEmpty) {
      return '';
    }

    final List<String> names = <String>[];
    for (final SetNode item in block.sets) {
      final String field = Validator.sanitizeField(item.field, options);

      names.add(field);
    }
    final String fieldsJoined = Util.join(', ', names);

    final List<String> values = <String>[];
    for(int index = 0; index < block.sets.length; index++) {
      values.add('@${_INSERT_PARAM}${index}');
    }
    final String valuesJoined = Util.join(', ', values);

    return '($fieldsJoined) VALUES ($valuesJoined)';
  }

  static String _buildInsertFieldsFromQueryString(InsertFieldsFromQueryBlock block, SQLBuilderOptions options) {
    if (block.fields.isEmpty || block.query == null) {
        return '';
      }
      return "(${Util.join(', ', block.fields)}) (${buildString(block.query!, options)})";
  }

  static String _buildIntoTableString(IntoTableBlock block, SQLBuilderOptions options) {
    assert(block.table != null && block.table!.isNotEmpty);

    return 'INTO ${block.table}';
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

    final StringBuffer sb = StringBuffer();

    for (final OrderNode node in block.orders) {
      if (sb.length > 0) {
        sb.write(', ');
      }

      if(node is OrderFieldNode) {
        final FieldStringNode fieldNode = node.field as FieldStringNode;
        final String field = Validator.sanitizeTableDotField(fieldNode.table, fieldNode.name, options);

        sb.write(field);
      } else if(node is OrderSubqueryNode) {
        sb.write('(');
        sb.write(buildString(node.query, options));
        sb.write(')');
      }
      sb.write(' ');
      sb.write(node.direction == SortOrder.ASC ? 'ASC' : 'DESC');
      sb.write(node.nullsLast ? ' NULLS LAST' : '');
    }

    return 'ORDER BY $sb';
  }

  static String _buildSetFieldString(SetFieldBlock block, SQLBuilderOptions options) {
    assert(block.sets.isNotEmpty);

    final StringBuffer sb = StringBuffer();

    for(int index = 0; index < block.sets.length; index++) {
      final SetNode node = block.sets.elementAt(index);

      if (sb.length > 0) {
        sb.write(', ');
      }

      final String field = Validator.sanitizeField(node.field, options);

      sb.write(field);
      sb.write(' = ');
      sb.write('@${_SET_PARAM}${index}');
    }

    return 'SET $sb';
  }

  static String _buildJoinString(JoinBlock block, SQLBuilderOptions options) {
    if (block.joins.isEmpty) {
      return '';
    }

    final StringBuffer sb = StringBuffer();

    for (final JoinNode node in block.joins) {
      if (sb.length > 0) {
        sb.write(' ');
      }

      sb.write(_joinTypeToString(node.type));
      sb.write(' JOIN ');

      if(node is JoinTableNode) {
        final TableStringNode tableNode = node.table as TableStringNode;
        final String table = Validator.sanitizeTable(tableNode.table, options);
        sb.write(table);

        final String alias = Validator.sanitizeTableAlias(tableNode.alias, options);
        if (alias.isNotEmpty) {
          sb.write(' ');
          sb.write(alias);
        }
      } else if(node is JoinSubqueryNode) {
        sb.write('(');
        sb.write(buildString(node.query, options));
        sb.write(')');
      }

      final String operatorString = _operatorTypeToString(node.condition.operator);

      final FieldStringNode fieldNode = node.condition.field;
      final String field = Validator.sanitizeTableDotField(fieldNode.table, fieldNode.name, options);

      final FieldStringNode joinFieldNode = node.condition.joinField;
      final String joinField = Validator.sanitizeTableDotField(joinFieldNode.table, joinFieldNode.name, options);

      sb.write(' ON (');
      sb.write('$field $operatorString $joinField');
      sb.write(')');
    }

    return sb.toString();
  }

  static String _buildUnionString(UnionBlock block, SQLBuilderOptions options) {
    if (block.unions.isEmpty) {
      return '';
    }

    final StringBuffer sb = StringBuffer();

    for (final UnionNode node in block.unions) {
      if (sb.length > 0) {
        sb.write(' ');
      }

      sb.write(_unionTypeToString(node.type));
      sb.write(' ');

      if(node is UnionTableNode) {
        final String table = Validator.sanitizeTable(node.table, options);
        sb.write(table);
      } else if(node is UnionSubqueryNode) {
        sb.write('(');
        sb.write(buildString(node.query, options));
        sb.write(')');
      }
    }

    return sb.toString();
  }

  static String _buildWhereString(WhereBlock block, SQLBuilderOptions options) {
    if (block.wheres.isEmpty) {
      return '';
    }

    final StringBuffer sb = StringBuffer();

    final int length = block.wheres.length;

    for (int index = 0; index < length; index++) {
      final WhereNode node = block.wheres.elementAt(index);

      final String combiner = index == 0? 'WHERE' : _combinerTypeToString(node.combiner);
      final String operator = _operatorTypeToString(node.operator);

      if(node.divider == DividerType.NONE) {
        sb.write('$combiner ');
      } else if(node.divider == DividerType.START) {
        sb.write(' $combiner ( ');
      }

      if(node is WhereFieldNode) {
        final FieldStringNode fieldNode = node.field;
        String field = Validator.sanitizeTableDotField(fieldNode.table, fieldNode.name, options);

        if(node is WhereFieldDatePartNode) {
          field = _datePartToString(node.datePart, field);
        }

        sb.write(field);
      } else if(node is WhereSubqueryNode) {
        sb.write(buildString(node.query, options));
      }
      sb.write(' $operator ');
      sb.write('@${_WHERE_PARAM}${index}');

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

  static String _operatorTypeToString(OperatorType type) {
    switch(type) {
      case OperatorType.EQ:
        return '=';
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

  // Build Substitution Values
  static Map<String, Object?> _buildBlockSubstitutionValues(Block block, SQLBuilderOptions options) {
    if(block is InsertFieldValueBlock) {
      return _buildInsertFieldSubstitutionValues(block, options);
    } else if(block is SetFieldBlock) {
      return _buildSetFieldSubstitutionValues(block, options);
    } else if(block is WhereBlock) {
      return _buildWhereSubstitutionValues(block, options);
    }

    return <String, Object?>{};
  }
  static Map<String, Object?> _buildInsertFieldSubstitutionValues(InsertFieldValueBlock block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.sets.isEmpty) {
      return result;
    }

    for(int index = 0; index < block.sets.length; index++) {
      final SetNode item = block.sets.elementAt(index);
      final Object? value = Validator.formatValue(item.value, options);

      result.addAll(<String, Object?>{'${_INSERT_PARAM}${index}': value});
    }

    return result;
  }

  static Map<String, Object?> _buildSetFieldSubstitutionValues(SetFieldBlock block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.sets.isEmpty) {
      return result;
    }

    for(int index = 0; index < block.sets.length; index++) {
      final SetNode item = block.sets.elementAt(index);
      final Object? value = Validator.formatValue(item.value, options);

      result.addAll(<String, Object?>{'${_SET_PARAM}${index}': value});
    }

    return result;
  }

  static Map<String, Object?> _buildWhereSubstitutionValues(WhereBlock block, SQLBuilderOptions options) {
    final Map<String, Object?> result = <String, Object?>{};
    if (block.wheres.isEmpty) {
      return result;
    }

    for(int index = 0; index < block.wheres.length; index++) {
      final WhereNode item = block.wheres.elementAt(index);
      Object? value = Validator.formatValue(item.value, options);

      if(item.operator == OperatorType.LIKE) {
        value = '%$value%';
      }

      result.addAll(<String, Object?>{'${_WHERE_PARAM}${index}': value});
    }

    return result;
  }
}

