import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart';

abstract class ItemDetailManagerEvent extends Equatable {
  const ItemDetailManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateItemField<T extends Item> extends ItemDetailManagerEvent {
  const UpdateItemField(this.item, this.updatedItem);

  final T item;
  final T updatedItem;

  @override
  List<Object> get props => <Object>[item, updatedItem];

  @override
  String toString() => 'UpdateItemField { '
      'item: $item, '
      'updateItem: $updatedItem'
      ' }';
}

class AddItemImage<T extends Item> extends ItemDetailManagerEvent {
  const AddItemImage(this.imagePath, [this.oldImageName]);

  final String imagePath;
  final String? oldImageName;

  @override
  List<Object> get props => <Object>[imagePath, oldImageName ?? ''];

  @override
  String toString() => 'AddItemImage { '
      'image: $imagePath'
      ' }';
}

class UpdateItemImageName<T extends Item> extends ItemDetailManagerEvent {
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

class DeleteItemImage<T extends Item> extends ItemDetailManagerEvent {
  const DeleteItemImage(this.imageName);

  final String imageName;

  @override
  List<Object> get props => <Object>[imageName];

  @override
  String toString() => 'DeleteItemImage { '
      'image: $imageName'
      ' }';
}
