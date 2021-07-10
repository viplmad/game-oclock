import '../query.dart';
import 'table_block_base.dart';


/// FROM table
class FromTableBlock extends TableBlockBase {
  FromTableBlock() : super();

  void setFrom(String table, String? alias) {
    super.setTable(table, alias);
  }

  void setFromSubquery(Query table, String? alias) {
    super.setTableFromSubquery(table, alias);
  }
}
