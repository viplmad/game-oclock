import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/sort_order.dart';


abstract class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object> get props => [];
}

class LoadItemList extends ItemListEvent {}

class UpdateItemList extends ItemListEvent {
  const UpdateItemList(this.items);

  final List<CollectionItem> items;

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'UpdateItemList { '
      'items: $items'
      ' }';
}

class UpdateSort extends ItemListEvent {
  const UpdateSort(this.fields);

  final List<String> fields;

  @override
  List<Object> get props => [fields];

  @override
  String toString() => 'UpdateSort { '
      'fields: $fields'
      ' }';
}

class UpdateSortOrder extends ItemListEvent {
  const UpdateSortOrder(this.order);

  final SortOrder order;

  @override
  List<Object> get props => [order];

  @override
  String toString() => 'UpdateSort { '
      'order: $order'
      ' }';
}

/*class UpdateFilter extends ItemListEvent {
  const UpdateFilter(this.filter);

  final FilterEnum filter;

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'UpdateFilter { '
      'filter: $filter'
      ' }';
}*/