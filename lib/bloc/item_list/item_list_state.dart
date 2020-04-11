import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemListState extends Equatable {
  const ItemListState();

  @override
  List<Object> get props => [];
}

class ItemListLoading extends ItemListState {}

class ItemListLoaded extends ItemListState {
  const ItemListLoaded([this.items = const [], this.view = "Main", this.isGrid = false]);

  final List<CollectionItem> items;
  final String view;
  final bool isGrid;

  @override
  List<Object> get props => [items, view, isGrid];

  @override
  String toString() => 'ItemListLoaded { '
      'items: $items, '
      'view: $view, '
      'isGrid: $isGrid'
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