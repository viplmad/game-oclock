import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:game_collection/entity/entity.dart';


abstract class CollectionItem extends Equatable {

  CollectionItem({
    @required this.id,
  });

  final int id;

  CollectionItemEntity toEntity();

  CollectionItem copyWith();

  String getUniqueID();

  String getTitle();

  String getSubtitle() => null;

  String getImageURL() => null;

  String getImageFilename() => null;

  @override
  List<Object> get props => [
    id
  ];

  @override
  String toString() {

    return 'CollectionItem { '
        '$IDField: $id'
        ' }';

  }

}

class YearData<T> {

  YearData() {
    data = new List(12);
    month = 0;
  }

  List<T> data;
  int month;

  void addData(T sum) {
    if(month < 12) {
      data[month] = sum;

      month++;
    }
  }
}