import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:game_collection/entity/entity.dart';


abstract class CollectionItem extends Equatable {

  CollectionItem({
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
  ItemImage(String url, String filename)
      : this.url = url?? '',
        this.filename = filename?? '';

  final String url;
  final String filename;
}

abstract class ItemData<T extends CollectionItem> {
  ItemData(this.items);

  final List<T> items;
  int get length => items.length;
}

class YearData<T> {

  YearData() {
    values = List<T>(12);
    month = 0;
  }

  List<T> values;
  int month;

  void addData(T sum) {
    if(month < 12) {
      values[month] = sum;

      month++;
    }
  }
}