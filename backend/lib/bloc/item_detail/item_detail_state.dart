import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart';


abstract class ItemDetailState extends Equatable {
  const ItemDetailState();

  @override
  List<Object> get props => <Object>[];
}

class ItemLoading extends ItemDetailState {}

class ItemLoaded<T extends Item> extends ItemDetailState {
  const ItemLoaded(this.item);

  final T item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'ItemLoaded { '
      'item: $item'
      ' }';
}

class ItemNotLoaded extends ItemDetailState {
  const ItemNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemNotLoaded { '
      'error: $error'
      ' }';
}