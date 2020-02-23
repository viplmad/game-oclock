import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';

import 'package:game_collection/entity/collection_item_entity.dart';


//TODO: move to localisation
abstract class CollectionItem extends Equatable {

  CollectionItem({
    @required this.ID
  });

  final int ID;

  external CollectionItemEntity toEntity();

  external CollectionItem copyWith();

  external String getUniqueID();

  external String getTitle();

  String getSubtitle() => null;

  String getImageURL() => null;

  @override
  List<Object> get props => [
    ID
  ];

  @override
  String toString() {

    return 'CollectionItem { '
        '$IDField: $ID'
        ' }';

  }

}