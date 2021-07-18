import 'model.dart';


enum StoreView {
  Main,
  LastCreated,
}

class Store extends Item {
  const Store({
    required this.id,
    required this.name,
    required this.iconURL,
    required this.iconFilename,
  }) : this.uniqueId = 'St$id';

  final int id;
  final String name;
  final String? iconURL;
  final String? iconFilename;

  @override
  final String uniqueId;

  @override
  final bool hasImage = true;
  @override
  ItemImage get image => ItemImage(this.iconURL, this.iconFilename);

  @override
  String get queryableTerms => this.name;

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