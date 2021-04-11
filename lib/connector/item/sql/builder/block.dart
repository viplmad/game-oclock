import 'query_builder.dart';
import 'query_builder_options.dart';

abstract class Block {
  Block(QueryBuilderOptions? options) {
    this.options = options ?? QueryBuilderOptions();
  }

  late QueryBuilderOptions options;
  String buildStr(QueryBuilder queryBuilder);

  Map<String, dynamic> buildSubstitutionValues() {
    return <String, dynamic>{};
  }

  List<String>? buildReturningFields() {
    return <String>[];
  }
}
