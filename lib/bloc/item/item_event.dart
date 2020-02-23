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

class UpdateItemImage extends ItemEvent {
  const UpdateItemImage(this.item, this.imagePath);

  final CollectionItem item;
  final String imagePath;

  @override
  List<Object> get props => [item, imagePath];

  @override
  String toString() => 'UpdateItemImage { '
      'item: $item, '
      'image: $imagePath'
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