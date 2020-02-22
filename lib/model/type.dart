import 'package:meta/meta.dart';

import 'package:game_collection/entity/collection_item_entity.dart';
import 'package:game_collection/entity/type_entity.dart';

import 'collection_item.dart';


enum TypeView {
  Main,
  LastCreated,
}

const List<String> typeViews = [
  "Main",
  "Last Created",
];

class PurchaseType extends CollectionItem {

  PurchaseType({
    @required int ID,
    this.name,
  }) : super(ID: ID);

  final String name;

  static PurchaseType fromEntity(PurchaseTypeEntity entity) {

    return PurchaseType(
      ID: entity.ID,
      name: entity.name,
    );

  }

  @override
  PurchaseTypeEntity toEntity() {

    return PurchaseTypeEntity(
      ID: this.ID,
      name: this.name,
    );

  }

  @override
  PurchaseType copyWith({
    String name,
  }) {

    return PurchaseType(
      ID: ID,
      name: name?? this.name,
    );

  }

  @override
  String getUniqueID() {

    return 'Ty' + this.ID.toString();

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

    return '$typeTable { '
        '$IDField: $ID, '
        '$type_nameField: $name'
        ' }';

  }

}