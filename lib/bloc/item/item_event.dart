import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class AddItem extends ItemEvent {
  const AddItem([this.item]);

  final CollectionItem item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'AddItem { '
      'item: $item'
      ' }';
}

class DeleteItem extends ItemEvent {
  const DeleteItem(this.item);

  final CollectionItem item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'DeleteItem { '
      'item: $item'
      ' }';
}

class UpdateItemField extends ItemEvent {
  const UpdateItemField(this.item, this.field, this.value);

  final CollectionItem item;
  final String field;
  final dynamic value;

  @override
  List<Object> get props => [item, field, value];

  @override
  String toString() => 'UpdateItemField { '
      'item: $item, '
      'field: $field, '
      'value: $value'
      ' }';
}

class AddItemImage extends ItemEvent {
  const AddItemImage(this.item, this.imagePath, [this.oldImageName]);

  final CollectionItem item;
  final String imagePath;
  final String oldImageName;

  @override
  List<Object> get props => [item, imagePath];

  @override
  String toString() => 'AddItemImage { '
      'item: $item, '
      'image: $imagePath'
      ' }';
}

class UpdateItemImageName extends ItemEvent {
  const UpdateItemImageName(this.item, this.oldImageName, this.newImageName);

  final CollectionItem item;
  final String oldImageName;
  final String newImageName;

  @override
  List<Object> get props => [item, item];

  @override
  String toString() => 'UpdateItemImageName { '
      'item: $item, '
      'newImageName: $newImageName'
      ' }';
}

class DeleteItemImage extends ItemEvent {
  const DeleteItemImage(this.item, this.imageName);

  final CollectionItem item;
  final String imageName;

  @override
  List<Object> get props => [item, imageName];

  @override
  String toString() => 'DeleteItemImage { '
      'item: $item, '
      'image: $imageName'
      ' }';
}

class AddItemRelation extends ItemEvent {
  const AddItemRelation(this.item, this.otherItem);

  final CollectionItem item;
  final CollectionItem otherItem;
  Type get type => otherItem.runtimeType;

  @override
  List<Object> get props => [item, otherItem];

  @override
  String toString() => 'AddItemRelation { '
      'item: $item, '
      'other item: $otherItem'
      ' }';
}

class DeleteItemRelation extends ItemEvent {
  const DeleteItemRelation(this.item, this.otherItem);

  final CollectionItem item;
  final CollectionItem otherItem;
  Type get type => otherItem.runtimeType;

  @override
  List<Object> get props => [item, otherItem];

  @override
  String toString() => 'DeleteItemRelation { '
      'item: $item, '
      'other item: $otherItem'
      ' }';
}