import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show PrimaryModel;

import 'package:logic/model/model.dart' show ListStyle;

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
    this.page,
    this.style,
  );

  final List<T> items;
  final int viewIndex;
  final int page;
  final ListStyle style;

  @override
  List<Object> get props => <Object>[items, viewIndex, page, style];

  @override
  String toString() => 'UpdateItemList { '
      'items: $items, '
      'viewIndex: $viewIndex, '
      'page: $page, '
      'style: $style'
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

class UpdatePage extends ItemListEvent {}

class UpdateStyle extends ItemListEvent {}
