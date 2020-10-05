import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';


abstract class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object> get props => [];
}

class LoadItemList extends ItemListEvent {}

class UpdateItemList<T extends CollectionItem> extends ItemListEvent {
  const UpdateItemList(this.items, this.viewIndex, this.style);

  final List<T> items;
  final int viewIndex;
  final ListStyle style;

  @override
  List<Object> get props => [items, viewIndex, style];

  @override
  String toString() => 'UpdateItemList { '
      'items: $items, '
      'viewIndex: $viewIndex, '
      'style: $style'
      ' }';
}

class UpdateView extends ItemListEvent {
  const UpdateView(this.viewIndex);

  final int viewIndex;

  @override
  List<Object> get props => [viewIndex];

  @override
  String toString() => 'UpdateView { '
      'viewIndex: $viewIndex'
      ' }';
}

class UpdateSortOrder extends ItemListEvent {}

class UpdateStyle extends ItemListEvent {}