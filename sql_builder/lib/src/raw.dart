import 'block.dart';
import 'string_block.dart';
import 'query_builder.dart';
import 'query_builder_options.dart';

/// Raw query builder.
class Raw extends QueryBuilder {
  Raw(
    String rawQueryString, {
    QueryBuilderOptions? options,
  }) : super(
          options,
          <Block>[
            StringBlock(options, rawQueryString),
          ],
        );
}
