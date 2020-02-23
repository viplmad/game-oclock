import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';


const String IDField = 'ID';

abstract class CollectionItemEntity extends Equatable {

  const CollectionItemEntity({
    @required this.ID
  });

  final int ID;

  external Map<String, dynamic> toDynamicMap();

  static Map<String, dynamic> combineMaps(Map<String, Map<String, dynamic>> manyMap, String primaryTableName) {

    Map<String, dynamic> _combinedMaps = Map<String, dynamic>();
    manyMap.forEach( (String table, Map<String, dynamic> map) {

      if(table == null || table == primaryTableName) {
        _combinedMaps.addAll( map );
      }

    });

    return _combinedMaps;

  }

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