import 'block.dart';


/// INTO table
class IntoTableBlock extends Block {
  IntoTableBlock() : super();

  String? table;

  void setInto(String table) {
    this.table = table;
  }
}
