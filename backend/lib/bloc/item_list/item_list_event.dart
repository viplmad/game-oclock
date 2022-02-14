import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart';
import 'package:backend/model/list_style.dart';

abstract class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadItemList extends ItemListEvent {}

class UpdateItemList<T extends Item> extends ItemListEvent {
  const UpdateItemList(
    this.items,
    this.viewIndex,
    this.year,
    this.page,
    this.style,
  );

  final List<T> items;
  final int viewIndex;
  final int? year;
  final int page;
  final ListStyle style;

  @override
  List<Object> get props => <Object>[items, viewIndex, year ?? -1, page, style];

  @override
  String toString() => 'UpdateItemList { '
      'items: $items, '
      'viewIndex: $viewIndex, '
      'year: $year, '
      'page: $page, '
      'style: $style'
      ' }';
}

class UpdateListItem<T extends Item> extends ItemListEvent {
  const UpdateListItem(this.item);

  final T item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'UpdateItemList { '
      'item: $item'
      ' }';
}

class UpdateView extends ItemListEvent {
  const UpdateView(this.viewIndex);

  final int viewIndex;

  @override
  List<Object> get props => <Object>[viewIndex];

  @override
  String toString() => 'UpdateView { '
      'viewIndex: $viewIndex'
      ' }';
}

class UpdateYearView extends ItemListEvent {
  const UpdateYearView(this.viewIndex, this.year);

  final int viewIndex;
  final int year;

  @override
  List<Object> get props => <Object>[viewIndex, year];

  @override
  String toString() => 'UpdateView { '
      'viewIndex: $viewIndex, '
      'year: $year'
      ' }';
}

class UpdatePage extends ItemListEvent {}

class UpdateStyle extends ItemListEvent {}
