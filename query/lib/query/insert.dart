import 'block/block.dart'
    show
        Block,
        InsertBlock,
        InsertFieldValueBlock,
        InsertFieldsFromQueryBlock,
        IntoTableBlock,
        ReturningFieldBlock;

import 'query.dart' show Query;

/// An INSERT query builder.
class Insert extends Query {
  Insert()
      : super(
          <Block>[
            InsertBlock(),
            IntoTableBlock(), // 1
            InsertFieldValueBlock(), // 2
            InsertFieldsFromQueryBlock(), // 3
            ReturningFieldBlock(), // 4
          ],
        );

  @override
  IntoTableBlock intoTableBlock() {
    return blocks[1] as IntoTableBlock;
  }

  InsertFieldValueBlock _insertFieldValueBlock() {
    return blocks[2] as InsertFieldValueBlock;
  }

  @override
  InsertFieldsFromQueryBlock insertFieldsFromQueryBlock() {
    return blocks[3] as InsertFieldsFromQueryBlock;
  }

  @override
  ReturningFieldBlock returningFieldBlock() {
    return blocks[4] as ReturningFieldBlock;
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
}
