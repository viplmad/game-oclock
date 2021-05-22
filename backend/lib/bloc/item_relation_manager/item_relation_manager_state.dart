import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart';


abstract class ItemRelationManagerState extends Equatable {
  const ItemRelationManagerState();

  @override
  List<Object> get props => <Object>[];
}

class ItemRelationManagerInitialised extends ItemRelationManagerState {}

class ItemRelationAdded<W extends CollectionItem> extends ItemRelationManagerState {
  const ItemRelationAdded(this.otherItem);

  final W otherItem;

  @override
  List<Object> get props => <Object>[otherItem];

  @override
  String toString() => 'ItemRelationAdded { '
      'otherItem: $otherItem'
      ' }';
}

class ItemRelationNotAdded extends ItemRelationManagerState {
  const ItemRelationNotAdded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemRelationNotAdded { '
      'error: $error'
      ' }';
}

class ItemRelationDeleted<W extends CollectionItem> extends ItemRelationManagerState {
  const ItemRelationDeleted(this.otherItem);

  final W otherItem;

  @override
  List<Object> get props => <Object>[otherItem];

  @override
  String toString() => 'ItemRelationDeleted { '
      'otherItem: $otherItem'
      ' }';
}

class ItemRelationNotDeleted extends ItemRelationManagerState {
  const ItemRelationNotDeleted(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemRelationNotDeleted { '
      'error: $error'
      ' }';
}