import 'model.dart' show Item, ItemImage;


class PurchaseType extends Item {
  const PurchaseType({
    required this.id,
    required this.name,
  }) : super(
    uniqueId: 'Ty$id',
    hasImage: false,
    queryableTerms: name,
  );

  final int id;
  final String name;

  @override
  final ItemImage image = const ItemImage(null, null);

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