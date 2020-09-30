import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemRelationEvent extends Equatable {
  const ItemRelationEvent();

  @override
  List<Object> get props => [];
}

class LoadItemRelation extends ItemRelationEvent {}

class AddItemRelation<T extends CollectionItem, W extends CollectionItem> extends ItemRelationEvent {
  const AddItemRelation(this.item, this.otherItem);

  final T item;
  final W otherItem;

  @override
  List<Object> get props => [item, otherItem];

  @override
  String toString() => 'AddItemRelation { '
      'item: $item, '
      'other item: $otherItem'
      ' }';
}

class DeleteItemRelation<T extends CollectionItem, W extends CollectionItem> extends ItemRelationEvent {
  const DeleteItemRelation(this.item, this.otherItem);

  final T item;
  final W otherItem;

  @override
  List<Object> get props => [item, otherItem];

  @override
  String toString() => 'DeleteItemRelation { '
      'item: $item, '
      'other item: $otherItem'
      ' }';
}