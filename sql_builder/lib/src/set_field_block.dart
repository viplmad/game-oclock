import 'query_builder_options.dart';
import 'query_builder.dart';
import 'set_field_block_base.dart';
import 'validator.dart';

/// (UPDATE) SET setField=value
class SetFieldBlock extends SetFieldBlockBase {
  SetFieldBlock(QueryBuilderOptions? options) : super(options);

  @override
  String buildStr(QueryBuilder queryBuilder) {
    assert(fields.isNotEmpty);

    final StringBuffer sb = StringBuffer();
    for(int index = 0; index < fields.length; index++) {
      final SetNode item = fields.elementAt(index);

      if (sb.length > 0) {
        sb.write(', ');
      }

      final String field = Validator.sanitizeField(item.field, options);

      sb.write(field);
      sb.write(' = ');
      sb.write('@setParam${index}');
    }

    return 'SET $sb';
  }

  @override
  Map<String, dynamic> buildSubstitutionValues() {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (fields.isEmpty) {
      return result;
    }

    for(int index = 0; index < fields.length; index++) {
      final SetNode item = fields.elementAt(index);

      result.addAll(<String, dynamic>{'setParam${index}': item.value});
    }

    return result;
  }
}
