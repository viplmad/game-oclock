import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum StoreView {
  Main,
  LastCreated,
}

class Store extends CollectionItem {

  Store({
    @required int id,
    this.name,
    this.iconURL,
    this.iconFilename,
  }) : super(id: id);

  final String name;
  final String iconURL;
  final String iconFilename;

  static Store fromEntity(StoreEntity entity, [String iconURL]) {

    return Store(
      id: entity.id,
      name: entity.name,
      iconURL: iconURL,
      iconFilename: entity.iconFilename,
    );

  }

  @override
  StoreEntity toEntity() {

    return StoreEntity(
      id: this.id,
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
      id: id,
      name: name?? this.name,
      iconURL: iconURL?? this.iconURL,
      iconFilename: iconFilename?? this.iconFilename,
    );

  }

  @override
  String getUniqueId() {

    return 'St' + this.id.toString();

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
    id,
    name,
    iconURL,
  ];

  @override
  String toString() {

    return '$storeTable { '
        '$IdField: $id, '
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