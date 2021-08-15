import 'block/block.dart' show Block, ReturningFieldBlock, SetFieldBlock, UpdateBlock, UpdateTableBlock, WhereBlock;

import 'query.dart' show Query;


/// UPDATE query builder.
class Update extends Query {
  Update() : super(
    <Block>[
      UpdateBlock(),
      UpdateTableBlock(), // 1
      SetFieldBlock(), // 2
      WhereBlock(), // 3
      ReturningFieldBlock(), // 4
    ],
  );

  @override
  UpdateTableBlock updateTableBlock() {
    return blocks[1] as UpdateTableBlock;
  }

  SetFieldBlock _setFieldBlock() {
    return blocks[2] as SetFieldBlock;
  }

  @override
  WhereBlock whereBlock() {
    return blocks[3] as WhereBlock;
  }

  @override
  ReturningFieldBlock returningFieldBlock() {
    return blocks[4] as ReturningFieldBlock;
  }

  @override
  Query set(String field, dynamic value) {
    _setFieldBlock().setFieldValue(field, value);
    return this;
  }

  @override
  Query sets(Map<String, Object?> fieldsAndValues) {
    fieldsAndValues.forEach((String field, Object? value) {
      _setFieldBlock().setFieldValue(field, value);
    });
    return this;
  }
}
