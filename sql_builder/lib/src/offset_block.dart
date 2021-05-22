import 'block.dart';
import 'query_builder.dart';
import 'query_builder_options.dart';

/// OFFSET x
class OffsetBlock extends Block {
  OffsetBlock(QueryBuilderOptions? options) :
        offset = -1,
        super(options);
  final String text = 'OFFSET';
  int offset;

  void setOffset(int value) {
    assert(value >= 0);
    offset = value;
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    return offset >= 0 ? '$text $offset' : '';
  }
}
