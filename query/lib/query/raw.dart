import 'block/block.dart';
import 'query.dart';


/// Raw query builder.
class Raw extends Query {
  Raw(String rawString) : super(
    <Block>[
      RawBlock(rawString),
    ],
  );
}
