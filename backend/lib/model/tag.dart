import 'model.dart' show Item, ItemImage;


class Tag extends Item {
  const Tag({
    required this.id,
    required this.name,
  }) : this.uniqueId = 'Tg$id';

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
  Tag copyWith({
    String? name,
  }) {

    return Tag(
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

    return 'Game Tag { '
        'Id: $id, '
        'Name: $name'
        ' }';

  }
}