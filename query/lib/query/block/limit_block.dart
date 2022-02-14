import 'block.dart' show Block;

/// LIMIT
class LimitBlock extends Block {
  LimitBlock() : super();

  int? limit;

  void setLimit(int value) {
    assert(value >= 0);
    limit = value;
  }
}
