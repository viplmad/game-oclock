import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemDetailEvent extends Equatable {
  const ItemDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadItem extends ItemDetailEvent {}

class UpdateItem<T extends CollectionItem> extends ItemDetailEvent {
  const UpdateItem(this.item);

  final T item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'UpdateItem { '
      'item: $item'
      ' }';
}

class UpdateItemField<T extends CollectionItem> extends ItemDetailEvent {
  const UpdateItemField(this.field, this.value);

  final String field;
  final dynamic value;

  @override
  List<Object> get props => [field, value];

  @override
  String toString() => 'UpdateItemField { '
      'field: $field, '
      'value: $value'
      ' }';
}

class AddItemImage<T extends CollectionItem> extends ItemDetailEvent {
  const AddItemImage(this.imagePath, [this.oldImageName]);

  final String imagePath;
  final String oldImageName;

  @override
  List<Object> get props => [imagePath];

  @override
  String toString() => 'AddItemImage { '
      'image: $imagePath'
      ' }';
}

class UpdateItemImageName<T extends CollectionItem> extends ItemDetailEvent {
  const UpdateItemImageName(this.oldImageName, this.newImageName);

  final String oldImageName;
  final String newImageName;

  @override
  List<Object> get props => [oldImageName, newImageName];

  @override
  String toString() => 'UpdateItemImageName { '
      'oldImageName: $oldImageName, '
      'newImageName: $newImageName'
      ' }';
}

class DeleteItemImage<T extends CollectionItem> extends ItemDetailEvent {
  const DeleteItemImage(this.imageName);

  final String imageName;

  @override
  List<Object> get props => [imageName];

  @override
  String toString() => 'DeleteItemImage { '
      'image: $imageName'
      ' }';
}