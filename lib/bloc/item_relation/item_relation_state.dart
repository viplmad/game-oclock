import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemRelationState extends Equatable {
  const ItemRelationState();

  @override
  List<Object> get props => [];
}

class ItemRelationLoading extends ItemRelationState {}

class ItemRelationLoaded extends ItemRelationState {
  const ItemRelationLoaded([this.items = const []]);

  final List<CollectionItem> items;

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'ItemRelationLoaded { '
      'items: $items'
      ' }';
}

class ItemRelationNotLoaded extends ItemRelationState {
  const ItemRelationNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemRelationNotLoaded { '
      'error: $error'
      ' }';
}