import 'block.dart' show Block;


// RETURNING FIELD
class ReturningFieldBlock extends Block {
  ReturningFieldBlock() :
    this.fields = <String>[],
    super();

  final List<String> fields;

  void setRetuningField(String field) {
    fields.add(field);
  }
}