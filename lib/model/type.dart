import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum TypeView {
  Main,
  LastCreated,
}

class PurchaseType extends CollectionItem {
  const PurchaseType({
    required int id,
    required this.name,
  }) : this.uniqueId = 'Ty$id',
        super(id: id);

  final String name;

  @override
  final String uniqueId;

  @override
  final bool hasImage = false;
  @override
  ItemImage get image => ItemImage(null, null);

  @override
  String get queryableTerms => this.name;

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
    String? name,
  }) {

    return PurchaseType(
      id: id,
      name: name?? this.name,
    );

  }

  @override
  List<Object> get props => [
    id,
    name,
  ];

  @override
  String toString() {

    return '$typeTable { '
        '$idField: $id, '
        '$type_nameField: $name'
        ' }';

  }
}