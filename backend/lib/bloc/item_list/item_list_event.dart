import 'package:equatable/equatable.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

import 'package:backend/model/model.dart' show ListStyle;

abstract class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadItemList extends ItemListEvent {}

class ReloadItemList extends ItemListEvent {}

class UpdateItemList<T extends PrimaryModel> extends ItemListEvent {
  const UpdateItemList(
    this.items,
    this.viewIndex,
    this.viewArgs,
    this.page,
    this.style,
  );

  final List<T> items;
  final int viewIndex;
  final Object? viewArgs;
  final int page;
  final ListStyle style;

  @override
  List<Object> get props =>
      <Object>[items, viewIndex, viewArgs ?? -1, page, style];

  @override
  String toString() => 'UpdateItemList { '
      'items: $items, '
      'viewIndex: $viewIndex, '
      'viewArgs: $viewArgs, '
      'page: $page, '
      'style: $style'
      ' }';
}

class UpdateView extends ItemListEvent {
  const UpdateView(this.viewIndex, [this.viewArgs]);

  final int viewIndex;
  final Object? viewArgs;

  @override
  List<Object> get props => <Object>[viewIndex];

  @override
  String toString() => 'UpdateView { '
      'viewIndex: $viewIndex, '
      'viewArgs: $viewArgs'
      ' }';
}

class UpdatePage extends ItemListEvent {}

class UpdateStyle extends ItemListEvent {}
