import 'block.dart';
import 'query_builder_options.dart';
import 'query_builder.dart';

/// A String which always gets output
class StringBlock extends Block {
  StringBlock(QueryBuilderOptions? options, String str, {List<String>? returningFields}) :
        assert(str.isNotEmpty),
        super(options) {
    this.text = str;
    this.returningFields = returningFields ?? <String>[];
  }

  late String text;
  late List<String> returningFields;

  @override
  String buildStr(QueryBuilder queryBuilder) {
    return text;
  }

  @override
  List<String> buildReturningFields() {
    return returningFields;
  }
}
