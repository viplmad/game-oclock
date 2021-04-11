import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemDetailManagerEvent extends Equatable {
  const ItemDetailManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateItemField<T extends CollectionItem> extends ItemDetailManagerEvent {
  const UpdateItemField(this.field, this.value);

  final String field;
  final dynamic value;

  @override
  List<Object> get props => <Object>[field, value as Object];

  @override
  String toString() => 'UpdateItemField { '
      'field: $field, '
      'value: $value'
      ' }';
}

class AddItemImage<T extends CollectionItem> extends ItemDetailManagerEvent {
  const AddItemImage(this.imagePath, [this.oldImageName]);

  final String imagePath;
  final String? oldImageName;

  @override
  List<Object> get props => <Object>[imagePath, oldImageName?? ''];

  @override
  String toString() => 'AddItemImage { '
      'image: $imagePath'
      ' }';
}

class UpdateItemImageName<T extends CollectionItem> extends ItemDetailManagerEvent {
  const UpdateItemImageName(this.oldImageName, this.newImageName);

  final String oldImageName;
  final String newImageName;

  @override
  List<Object> get props => <Object>[oldImageName, newImageName];

  @override
  String toString() => 'UpdateItemImageName { '
      'oldImageName: $oldImageName, '
      'newImageName: $newImageName'
      ' }';
}

class DeleteItemImage<T extends CollectionItem> extends ItemDetailManagerEvent {
  const DeleteItemImage(this.imageName);

  final String imageName;

  @override
  List<Object> get props => <Object>[imageName];

  @override
  String toString() => 'DeleteItemImage { '
      'image: $imageName'
      ' }';
}