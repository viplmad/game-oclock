import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart';


abstract class ItemListManagerState extends Equatable {
  const ItemListManagerState();

  @override
  List<Object> get props => <Object>[];
}

class ItemListManagerInitialised extends ItemListManagerState {}

class ItemAdded<T extends CollectionItem> extends ItemListManagerState {
  const ItemAdded(this.item);

  final T item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'ItemAdded { '
      'item: $item'
      ' }';
}

class ItemNotAdded extends ItemListManagerState {
  const ItemNotAdded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemNotAdded { '
      'error: $error'
      ' }';
}

class ItemDeleted<T extends CollectionItem> extends ItemListManagerState {
  const ItemDeleted(this.item);

  final T item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'ItemDeleted { '
      'item: $item'
      ' }';
}

class ItemNotDeleted extends ItemListManagerState {
  const ItemNotDeleted(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemNotDeleted { '
      'error: $error'
      ' }';
}