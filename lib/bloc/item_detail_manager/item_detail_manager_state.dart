import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemDetailManagerState extends Equatable {
  const ItemDetailManagerState();

  @override
  List<Object> get props => [];
}

class Initialised extends ItemDetailManagerState {}

class ItemFieldUpdated<T extends CollectionItem> extends ItemDetailManagerState {
  const ItemFieldUpdated(this.item);

  final T item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemFieldUpdated { '
      'item: $item'
      ' }';
}

class ItemFieldNotUpdated extends ItemDetailManagerState {
  const ItemFieldNotUpdated(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemFieldNotUpdated { '
      'error: $error'
      ' }';
}

class ItemImageUpdated<T extends CollectionItem> extends ItemDetailManagerState {
  const ItemImageUpdated(this.item);

  final T item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemImageUpdated { '
      'item: $item'
      ' }';
}

class ItemImageNotUpdated extends ItemDetailManagerState {
  const ItemImageNotUpdated(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemImageNotUpdated { '
      'error: $error'
      ' }';
}