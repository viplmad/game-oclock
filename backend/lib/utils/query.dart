class Query {

  Query() :
    ands = <FieldQuery>[],
    ors = <FieldQuery>[];

  final List<FieldQuery> ands;
  final List<FieldQuery> ors;

  void addAnd(String field, dynamic value, [QueryComparator comparator = QueryComparator.EQ]) {
    final FieldQuery fieldQuery = FieldCompareQuery(field, comparator, value);
    ands.add(fieldQuery);
  }

  void addOr(String field, dynamic value, [QueryComparator comparator = QueryComparator.EQ]) {
    final FieldQuery fieldQuery = FieldCompareQuery(field, comparator, value);
    ors.add(fieldQuery);
  }

  void addAndRaw(String rawQuery) {
    final FieldQuery fieldQuery = FieldRawQuery(rawQuery);
    ands.add(fieldQuery);
  }

  void addOrRaw(String rawQuery) {
    final FieldQuery fieldQuery = FieldRawQuery(rawQuery);
    ors.add(fieldQuery);
  }
}

abstract class FieldQuery {
  const FieldQuery();
}

class FieldCompareQuery extends FieldQuery {
  const FieldCompareQuery(this.field, this.comparator, this.value);

  final String field;
  final QueryComparator comparator;
  final dynamic value;
}

class FieldRawQuery extends FieldQuery {
  const FieldRawQuery(this.rawQuery);

  final String rawQuery;
}

enum QueryComparator {
  EQ,
  LIKE,
  GREATER_THAN,
  GREATER_THAN_EQUAL,
  LESS_THAN,
  LESS_THAN_EQUAL,
}