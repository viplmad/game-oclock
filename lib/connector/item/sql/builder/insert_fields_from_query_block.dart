import 'block.dart';
import 'query_builder_options.dart';
import 'query_builder.dart';
import 'validator.dart';

import 'util.dart';

/// (INSERT INTO) ... setField ... (SELECT ... FROM ...)
class InsertFieldsFromQueryBlock extends Block {
  InsertFieldsFromQueryBlock(QueryBuilderOptions? options) :
        this.fields = <String>[],
        super(options);
  List<String> fields;
  QueryBuilder? query;

  void setFromQuery(Iterable<String> fields, QueryBuilder query) {
    this.fields = <String>[];
    for (final String field in fields) {
      this.fields.add(Validator.sanitizeField(field, options));
    }

    this.query = query;
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    if (fields.isEmpty || query == null) {
      return '';
    }
    return "(${Util.join(', ', fields)}) (${query.toString()})";
  }
}
