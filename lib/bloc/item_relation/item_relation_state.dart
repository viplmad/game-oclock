import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemRelationState extends Equatable {
  const ItemRelationState();

  @override
  List<Object> get props => [];
}

class ItemRelationLoading extends ItemRelationState {}

class ItemRelationLoaded<W extends CollectionItem> extends ItemRelationState {
  const ItemRelationLoaded([this.otherItems = const []]);

  final List<W> otherItems;

  @override
  List<Object> get props => [otherItems];

  @override
  String toString() => 'ItemRelationLoaded { '
      'otherItems: $otherItems'
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

class ItemRelationAdded<W extends CollectionItem> extends ItemRelationState {
  const ItemRelationAdded(this.otherItem);

  final W otherItem;

  @override
  List<Object> get props => [otherItem];

  @override
  String toString() => 'ItemRelationAdded { '
      'otherItem: $otherItem'
      ' }';
}

class ItemRelationNotAdded extends ItemRelationState {
  const ItemRelationNotAdded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemRelationNotAdded { '
      'error: $error'
      ' }';
}

class ItemRelationDeleted<W extends CollectionItem> extends ItemRelationState {
  const ItemRelationDeleted(this.otherItem);

  final W otherItem;

  @override
  List<Object> get props => [otherItem];

  @override
  String toString() => 'ItemRelationDeleted { '
      'otherItem: $otherItem'
      ' }';
}

class ItemRelationNotDeleted extends ItemRelationState {
  const ItemRelationNotDeleted(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemRelationNotDeleted { '
      'error: $error'
      ' }';
}