import 'package:equatable/equatable.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

abstract class ItemListManagerState extends Equatable {
  const ItemListManagerState();

  @override
  List<Object> get props => <Object>[];
}

class ItemListManagerInitialised extends ItemListManagerState {}

class ItemAdded<T extends PrimaryModel> extends ItemListManagerState {
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

class ItemDeleted<T extends PrimaryModel> extends ItemListManagerState {
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
