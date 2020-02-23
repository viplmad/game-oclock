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
    this.iconURL,
  }) : super(ID: ID);

  final String name;
  final String iconURL;

  static Store fromEntity(StoreEntity entity, [String iconURL]) {

    return Store(
      ID: entity.ID,
      name: entity.name,
      iconURL: iconURL,
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
    String iconURL,
  }) {

    return Store(
      ID: ID,
      name: name?? this.name,
      iconURL: iconURL?? this.iconURL,
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
  String getImageURL() {

    return this.iconURL;

  }

  @override
  List<Object> get props => [
    ID,
    name,
    iconURL,
  ];

  @override
  String toString() {

    return '$storeTable { '
        '$IDField: $ID, '
        '$stor_nameField: $name, '
        '$stor_iconField: $iconURL'
        ' }';

  }

}