import 'package:equatable/equatable.dart';


abstract class ItemEntity extends Equatable {
  const ItemEntity();

  static Map<String, dynamic> combineMaps(Map<String, Map<String, dynamic>> manyMap, String primaryTableName) {

    final Map<String, dynamic> _combinedMaps = Map<String, dynamic>();
    manyMap.forEach((String table, Map<String, dynamic> map) {

      if(table.isEmpty || table == primaryTableName) {
        _combinedMaps.addAll( map );
      }

    });

    return _combinedMaps;

  }

  void putCreateMapValueNullable(Map<String, Object?> createMap, String field, Object? value) {
    if(value != null) {
      createMap[field] = value;
    }
  }

  void putUpdateMapValue(Map<String, Object?> updateMap, String field, Object? value, Object? updatedValue) {
    if(value != updatedValue) {
      updateMap[field] = updatedValue;
    }
  }

  void putUpdateMapValueNullable(Map<String, Object?> updateMap, String field, Object? value, Object? updatedValue) {
    if(value != updatedValue && updatedValue != null) {
      updateMap[field] = updatedValue;
    }
  }
}