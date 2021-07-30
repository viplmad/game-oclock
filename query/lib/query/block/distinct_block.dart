import 'block.dart' show Block;


class DistinctBlock extends Block {
  DistinctBlock() : super();

  bool isDistinct = false;

  void setDistinct() {
    isDistinct = true;
  }
}
