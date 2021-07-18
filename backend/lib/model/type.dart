import 'model.dart';


enum TypeView {
  Main,
  LastCreated,
}

class PurchaseType extends Item {
  const PurchaseType({
    required this.id,
    required this.name,
  }) : this.uniqueId = 'Ty$id';

  final int id;
  final String name;

  @override
  final String uniqueId;

  @override
  final bool hasImage = false;
  @override
  final ItemImage image = const ItemImage(null, null);

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