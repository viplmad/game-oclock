import 'block.dart';

import 'query_builder_options.dart';
import 'query_builder.dart';
import 'validator.dart';
import 'util.dart';

/// GROUP BY
class GroupByBlock extends Block {
  GroupByBlock(QueryBuilderOptions? options) :
        this.groups = <String>[],
        super(options);
  final String text = 'GROUP BY';
  final List<String> groups;
  String? groupRawSql;

  void setGroups(Iterable<String> groups) {
    for (final String field in groups) {
      setGroup(field);
    }
  }

  void setGroup(String field) {
    String fieldValue = Validator.sanitizeField(field, options);
    if (options.quoteStringWithFieldsTablesSeparator) {
      if (fieldValue.contains(options.fieldsTablesSeparator)) {
        fieldValue = fieldValue
            .split(options.fieldsTablesSeparator)
            .map((String f) => f)
            .join(
                '${options.fieldAliasQuoteCharacter}${options.fieldsTablesSeparator}${options.fieldAliasQuoteCharacter}');
      }
    }

    groups.add(fieldValue);
  }

  void setGroupRaw(String groupRawSql) {
    this.groupRawSql = groupRawSql;
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    if (groupRawSql != null) {
      return '$text $groupRawSql';
    }
    if (groups.isEmpty) {
      return '';
    }
    return '$text ${Util.join(', ', groups)}';
  }
}
