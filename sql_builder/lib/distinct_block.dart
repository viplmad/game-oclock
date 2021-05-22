import 'block.dart';
import 'query_builder_options.dart';
import 'query_builder.dart';

class DistinctBlock extends Block {
  DistinctBlock(QueryBuilderOptions? options) : super(options);

  final String text = 'DISTINCT';
  bool isDistinct = false;

  void setDistinct() {
    isDistinct = true;
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    return isDistinct ? text : '';
  }
}
