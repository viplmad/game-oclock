import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemRelationEvent extends Equatable {
  const ItemRelationEvent();

  @override
  List<Object> get props => [];
}

class LoadItemRelation extends ItemRelationEvent {}

class UpdateItemRelation<W extends CollectionItem> extends ItemRelationEvent {
  const UpdateItemRelation(this.otherItems);

  final List<W> otherItems;

  @override
  List<Object> get props => [otherItems];

  @override
  String toString() => 'UpdateItemRelation { '
      'otherItems: $otherItems'
      ' }';
}

class AddItemRelation<W extends CollectionItem> extends ItemRelationEvent {
  const AddItemRelation(this.otherItem);

  final W otherItem;

  @override
  List<Object> get props => [otherItem];

  @override
  String toString() => 'AddItemRelation { '
      'otherItem: $otherItem'
      ' }';
}

class DeleteItemRelation<W extends CollectionItem> extends ItemRelationEvent {
  const DeleteItemRelation(this.otherItem);

  final W otherItem;

  @override
  List<Object> get props => [otherItem];

  @override
  String toString() => 'DeleteItemRelation { '
      'otherItem: $otherItem'
      ' }';
}