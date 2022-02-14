import 'model.dart' show Item, ItemImage;

class GameTag extends Item {
  const GameTag({
    required this.id,
    required this.name,
  }) : super(
          uniqueId: 'T$id',
          hasImage: false,
          queryableTerms: name,
        );

  final int id;
  final String name;

  @override
  final ItemImage image = const ItemImage(null, null);

  @override
  GameTag copyWith({
    String? name,
  }) {
    return GameTag(
      id: id,
      name: name ?? this.name,
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
