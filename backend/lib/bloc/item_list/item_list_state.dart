import 'package:equatable/equatable.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

import 'package:logic/model/model.dart' show ListStyle;

abstract class ItemListState extends Equatable {
  const ItemListState();

  @override
  List<Object> get props => <Object>[];
}

class ItemListLoading extends ItemListState {}

class ItemListLoaded<T extends PrimaryModel> extends ItemListState {
  const ItemListLoaded(
    this.items,
    this.viewIndex, [
    this.viewArgs,
    this.page = 0,
    ListStyle? style,
  ]) : style = style ?? ListStyle.card;

  final List<T> items;
  final int viewIndex;
  final Object? viewArgs;
  final int page;
  final ListStyle style;

  @override
  List<Object> get props =>
      <Object>[items, viewIndex, viewArgs ?? -1, page, style];

  @override
  String toString() => 'ItemListLoaded { '
      'items: $items, '
      'viewIndex: $viewIndex, '
      'viewArgs: $viewArgs, '
      'page: $page, '
      'style: $style'
      ' }';
}

class ItemListError extends ItemListState {}
