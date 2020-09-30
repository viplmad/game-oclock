import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';

import 'package:game_collection/entity/collection_item_entity.dart';


abstract class CollectionItem extends Equatable {

  CollectionItem({
    @required this.ID
  });

  final int ID;

  external CollectionItemEntity toEntity();

  external CollectionItem copyWith();

  external String getUniqueID();

  external String getTitle();

  String getSubtitle() => null;

  String getImageURL() => null;

  String getImageFilename() => null;

  @override
  List<Object> get props => [
    ID
  ];

  @override
  String toString() {

    return 'CollectionItem { '
        '$IDField: $ID'
        ' }';

  }

}

class Item extends CollectionItem {

  Item({
    @required int ID,
    this.title,
  }) : super(ID: ID);

  final String title;

  @override
  String getTitle() => this.title;

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