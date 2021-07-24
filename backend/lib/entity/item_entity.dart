import 'package:equatable/equatable.dart';


abstract class ItemEntity extends Equatable {
  const ItemEntity();

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