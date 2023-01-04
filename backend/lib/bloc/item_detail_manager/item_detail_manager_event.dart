import 'package:equatable/equatable.dart';

abstract class ItemDetailManagerEvent extends Equatable {
  const ItemDetailManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateItemField<N extends Object> extends ItemDetailManagerEvent {
  const UpdateItemField(this.item);

  final N item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'UpdateItemField { '
      'item: $item'
      ' }';
}

class AddItemImage extends ItemDetailManagerEvent {
  const AddItemImage(this.imagePath);

  final String imagePath;

  @override
  List<Object> get props => <Object>[imagePath];

  @override
  String toString() => 'AddItemImage { '
      'image: $imagePath'
      ' }';
}

class UpdateItemImageName extends ItemDetailManagerEvent {
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

class DeleteItemImage extends ItemDetailManagerEvent {
  const DeleteItemImage(this.imageName);

  final String imageName;

  @override
  List<Object> get props => <Object>[imageName];

  @override
  String toString() => 'DeleteItemImage { '
      'image: $imageName'
      ' }';
}
