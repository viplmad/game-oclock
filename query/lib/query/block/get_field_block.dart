import '../query.dart';

import 'block.dart';
import 'field_node.dart';


/// (SELECT) field
class GetFieldBlock extends Block {
  GetFieldBlock() :
    this.fields = <FieldNode>[],
    this.fieldAliases = <String?>[],
    super();

  final List<FieldNode> fields;
  final List<String?> fieldAliases;

  /// Add the given fields to the result.
  /// @param fields A collection of fields to add
  void setFields(Iterable<String> names, String? table) {
    for (final String name in names) {
      setField(name, null, table, null);
    }
  }

  /// Add the given field to the final result.
  /// @param field Field to add
  /// @param alias Field's alias
  void setField(String name, Type? type, String? table, String? alias, {FunctionType function = FunctionType.NONE}) {
    _chackAlias(alias);

    final FieldNode node = FieldStringNode(name, type, table, function, alias);
    fields.add(node);
  }

  void setFieldFromSubquery(Query query, String? alias, {FunctionType function = FunctionType.NONE}) {
    _chackAlias(alias);

    final FieldNode node = FieldSubqueryNode(query, function, alias);
    fields.add(node);
  }

  void _chackAlias(String? alias) {
    if (fieldAliases.contains(alias)) {
      return;
    }
    fieldAliases.add(alias);
  }
}
