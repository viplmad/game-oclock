import 'block.dart';


/// OFFSET x
class OffsetBlock extends Block {
  OffsetBlock() : super();

  int? offset;

  void setOffset(int value) {
    assert(value >= 0);
    offset = value;
  }
}
