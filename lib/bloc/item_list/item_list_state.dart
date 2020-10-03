import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';


abstract class ItemListState extends Equatable {
  const ItemListState();

  @override
  List<Object> get props => [];
}

class ItemListLoading extends ItemListState {}

class ItemListLoaded<T extends CollectionItem> extends ItemListState {
  const ItemListLoaded([this.items = const [], this.viewIndex = 0, this.style = ListStyle.Card]);

  final List<T> items;
  final int viewIndex;
  final ListStyle style;

  @override
  List<Object> get props => [items, viewIndex, style];

  @override
  String toString() => 'ItemListLoaded { '
      'items: $items, '
      'viewIndex: $viewIndex, '
      'style: $style'
      ' }';
}

class ItemListNotLoaded extends ItemListState {
  const ItemListNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemListNotLoaded { '
      'error: $error'
      ' }';
}

class ItemAdded<T extends CollectionItem> extends ItemListState {
  const ItemAdded(this.item);

  final T item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemAdded { '
      'item: $item'
      ' }';
}

class ItemNotAdded extends ItemListState {
  const ItemNotAdded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemNotAdded { '
      'error: $error'
      ' }';
}

class ItemDeleted<T extends CollectionItem> extends ItemListState {
  const ItemDeleted(this.item);

  final T item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemDeleted { '
      'item: $item'
      ' }';
}

class ItemNotDeleted extends ItemListState {
  const ItemNotDeleted(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemNotDeleted { '
      'error: $error'
      ' }';
}