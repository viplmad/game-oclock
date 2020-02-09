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

class ItemRelationAdded extends ItemState {
  const ItemRelationAdded(this.item, this.field);

  final CollectionItem item;
  final String field;

  @override
  List<Object> get props => [item, field];

  @override
  String toString() => 'ItemRelationAdded { '
      'item: $item, '
      'field: $field'
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
  const ItemRelationDeleted(this.item, this.field);

  final CollectionItem item;
  final String field;

  @override
  List<Object> get props => [item, field];

  @override
  String toString() => 'ItemRelationDeleted { '
      'item: $item, '
      'field: $field'
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