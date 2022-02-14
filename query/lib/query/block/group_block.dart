import '../query.dart' show Query;
import 'block.dart' show Block;
import 'group_node.dart';

/// GROUP BY
class GroupBlock extends Block {
  GroupBlock()
      : groups = <GroupNode>[],
        super();

  final List<GroupNode> groups;

  void setGroups(Iterable<String> groups, String? table) {
    for (final String field in groups) {
      setGroup(field, table);
    }
  }

  void setGroup(String field, String? table) {
    final GroupNode node = GroupStringNode(field, table);
    groups.add(node);
  }

  void setGroupFromSubquery(Query query) {
    final GroupNode node = GroupSubqueryNode(query);
    groups.add(node);
  }
}
