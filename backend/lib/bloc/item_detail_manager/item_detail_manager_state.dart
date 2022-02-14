import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart';

abstract class ItemDetailManagerState extends Equatable {
  const ItemDetailManagerState();

  @override
  List<Object> get props => <Object>[];
}

class ItemDetailManagerInitialised extends ItemDetailManagerState {}

class ItemFieldUpdated<T extends Item> extends ItemDetailManagerState {
  const ItemFieldUpdated(this.item);

  final T item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'ItemFieldUpdated { '
      'item: $item'
      ' }';
}

class ItemFieldNotUpdated extends ItemDetailManagerState {
  const ItemFieldNotUpdated(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemFieldNotUpdated { '
      'error: $error'
      ' }';
}

class ItemImageUpdated<T extends Item> extends ItemDetailManagerState {
  const ItemImageUpdated(this.item);

  final T item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'ItemImageUpdated { '
      'item: $item'
      ' }';
}

class ItemImageNotUpdated extends ItemDetailManagerState {
  const ItemImageNotUpdated(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemImageNotUpdated { '
      'error: $error'
      ' }';
}
