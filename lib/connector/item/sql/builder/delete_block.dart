import 'block.dart';
import 'query_builder_options.dart';
import 'query_builder.dart';
import 'util.dart';

/// A Delete Block
class DeleteBlock extends Block {
  DeleteBlock(QueryBuilderOptions? options) : super(options);

  final String text = 'DELETE';

  @override
  String buildStr(QueryBuilder queryBuilder) {
    assert(!Util.isEmpty(text));
    return text;
  }
}
