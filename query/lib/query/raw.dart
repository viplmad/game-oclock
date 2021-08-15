import 'block/block.dart' show Block, RawBlock;

import 'query.dart' show Query;


/// Raw query builder.
class Raw extends Query {
  Raw(String rawString) : super(
    <Block>[
      RawBlock(rawString),
    ],
  );
}
