import '../query.dart' show Query;
import 'block.dart' show Block;


/// (INSERT INTO) ... setField ... (SELECT ... FROM ...)
class InsertFieldsFromQueryBlock extends Block {
  InsertFieldsFromQueryBlock() :
    fields = <String>[],
    super();

  List<String> fields;
  Query? query;

  void setFromQuery(Iterable<String> fields, Query query) {
    this.fields = fields.toList(growable: false);
    this.query = query;
  }
}
