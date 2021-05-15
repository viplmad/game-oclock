import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemDetailManagerEvent extends Equatable {
  const ItemDetailManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateItemField<T extends CollectionItem, P extends Object> extends ItemDetailManagerEvent {
  const UpdateItemField(this.item, this.updatedItem, this.updateProperties);

  final T item;
  final T updatedItem;
  final P updateProperties;

  @override
  List<Object> get props => <Object>[item, updatedItem, updateProperties];

  @override
  String toString() => 'UpdateItemField { '
      'item: $item, '
      'updateItem: $updatedItem, '
      'updateProperties: $updateProperties'
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