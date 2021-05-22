import 'block.dart';
import 'query_builder_options.dart';

class SetNode {
  SetNode(this.field, this.value);
  final String field;
  final Object? value;
}

/// Base class for setting fields to values (used for INSERT and UPDATE queries)
abstract class SetFieldBlockBase extends Block {
  SetFieldBlockBase(QueryBuilderOptions? options) :
        this.fields = <SetNode>[],
        super(options);
  final List<SetNode> fields;

  /// Update the given field with the given value.
  /// @param field Field to set value for.
  /// @param value Value to set.
  /// @param <T> Type of the Value.
  void setFieldValue(String field, dynamic value) {
    fields.add(SetNode(field, value));
  }
}
