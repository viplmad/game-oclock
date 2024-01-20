import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode, PrimaryModel;

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
  const ItemNotAdded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ItemNotAdded { '
      'error: $error, '
      'errorDescription: $errorDescription'
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
  const ItemNotDeleted(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ItemNotDeleted { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}

class ItemListNotLoaded extends ItemListManagerState {
  const ItemListNotLoaded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ItemListNotLoaded { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
