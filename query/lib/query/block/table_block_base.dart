import '../query.dart' show Query;
import 'block.dart' show Block;
import 'table_node.dart';


/// Table base class
abstract class TableBlockBase extends Block {
  TableBlockBase() :
    this.tables = <TableNode>[];

  final List<TableNode> tables;

  void setTable(String table, String? alias) {
    final TableNode node = TableStringNode(table, alias);
    tables.add(node);
  }

  void setTableFromSubquery(Query query, String? alias) {
    final TableNode node = TableSubqueryNode(query, alias);
    tables.add(node);
  }
}
