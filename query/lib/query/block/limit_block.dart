import 'block.dart';


/// LIMIT
class LimitBlock extends Block {
  LimitBlock() : super();

  int? limit;

  void setLimit(int value) {
    assert(value >= 0);
    limit = value;
  }
}