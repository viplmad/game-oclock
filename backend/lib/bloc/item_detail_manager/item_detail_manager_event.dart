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

class SetItemImage extends ItemDetailManagerEvent {
  const SetItemImage(this.imagePath);

  final String imagePath;

  @override
  List<Object> get props => <Object>[imagePath];

  @override
  String toString() => 'AddItemImage { '
      'image: $imagePath'
      ' }';
}

class UpdateItemImageName extends ItemDetailManagerEvent {
  const UpdateItemImageName(this.newImageName);

  final String newImageName;

  @override
  List<Object> get props => <Object>[newImageName];

  @override
  String toString() => 'UpdateItemImageName { '
      'newImageName: $newImageName'
      ' }';
}

class DeleteItemImage extends ItemDetailManagerEvent {}

class WarnItemDetailNotLoaded extends ItemDetailManagerEvent {
  const WarnItemDetailNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'WarnItemDetailNotLoaded { '
      'error: $error'
      ' }';
}
