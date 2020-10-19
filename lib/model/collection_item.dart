import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:game_collection/entity/entity.dart';


abstract class CollectionItem extends Equatable {
  const CollectionItem({
    @required this.id,
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
        '$IdField: $id'
        ' }';

  }
}

class ItemImage {
  const ItemImage(String url, String filename)
      : this.url = url?? '',
        this.filename = filename?? '';

  final String url;
  final String filename;
}

abstract class ItemData<T extends CollectionItem> {
  const ItemData(this.items);

  final List<T> items;
  int get length => items.length;

  List<int> yearlyItemCount(List<int> years, int Function(T) yearExtractor) {
    List<int> values = List<int>(years.length);
    int index = 0;

    for(int yearsIndex = 0; yearsIndex < years.length; yearsIndex++) {
      int year = years.elementAt(yearsIndex);

      int yearCount = items.where((T item) => yearExtractor(item) == year).length;

      values[index++] = yearCount;
    }

    return values;
  }

  List<N> yearlyFieldSum<N extends num>(List<int> years, int Function(T) yearExtractor, N foldInitialValue, N Function(T) fieldExtractor, {N Function(N, int) sumOperation}) {
    List<N> values = List<N>(years.length);
    int index = 0;

    for(int yearsIndex = 0; yearsIndex < years.length; yearsIndex++) {
      int year = years.elementAt(yearsIndex);

      List<T> yearItems = items.where((T item) => yearExtractor(item) == year).toList(growable: false);
      N yearSum = yearItems.fold<N>(foldInitialValue, (N previousValue, T item) => previousValue + fieldExtractor(item));
      if(sumOperation != null) {
        yearSum = sumOperation(yearSum, yearItems.length);
      }

      values[index++] = yearSum;
    }

    return values;
  }

  YearData<int> monthlyItemCount(int Function(T) monthExtractor) {
    YearData<int> yearData = YearData<int>();

    for(int month = 1; month <= 12; month++) {

      int monthCount = items.where((T item) => monthExtractor(item) == month).length;

      yearData.addData(monthCount);
    }

    return yearData;
  }

  YearData<N> monthlyFieldSum<N extends num>(int Function(T) monthExtractor, N foldInitialValue, N Function(T) fieldExtractor, {N Function(N, int) sumOperation}) {
    YearData<N> yearData = YearData<N>();

    for(int month = 1; month <= 12; month++) {

      List<T> monthItems = items.where((T item) => monthExtractor(item) == month).toList(growable: false);
      N monthSum = monthItems.fold<N>(foldInitialValue, (N previousValue, T item) => previousValue + fieldExtractor(item));
      if(sumOperation != null) {
        monthSum = sumOperation(monthSum, monthItems.length);
      }

      yearData.addData(monthSum);
    }

    return yearData;
  }

  List<int> intervalCountEqual<N extends num>(List<N> intervals, N Function(T) fieldExtractor) {
    List<int> values = List<int>(intervals.length);
    int index = 0;

    for(int intervalIndex = 0; intervalIndex < intervals.length; intervalIndex++) {
      N element = intervals.elementAt(intervalIndex);

      int intervalCount = items.where((T item) => fieldExtractor(item) == element).length;

      values[index++] = intervalCount;
    }

    return values;
  }

  List<int> intervalCount<N extends num>(List<N> intervals, N Function(T) fieldExtractor) {
    List<int> values = List<int>(intervals.length - 1);
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
    List<int> values = List<int>(intervals.length);
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
    List<int> values = List<int>(intervals.length);
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
    List<int> values = List<int>(intervals.length + 1);
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

class YearData<T> {
  YearData() {
    values = List<T>(12);
    _month = 0;
  }

  List<T> values;
  int _month;

  void addData(T data) {
    if(_month < 12) {
      values[_month++] = data;
    }
  }
}