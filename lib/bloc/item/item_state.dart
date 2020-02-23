import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class Rested extends ItemState {}

class ItemAdded extends ItemState {
  const ItemAdded(this.item);

  final CollectionItem item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemAdded { '
      'item: $item'
      ' }';
}

class ItemNotAdded extends ItemState {
  const ItemNotAdded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemNotAdded { '
      'error: $error'
      ' }';
}

class ItemDeleted extends ItemState {
  const ItemDeleted(this.item);

  final CollectionItem item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemDeleted { '
      'item: $item'
      ' }';
}

class ItemNotDeleted extends ItemState {
  const ItemNotDeleted(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemNotDeleted { '
      'error: $error'
      ' }';
}

class ItemUpdating extends ItemState {}

class ItemFieldUpdated extends ItemState {
  const ItemFieldUpdated(this.item);

  final CollectionItem item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemFieldUpdated { '
      'item: $item'
      ' }';
}

class ItemFieldNotUpdated extends ItemState {
  const ItemFieldNotUpdated(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemFieldNotUpdated { '
      'error: $error'
      ' }';
}

class ItemImageUpdated extends ItemState {
  const ItemImageUpdated(this.item);

  final CollectionItem item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemImageUpdated { '
      'item: $item'
      ' }';
}

class ItemImageNotUpdated extends ItemState {
  const ItemImageNotUpdated(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemImageNotUpdated { '
      'error: $error'
      ' }';
}

class ItemRelationAdded extends ItemState {
  const ItemRelationAdded(this.item);

  final CollectionItem item;
  Type get type => item.runtimeType;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemRelationAdded { '
      'item: $item'
      ' }';
}

class ItemRelationNotAdded extends ItemState {
  const ItemRelationNotAdded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemRelationNotAdded { '
      'error: $error'
      ' }';
}

class ItemRelationDeleted extends ItemState {
  const ItemRelationDeleted(this.item);

  final CollectionItem item;
  Type get type => item.runtimeType;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemRelationDeleted { '
      'item: $item'
      ' }';
}

class ItemRelationNotDeleted extends ItemState {
  const ItemRelationNotDeleted(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemRelationNotDeleted { '
      'error: $error'
      ' }';
}