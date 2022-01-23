import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart';
import 'package:backend/model/list_style.dart';


abstract class ItemListState extends Equatable {
  const ItemListState();

  @override
  List<Object> get props => <Object>[];
}

class ItemListLoading extends ItemListState {}

class ItemListLoaded<T extends Item> extends ItemListState {
  const ItemListLoaded(this.items, [this.viewIndex = 0, int? year, ListStyle? style])
      : year = year?? -1,
        style = style?? ListStyle.card;

  final List<T> items;
  final int viewIndex;
  final int year;
  final ListStyle style;

  @override
  List<Object> get props => <Object>[items, viewIndex, year, style];

  @override
  String toString() => 'ItemListLoaded { '
      'items: $items, '
      'viewIndex: $viewIndex, '
      'year: $year, '
      'style: $style'
      ' }';
}

class ItemListNotLoaded extends ItemListState {
  const ItemListNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemListNotLoaded { '
      'error: $error'
      ' }';
}