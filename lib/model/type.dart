import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum TypeView {
  Main,
  LastCreated,
}

class PurchaseType extends CollectionItem {

  PurchaseType({
    @required int id,
    this.name,
  }) : super(id: id);

  final String name;

  static PurchaseType fromEntity(PurchaseTypeEntity entity) {

    return PurchaseType(
      id: entity.id,
      name: entity.name,
    );

  }

  @override
  PurchaseTypeEntity toEntity() {

    return PurchaseTypeEntity(
      id: this.id,
      name: this.name,
    );

  }

  @override
  PurchaseType copyWith({
    String name,
  }) {

    return PurchaseType(
      id: id,
      name: name?? this.name,
    );

  }

  @override
  String getUniqueId() {

    return 'Ty' + this.id.toString();

  }

  @override
  String getTitle() {

    return this.name;

  }

  @override
  List<Object> get props => [
    id,
    name,
  ];

  @override
  String toString() {

    return '$typeTable { '
        '$IdField: $id, '
        '$type_nameField: $name'
        ' }';

  }

}

class TypesData {

  TypesData({
    this.types,
  });

  final List<PurchaseType> types;

}