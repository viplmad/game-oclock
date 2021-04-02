import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum StoreView {
  Main,
  LastCreated,
}

class Store extends CollectionItem {
  const Store({
    required int id,
    required this.name,
    required this.iconURL,
    required this.iconFilename,
  }) : this.uniqueId = 'St$id',
        super(id: id);

  final String name;
  final String? iconURL;
  final String? iconFilename;

  @override
  final String uniqueId;

  @override
  final bool hasImage = true;
  @override
  ItemImage get image => ItemImage(this.iconURL, this.iconFilename);

  @override
  String get queryableTerms => this.name;

  static Store fromEntity(StoreEntity entity, [String? iconURL]) {

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
    String? name,
    String? iconURL,
    String? iconFilename,
  }) {

    return Store(
      id: id,
      name: name?? this.name,
      iconURL: iconURL?? this.iconURL,
      iconFilename: iconFilename?? this.iconFilename,
    );

  }

  @override
  List<Object> get props => [
    id,
    name,
    iconURL?? '',
  ];

  @override
  String toString() {

    return '$storeTable { '
        '$idField: $id, '
        '$stor_nameField: $name, '
        '$stor_iconField: $iconURL'
        ' }';

  }
}