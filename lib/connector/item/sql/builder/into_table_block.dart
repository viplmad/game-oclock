import 'query_builder.dart';
import 'block.dart';
import 'query_builder_options.dart';
import 'validator.dart';
import 'util.dart';

/// INTO table
class IntoTableBlock extends Block {
  IntoTableBlock(QueryBuilderOptions? options) : super(options);

  String? mTable;

  void setInto(String table) {
    final String tbl = Validator.sanitizeTable(table, options);
    mTable = tbl;
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    assert(!Util.isEmpty(mTable));
    return 'INTO $mTable';
  }
}
