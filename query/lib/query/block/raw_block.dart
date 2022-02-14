import 'block.dart' show Block;

/// A Raw Block
class RawBlock extends Block {
  RawBlock(this.rawString) : super();

  final String rawString;
}
