import '../query.dart';
import 'block.dart';


/// (INSERT INTO) ... setField ... (SELECT ... FROM ...)
class InsertFieldsFromQueryBlock extends Block {
  InsertFieldsFromQueryBlock() :
    this.fields = <String>[],
    super();

  List<String> fields;
  Query? query;

  void setFromQuery(Iterable<String> fields, Query query) {
    this.fields = fields.toList(growable: false);
    this.query = query;
  }
}
