import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart';


abstract class ItemListManagerEvent extends Equatable {
  const ItemListManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class AddItem<T extends Item> extends ItemListManagerEvent {
  const AddItem(this.item);

  final T item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'AddItem { '
      'item: $item'
      ' }';
}

class DeleteItem<T extends Item> extends ItemListManagerEvent {
  const DeleteItem(this.item);

  final T item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'DeleteItem { '
      'item: $item'
      ' }';
}