import 'block.dart' show Block;
import 'set_node.dart';


/// Base class for setting fields to values (used for INSERT and UPDATE queries)
abstract class SetFieldBlockBase extends Block {
  SetFieldBlockBase() :
    this.sets = <SetNode>[];

  final List<SetNode> sets;

  /// Update the given field with the given value.
  /// @param field Field to set value for.
  /// @param value Value to set.
  void setFieldValue(String field, Object? value) {
    final SetNode node = SetNode(field, value);
    sets.add(node);
  }
}
