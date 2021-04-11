import 'block.dart';
import 'dart:collection';
import 'query_builder_options.dart';
import 'query_builder.dart';
import 'validator.dart';
import 'util.dart';

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
  String? fieldRawSql;

  /// Add the given fields to the result.
  /// @param fields A collection of fields to add
  void setFields(Iterable<String> fields) {
    for (final String field in fields) {
      setField(field, null);
    }
  }

  void setFieldsFromFieldNodeList(Iterable<FieldNode> fields) {
    for (final FieldNode field in fields) {
      setField(field.name, field.alias);
    }
  }

  void setFieldRaw(String setFieldRawSql) {
    fieldRawSql = setFieldRawSql;
  }

  /// Add the given field to the final result.
  /// @param field Field to add
  /// @param alias Field's alias
  void setField(String field, String? alias) {
    String fieldValue = Validator.sanitizeField(field.trim(), options);

    final String? aliasValue =
        alias != null ? Validator.sanitizeFieldAlias(alias, options) : null;

    /// quote table and field string with dot, example:
    /// db.select().fields(['tablename.fieldname']).from('tablename') result in
    ///  SELECT "tablename"."fieldname" FROM tablename
    if (options.quoteStringWithFieldsTablesSeparator) {
      if (fieldValue.contains(options.fieldsTablesSeparator)) {
        fieldValue = fieldValue
            .split(options.fieldsTablesSeparator)
            .map((String f) => f)
            .join(
                '${options.fieldAliasQuoteCharacter}${options.fieldsTablesSeparator}${options.fieldAliasQuoteCharacter}');
      }
    }

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
    if (fieldRawSql != null) {
      return fieldRawSql!;
    }

    if (fields.isEmpty) {
      return '*';
    }

    final StringBuffer sb = StringBuffer();
    for (final FieldNode field in fields) {
      if (sb.length > 0) {
        sb.write(', ');
      }

      sb.write(field.name);

      if (!Util.isEmpty(field.alias)) {
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
