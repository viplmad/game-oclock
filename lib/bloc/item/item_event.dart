import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class AddItem extends ItemEvent {
  const AddItem([this.title]);

  final String title;

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'AddItem { '
      'title: $title'
      ' }';
}

class DeleteItem<T extends CollectionItem> extends ItemEvent {
  const DeleteItem(this.item);

  final T item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'DeleteItem { '
      'item: $item'
      ' }';
}

class UpdateItemField<T extends CollectionItem> extends ItemEvent {
  const UpdateItemField(this.item, this.field, this.value);

  final T item;
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

class AddItemImage<T extends CollectionItem> extends ItemEvent {
  const AddItemImage(this.item, this.imagePath, [this.oldImageName]);

  final T item;
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

class UpdateItemImageName<T extends CollectionItem> extends ItemEvent {
  const UpdateItemImageName(this.item, this.oldImageName, this.newImageName);

  final T item;
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

class DeleteItemImage<T extends CollectionItem> extends ItemEvent {
  const DeleteItemImage(this.item, this.imageName);

  final T item;
  final String imageName;

  @override
  List<Object> get props => [item, imageName];

  @override
  String toString() => 'DeleteItemImage { '
      'item: $item, '
      'image: $imageName'
      ' }';
}