import 'block/block.dart' show Block, DeleteBlock, FromTableBlock, JoinBlock, ReturningFieldBlock, WhereBlock;

import 'query.dart' show Query;


/// DELETE query builder.
class Delete extends Query {
  Delete() : super(
    <Block>[
      DeleteBlock(),
      FromTableBlock(), // 1
      JoinBlock(), // 2
      WhereBlock(), // 3
      ReturningFieldBlock(), // 4
    ],
  );

  @override
  FromTableBlock fromTableBlock() {
    return blocks[1] as FromTableBlock;
  }

  @override
  JoinBlock joinBlock() {
    return blocks[2] as JoinBlock;
  }

  @override
  WhereBlock whereBlock() {
    return blocks[3] as WhereBlock;
  }

  @override
  ReturningFieldBlock returningFieldBlock() {
    return blocks[4] as ReturningFieldBlock;
  }
}
