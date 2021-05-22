import 'block.dart';
import 'query_builder.dart';
import 'query_builder_options.dart';
import 'string_block.dart';
import 'into_table_block.dart';
import 'insert_field_value_block.dart';
import 'insert_fields_from_query_block.dart';

/// An INSERT query builder.
class Insert extends QueryBuilder {
  Insert(
    QueryBuilderOptions? options, {
    List<String>? returningFields,
  }) : super(
          options,
          <Block>[
            StringBlock(options, 'INSERT', returningFields: returningFields),
            IntoTableBlock(options), // 1
            InsertFieldValueBlock(options), // 2
            InsertFieldsFromQueryBlock(options) // 3
          ],
        );

  @override
  QueryBuilder into(String table) {
    final IntoTableBlock block = blocks[1] as IntoTableBlock;
    block.setInto(table);
    return this;
  }

  @override
  QueryBuilder set(String field, dynamic value) {
    final InsertFieldValueBlock block = blocks[2] as InsertFieldValueBlock;
    block.setFieldValue(field, value);
    return this;
  }

  @override
  QueryBuilder setAll(Map<String, dynamic> fieldsAndValues) {
    final InsertFieldValueBlock block = blocks[2] as InsertFieldValueBlock;
    fieldsAndValues.forEach((String field, dynamic value) {
      block.setFieldValue(field, value);
    });
    return this;
  }

  @override
  QueryBuilder fromQuery(Iterable<String> fields, QueryBuilder query) {
    final InsertFieldsFromQueryBlock block = blocks[3] as InsertFieldsFromQueryBlock;
    block.setFromQuery(fields, query);
    return this;
  }
}
