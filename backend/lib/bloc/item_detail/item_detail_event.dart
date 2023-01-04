import 'package:equatable/equatable.dart';

abstract class ItemDetailEvent extends Equatable {
  const ItemDetailEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadItem extends ItemDetailEvent {}

class ReloadItem extends ItemDetailEvent {}

class UpdateItem<N extends Object> extends ItemDetailEvent {
  const UpdateItem(this.item);

  final N item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'UpdateItem { '
      'item: $item'
      ' }';
}
