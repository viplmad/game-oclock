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
  ItemImage get image => const ItemImage(null, null);

  @override
  String get queryableTerms => this.name;

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
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return 'Purchase Type { '
        'Id: $id, '
        'Name: $name'
        ' }';

  }
}

class PurchaseTypeUpdateProperties {

  const PurchaseTypeUpdateProperties();
}