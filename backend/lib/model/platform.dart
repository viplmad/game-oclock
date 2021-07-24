import 'model.dart' show Item, ItemImage;


class Platform extends Item {
  const Platform({
    required this.id,
    required this.name,
    required this.iconURL,
    required this.iconFilename,
    required this.type,
  }) : this.uniqueId = 'Pl$id';

  final int id;
  final String name;
  final String? iconURL;
  final String? iconFilename;
  final String? type;

  @override
  final String uniqueId;

  @override
  final bool hasImage = true;
  @override
  ItemImage get image => ItemImage(this.iconURL, this.iconFilename);

  @override
  String get queryableTerms => this.name;

  @override
  Platform copyWith({
    String? name,
    String? iconURL,
    String? iconName,
    String? type,
  }) {

    return Platform(
      id: id,
      name: name?? this.name,
      iconURL: iconURL?? this.iconURL,
      iconFilename: iconName?? this.iconFilename,
      type: type?? this.type,
    );

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
    iconURL?? '',
    type?? '',
  ];

  @override
  String toString() {

    return 'Platform { '
        'Id: $id, '
        'Name: $name, '
        'Icon URL: $iconURL, '
        'Type: $type'
        ' }';

  }
}