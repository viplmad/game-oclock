import 'block.dart';
import 'query_builder_options.dart';
import 'query_builder.dart';

/// LIMIT
class LimitBlock extends Block {
  LimitBlock(QueryBuilderOptions? options) :
        limit = -1,
        super(options);
  final String text = 'LIMIT';
  int limit;

  void setLimit(int value) {
    assert(value >= 0);
    limit = value;
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    return limit >= 0 ? '$text $limit' : '';
  }
}
