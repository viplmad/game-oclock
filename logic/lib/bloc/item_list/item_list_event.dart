import 'package:equatable/equatable.dart';

abstract class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadItemList extends ItemListEvent {}

class ReloadItemList extends ItemListEvent {
  const ReloadItemList({this.silent = false});

  final bool silent;

  @override
  List<Object> get props => <Object>[silent];

  @override
  String toString() => 'ReloadItemList { '
      'silent: $silent'
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
