import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart';

abstract class ItemDetailEvent extends Equatable {
  const ItemDetailEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadItem extends ItemDetailEvent {}

class ReloadItem extends ItemDetailEvent {}

class UpdateItem<T extends Item> extends ItemDetailEvent {
  const UpdateItem(this.item);

  final T item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'UpdateItem { '
      'item: $item'
      ' }';
}
