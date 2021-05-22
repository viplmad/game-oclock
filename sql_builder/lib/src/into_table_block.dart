import 'query_builder.dart';
import 'block.dart';
import 'query_builder_options.dart';
import 'validator.dart';

/// INTO table
class IntoTableBlock extends Block {
  IntoTableBlock(QueryBuilderOptions? options) : super(options);

  final String text = 'INTO';
  String? table;

  void setInto(String table) {
    final String tbl = Validator.sanitizeTable(table, options);
    this.table = tbl;
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    assert(table != null && table!.isNotEmpty);
    return '$text $table';
  }
}
