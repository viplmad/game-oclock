import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum StoreView {
  Main,
  LastCreated,
}

class Store extends CollectionItem {

  Store({
    @required int ID,
    this.name,
    this.iconURL,
    this.iconFilename,
  }) : super(ID: ID);

  final String name;
  final String iconURL;
  final String iconFilename;

  static Store fromEntity(StoreEntity entity, [String iconURL]) {

    return Store(
      ID: entity.ID,
      name: entity.name,
      iconURL: iconURL,
      iconFilename: entity.iconFilename,
    );

  }

  @override
  StoreEntity toEntity() {

    return StoreEntity(
      ID: this.ID,
      name: this.name,
      iconFilename: this.iconFilename,
    );

  }

  @override
  Store copyWith({
    String name,
    String iconURL,
    String iconFilename,
  }) {

    return Store(
      ID: ID,
      name: name?? this.name,
      iconURL: iconURL?? this.iconURL,
      iconFilename: iconFilename?? this.iconFilename,
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

    return this.iconURL?? '';

  }

  @override
  String getImageFilename() {

    return this.iconFilename;

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

class StoresData {

  StoresData({
    this.stores,
  });

  final List<Store> stores;

}