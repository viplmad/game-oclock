import 'model.dart' show Item, ItemImage;


class Store extends Item {
  const Store({
    required this.id,
    required this.name,
    required this.iconURL,
    required this.iconFilename,
  }) : super(
    uniqueId: 'St$id',
    hasImage: true,
    queryableTerms: name,
  );

  final int id;
  final String name;
  final String? iconURL;
  final String? iconFilename;

  @override
  ItemImage get image => ItemImage(iconURL, iconFilename);

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
  List<Object> get props => <Object>[
    id,
    name,
    iconURL?? '',
  ];

  @override
  String toString() {

    return 'Store { '
        'Id: $id, '
        'Name: $name, '
        'Icon URL: $iconURL'
        ' }';

  }
}