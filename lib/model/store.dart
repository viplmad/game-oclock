import 'package:meta/meta.dart';

import 'package:game_collection/entity/collection_item_entity.dart';
import 'package:game_collection/entity/store_entity.dart';

import 'collection_item.dart';


enum StoreView {
  Main,
  LastCreated,
}

const List<String> storeViews = [
  "Main",
  "Last Created",
];

class Store extends CollectionItem {

  Store({
    @required int ID,
    this.name,
  }) : super(ID: ID);

  final String name;

  static Store fromEntity(StoreEntity entity) {

    return Store(
      ID: entity.ID,
      name: entity.name,
    );

  }

  @override
  StoreEntity toEntity() {

    return StoreEntity(
      ID: this.ID,
      name: this.name,
    );

  }

  @override
  Store copyWith({
    String name,
  }) {

    return Store(
      ID: ID,
      name: name?? this.name,
    );

  }

  @override
  String getUniqueID() {

    return 'St' + this.ID.toString();

  }

  @override
  String getTitle() {

    return this.name;

  }

  @override
  List<Object> get props => [
    ID,
    name,
  ];

  @override
  String toString() {

    return '$storeTable { '
        '$IDField: $ID, '
        '$stor_nameField: $name'
        ' }';

  }

}