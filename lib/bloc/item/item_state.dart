import 'package:equatable/equatable.dart';

import 'package:game_collection/model/collection_item.dart';


abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class Rested extends ItemState {}

class ItemAdded extends ItemState {
  const ItemAdded(this.item);

  final CollectionItem item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemAdded { '
      'item: $item'
      ' }';
}

class ItemNotAdded extends ItemState {
  const ItemNotAdded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemNotAdded { '
      'error: $error'
      ' }';
}

class ItemDeleted extends ItemState {
  const ItemDeleted(this.item);

  final CollectionItem item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemDeleted { '
      'item: $item'
      ' }';
}

class ItemNotDeleted extends ItemState {
  const ItemNotDeleted(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemNotDeleted { '
      'error: $error'
      ' }';
}

class ItemUpdating extends ItemState {}

class ItemFieldUpdated extends ItemState {
  const ItemFieldUpdated(this.item);

  final CollectionItem item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemFieldUpdated { '
      'item: $item'
      ' }';
}

class ItemFieldNotUpdated extends ItemState {
  const ItemFieldNotUpdated(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemFieldNotUpdated { '
      'error: $error'
      ' }';
}