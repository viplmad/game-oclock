import 'block/block.dart';

import 'query.dart';


/// An INSERT query builder.
class Insert extends Query {
  Insert() : super(
    <Block>[
      InsertBlock(),
      IntoTableBlock(), // 1
      InsertFieldValueBlock(), // 2
      InsertFieldsFromQueryBlock(), // 3
      ReturningFieldBlock(), // 4
    ],
  );

  IntoTableBlock _intoTableBlock() {
    return blocks[1] as IntoTableBlock;
  }

  InsertFieldValueBlock _insertFieldValueBlock() {
    return blocks[2] as InsertFieldValueBlock;
  }

  InsertFieldsFromQueryBlock _insertFieldsFromQueryBlock() {
    return blocks[3] as InsertFieldsFromQueryBlock;
  }

  ReturningFieldBlock _returningFieldBlock() {
    return blocks[4] as ReturningFieldBlock;
  }

  @override
  Query into(String table) {
    _intoTableBlock().setInto(table);
    return this;
  }

  @override
  Query set(String field, Object? value) {
    _insertFieldValueBlock().setFieldValue(field, value);
    return this;
  }

  @override
  Query sets(Map<String, Object?> fieldsAndValues) {
    fieldsAndValues.forEach((String field, Object? value) {
      _insertFieldValueBlock().setFieldValue(field, value);
    });
    return this;
  }

  @override
  Query fromQuery(Iterable<String> fields, Query query) {
    _insertFieldsFromQueryBlock().setFromQuery(fields, query);
    return this;
  }

  @override
  Query returningField(String field) {
    _returningFieldBlock().setRetuningField(field);
    return this;
  }
}
