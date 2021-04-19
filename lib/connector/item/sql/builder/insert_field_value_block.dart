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
    if (mFields.isEmpty) {
      return '';
    }

    final String fields = Util.join(', ', buildFieldNames(mFields));

    final String values = Util.join(', ', buildFieldValuesForSubstitution(mFields));

    final String sql = '($fields) VALUES ($values)';

    return sql;
  }

  @override
  Map<String, dynamic> buildSubstitutionValues() {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (mFields.isEmpty) {
      return result;
    }

    for (final SetNode item in mFields) {
      final String v = Validator.formatValue(item.value, options);
      result.addAll(<String, dynamic>{'${item.field}': v});
    }

    return result;
  }

  List<String> buildFieldValuesForSubstitution(List<SetNode> nodes) {
    final List<String> values = <String>[];
    for (final SetNode item in nodes) {
      values.add('@${item.field}');
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