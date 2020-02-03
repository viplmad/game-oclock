import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';


const String IDField = 'ID';

abstract class CollectionItemEntity extends Equatable {

  const CollectionItemEntity({
    @required this.ID
  });

  final int ID;

  external Map<String, dynamic> toDynamicMap();

  @override
  List<Object> get props => [
    ID
  ];

  @override
  String toString() {

    return 'CollectionItemEntity { '
        'id: $ID'
        ' }';

  }


}