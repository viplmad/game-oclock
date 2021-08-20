import 'model.dart' show Item, ItemImage;


enum PlatformType {
  Physical,
  Digital,
}

class Platform extends Item {
  const Platform({
    required this.id,
    required this.name,
    required this.iconURL,
    required this.iconFilename,
    required this.type,
  }) : super(
    uniqueId: 'Pl$id',
    hasImage: true,
    queryableTerms: name,
  );

  final int id;
  final String name;
  final String? iconURL;
  final String? iconFilename;
  final PlatformType? type;

  @override
  ItemImage get image => ItemImage(this.iconURL, this.iconFilename);

  @override
  Platform copyWith({
    String? name,
    String? iconURL,
    String? iconName,
    PlatformType? type,
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