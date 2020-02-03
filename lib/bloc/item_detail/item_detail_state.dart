import 'package:equatable/equatable.dart';

import 'package:game_collection/model/collection_item.dart';


abstract class ItemDetailState extends Equatable {
  const ItemDetailState();

  @override
  List<Object> get props => [];
}

class ItemLoading extends ItemDetailState {}

class ItemLoaded extends ItemDetailState {
  const ItemLoaded(this.item);

  final CollectionItem item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemLoaded { '
      'item: $item'
      ' }';
}

class ItemNotLoaded extends ItemDetailState {
  const ItemNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemNotLoaded { '
      'error: $error'
      ' }';
}