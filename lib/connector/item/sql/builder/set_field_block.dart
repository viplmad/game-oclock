import 'query_builder_options.dart';
import 'query_builder.dart';
import 'set_field_block_base.dart';
import 'validator.dart';

/// (UPDATE) SET setField=value
class SetFieldBlock extends SetFieldBlockBase {
  SetFieldBlock(QueryBuilderOptions? options) : super(options);

  @override
  String buildStr(QueryBuilder queryBuilder) {
    assert(mFields.isNotEmpty);

    final StringBuffer sb = StringBuffer();
    for (final SetNode item in mFields) {
      if (sb.length > 0) {
        sb.write(', ');
      }

      final String field = Validator.sanitizeField(item.field, options);

      sb.write(field);
      sb.write(' = ');
      sb.write('@${item.field}');
    }

    return 'SET $sb';
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
}
