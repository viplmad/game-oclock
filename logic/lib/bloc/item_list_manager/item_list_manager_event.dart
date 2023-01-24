import 'package:equatable/equatable.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

abstract class ItemListManagerEvent extends Equatable {
  const ItemListManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class AddItem<N extends Object> extends ItemListManagerEvent {
  const AddItem(this.item);

  final N item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'AddItem { '
      'item: $item'
      ' }';
}

class DeleteItem<T extends PrimaryModel> extends ItemListManagerEvent {
  const DeleteItem(this.item);

  final T item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'DeleteItem { '
      'item: $item'
      ' }';
}

class WarnItemListNotLoaded extends ItemListManagerEvent {
  const WarnItemListNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'WarnItemListNotLoaded { '
      'error: $error'
      ' }';
}
