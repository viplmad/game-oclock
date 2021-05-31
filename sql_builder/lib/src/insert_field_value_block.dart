import 'query_builder_options.dart';
import 'query_builder.dart';
import 'validator.dart';

import 'set_field_block_base.dart';
import 'util.dart';

/// (INSERT INTO) ... setField ... value
class InsertFieldValueBlock extends SetFieldBlockBase {
  InsertFieldValueBlock(QueryBuilderOptions? options) : super(options);

  @override
  String buildStr(QueryBuilder queryBuilder) {
    if (fields.isEmpty) {
      return '';
    }

    final String fieldsJoined = Util.join(', ', buildFieldNames(fields));

    final String valuesJoined = Util.join(', ', buildFieldValuesForSubstitution(fields));

    final String sql = '($fieldsJoined) VALUES ($valuesJoined)';

    return sql;
  }

  @override
  Map<String, dynamic> buildSubstitutionValues() {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (fields.isEmpty) {
      return result;
    }

    for(int index = 0; index < fields.length; index++) {
      final SetNode item = fields.elementAt(index);

      result.addAll(<String, dynamic>{'insertParam${index}': item.value});
    }

    return result;
  }

  List<String> buildFieldValuesForSubstitution(List<SetNode> nodes) {
    final List<String> values = <String>[];
    for(int index = 0; index < nodes.length; index++) {
      values.add('@insertParam${index}');
    }
    return values;
  }

  List<String> buildFieldNames(List<SetNode> nodes) {
    final List<String> names = <String>[];
    for (final SetNode item in nodes) {
      final String field = Validator.sanitizeField(item.field, options);

      names.add(field);
    }

    return names;
  }

  List<String> buildFieldValues(List<SetNode> nodes) {
    final List<String> values = <String>[];
    for (final SetNode n in nodes) {
      values.add(Validator.formatValue(n.value, options));
    }
    return values;
  }
}
