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
  const ItemListLoaded(this.items,[ this.viewIndex = 0, this.style = ListStyle.Card]);

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