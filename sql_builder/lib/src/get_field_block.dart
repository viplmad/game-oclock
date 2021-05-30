import 'block.dart';
import 'dart:collection';
import 'query_builder_options.dart';
import 'query_builder.dart';
import 'validator.dart';

class FieldNode {
  FieldNode(this.name, this.alias);
  final String name;
  final String? alias;
}

/// (SELECT) field
class GetFieldBlock extends Block {
  GetFieldBlock(QueryBuilderOptions? options) :
        this.fields = <FieldNode>[],
        this.fieldAliases = HashMap<String, String?>(),
        super(options);
  final List<FieldNode> fields;
  final HashMap<String, String?> fieldAliases;

  /// Add the given fields to the result.
  /// @param fields A collection of fields to add
  void setFields(Iterable<String> fields, String? tableName) {
    for (final String field in fields) {
      setField(field, null, tableName);
    }
  }

  void setFieldsFromFieldNodeList(Iterable<FieldNode> fields, String? tableName) {
    for (final FieldNode field in fields) {
      setField(field.name, field.alias, tableName);
    }
  }

  void setFieldRaw(String setFieldRawSql) {
    doSetField(setFieldRawSql, null);
  }

  /// Add the given field to the final result.
  /// @param field Field to add
  /// @param alias Field's alias
  void setField(String field, String? alias, String? tableName) {
    String fieldValue = Validator.sanitizeTableDotField(tableName, field, options);

    final String? aliasValue =
        alias != null ? Validator.sanitizeFieldAlias(alias, options) : null;

    /// allow alias in fields, example:
    /// db.select().fields(['tablename.fieldname as f']).from('tablename') result in
    ///  SELECT "tablename"."fieldname" as "f" FROM tablename
    if (options.allowAliasInFields) {
      final RegExp reg = RegExp(r'\s+\b|\b\s');
      if (fieldValue.contains(reg)) {
        fieldValue = fieldValue.replaceAll(' as ', ' ');
        fieldValue = fieldValue.replaceAll(reg, '" as "');
      }
    }

    doSetField(fieldValue, aliasValue);
  }

  void setFieldFromSubQuery(QueryBuilder field, String? alias) {
    final String fieldName = Validator.sanitizeFieldFromQueryBuilder(field);
    final String? aliasValue =
        alias != null ? Validator.sanitizeFieldAlias(alias, options) : null;
    doSetField(fieldName, aliasValue);
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {

    if (fields.isEmpty) {
      return '*';
    }

    final StringBuffer sb = StringBuffer();
    for (final FieldNode field in fields) {
      if (sb.length > 0) {
        sb.write(', ');
      }

      sb.write(field.name);

      if (field.alias != null && field.alias!.isNotEmpty) {
        sb.write(' AS ');
        sb.write(field.alias);
      }
    }

    return sb.toString();
  }

  void doSetField(String field, String? alias) {
    if (fieldAliases.containsKey(field) && fieldAliases[field] == alias) {
      return;
    }

    fieldAliases[field] = alias;
    fields.add(FieldNode(field, alias));
  }
}
