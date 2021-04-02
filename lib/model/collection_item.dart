import 'package:equatable/equatable.dart';

import 'package:game_collection/entity/entity.dart';


abstract class CollectionItem extends Equatable {
  const CollectionItem({
    required this.id,
  });

  final int id;

  String get uniqueId;
  bool get hasImage;
  ItemImage get image;
  String get queryableTerms;

  CollectionItemEntity toEntity();

  CollectionItem copyWith();

  @override
  List<Object> get props => [
    id,
  ];

  @override
  String toString() {

    return 'CollectionItem { '
        '$idField: $id'
        ' }';

  }
}

class ItemImage {
  const ItemImage(String? url, String? filename)
      : this.url = url?? '',
        this.filename = filename?? '';

  final String url;
  final String filename;
}

abstract class ItemData<T extends CollectionItem> {
  const ItemData(this.items);

  final List<T> items;
  int get length => items.length;

  List<int> yearlyItemCount(List<int> years, bool Function(T, int) yearComparator) {
    List<int> values = List<int>.filled(years.length, 0);
    int index = 0;

    for(int yearsIndex = 0; yearsIndex < years.length; yearsIndex++) {
      int year = years.elementAt(yearsIndex);

      int yearCount = items.where((T item) => yearComparator(item, year)).length;

      values[index++] = yearCount;
    }

    return values;
  }

  List<N> yearlyFieldSum<N extends num>(List<int> years, bool Function(T, int) yearComparator, N foldInitialValue, N Function(T) fieldExtractor, {N Function(N, int)? sumOperation}) {
    List<N> values = List<N>.filled(years.length, 0 as N);
    int index = 0;

    for(int yearsIndex = 0; yearsIndex < years.length; yearsIndex++) {
      int year = years.elementAt(yearsIndex);

      List<T> yearItems = items.where((T item) => yearComparator(item, year)).toList(growable: false);
      N yearSum = yearItems.fold<N>(foldInitialValue, (N previousValue, T item) => (previousValue + fieldExtractor(item)) as N);
      if(sumOperation != null) {
        yearSum = sumOperation(yearSum, yearItems.length);
      }

      values[index++] = yearSum;
    }

    return values;
  }

  YearData<int> monthlyItemCount(bool Function(T, int) monthComparator) {
    YearData<int> yearData = YearData<int>();

    for(int month = 1; month <= 12; month++) {

      int monthCount = items.where((T item) => monthComparator(item, month)).length;

      yearData.addData(monthCount);
    }

    return yearData;
  }

  YearData<N> monthlyFieldSum<N extends num>(bool Function(T, int) monthComparator, N foldInitialValue, N Function(T) fieldExtractor, {N Function(N, int)? sumOperation}) {
    YearData<N> yearData = YearData<N>();

    for(int month = 1; month <= 12; month++) {

      List<T> monthItems = items.where((T item) => monthComparator(item, month)).toList(growable: false);
      N monthSum = monthItems.fold<N>(foldInitialValue, (N previousValue, T item) => (previousValue + fieldExtractor(item)) as N);
      if(sumOperation != null) {
        monthSum = sumOperation(monthSum, monthItems.length);
      }

      yearData.addData(monthSum);
    }

    return yearData;
  }

  List<int> intervalCountEqual<N extends num>(List<N> intervals, N Function(T) fieldExtractor) {
    List<int> values = List<int>.filled(intervals.length, 0);
    int index = 0;

    for(int intervalIndex = 0; intervalIndex < intervals.length; intervalIndex++) {
      N element = intervals.elementAt(intervalIndex);

      int intervalCount = items.where((T item) => fieldExtractor(item) == element).length;

      values[index++] = intervalCount;
    }

    return values;
  }

  List<int> intervalCount<N extends num>(List<N> intervals, N Function(T) fieldExtractor) {
    List<int> values = List<int>.filled(intervals.length - 1, 0);
    int index = 0;

    for(int intervalIndex = 0; intervalIndex < intervals.length - 1; intervalIndex++) {
      N min = intervals.elementAt(intervalIndex);
      N max = intervals.elementAt(intervalIndex + 1);

      int intervalCount = items.where((T item) => min < fieldExtractor(item) && fieldExtractor(item) <= max).length;

      values[index++] = intervalCount;
    }

    return values;
  }

  List<int> intervalCountWithInitial<N extends num>(List<N> intervals, N Function(T) fieldExtractor) {
    List<int> values = List<int>.filled(intervals.length, 0);
    int index = 0;

    N initialElement = intervals.first;
    int initialIntervalCount = items.where((T item) => fieldExtractor(item) <= initialElement).length;
    values[index++] = initialIntervalCount;

    for(int intervalIndex = 0; intervalIndex < intervals.length - 1; intervalIndex++) {
      N min = intervals.elementAt(intervalIndex);
      N max = intervals.elementAt(intervalIndex + 1);

      int intervalCount = items.where((T item) => min < fieldExtractor(item) && fieldExtractor(item) <= max).length;

      values[index++] = intervalCount;
    }

    return values;
  }

  List<int> intervalCountWithLast<N extends num>(List<N> intervals, N Function(T) fieldExtractor) {
    List<int> values = List<int>.filled(intervals.length, 0);
    int index = 0;

    for(int intervalIndex = 0; intervalIndex < intervals.length - 1; intervalIndex++) {
      N min = intervals.elementAt(intervalIndex);
      N max = intervals.elementAt(intervalIndex + 1);

      int intervalCount = items.where((T item) => min < fieldExtractor(item) && fieldExtractor(item) <= max).length;

      values[index++] = intervalCount;
    }

    N lastElement = intervals.last;
    int lastIntervalCount = items.where((T item) => lastElement < fieldExtractor(item)).length;
    values[index] = lastIntervalCount;

    return values;
  }

  List<int> intervalCountWithInitialAndLast<N extends num>(List<N> intervals, N Function(T) fieldExtractor) {
    List<int> values = List<int>.filled(intervals.length + 1, 0);
    int index = 0;

    N initialElement = intervals.first;
    int initialIntervalCount = items.where((T item) => fieldExtractor(item) <= initialElement).length;
    values[index++] = initialIntervalCount;

    for(int intervalIndex = 0; intervalIndex < intervals.length - 1; intervalIndex++) {
      N min = intervals.elementAt(intervalIndex);
      N max = intervals.elementAt(intervalIndex + 1);

      int intervalCount = items.where((T item) => min < fieldExtractor(item) && fieldExtractor(item) <= max).length;

      values[index++] = intervalCount;
    }

    N lastElement = intervals.last;
    int lastIntervalCount = items.where((T item) => lastElement < fieldExtractor(item)).length;
    values[index] = lastIntervalCount;

    return values;
  }
}

class YearData<N extends num> {
  YearData() {
    values = List<N>.filled(12, 0 as N);
    _month = 0;
  }

  late List<N> values;
  late int _month;

  void addData(N data) {
    if(_month < 12) {
      values[_month++] = data;
    }
  }
}