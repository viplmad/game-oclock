import 'block/block.dart' show Block, DistinctBlock, FromTableBlock, GetFieldBlock, GroupBlock, JoinBlock, LimitBlock, OffsetBlock, OrderBlock, SelectBlock, UnionBlock, WhereBlock;

import 'query.dart' show Query;


/// SELECT query builder.
class Select extends Query {
  Select() : super(
    <Block>[
      SelectBlock(),
      DistinctBlock(), // 1
      GetFieldBlock(), // 2
      FromTableBlock(), // 3
      JoinBlock(), // 4
      WhereBlock(), // 5
      GroupBlock(), // 6
      OrderBlock(), // 7
      LimitBlock(), // 8
      OffsetBlock(), // 9
      UnionBlock(), // 10
    ],
  );

  @override
  DistinctBlock distinctBlock() {
    return blocks[1] as DistinctBlock;
  }

  @override
  GetFieldBlock getFieldBlock() {
    return blocks[2] as GetFieldBlock;
  }

  @override
  FromTableBlock fromTableBlock() {
    return blocks[3] as FromTableBlock;
  }

  @override
  JoinBlock joinBlock() {
    return blocks[4] as JoinBlock;
  }

  @override
  WhereBlock whereBlock() {
    return blocks[5] as WhereBlock;
  }

  @override
  GroupBlock groupBlock() {
    return blocks[6] as GroupBlock;
  }

  @override
  OrderBlock orderBlock() {
    return blocks[7] as OrderBlock;
  }

  @override
  LimitBlock limitBlock() {
    return blocks[8] as LimitBlock;
  }

  @override
  OffsetBlock offsetBlock() {
    return blocks[9] as OffsetBlock;
  }

  @override
  UnionBlock unionBlock() {
    return blocks[10] as UnionBlock;
  }
}
