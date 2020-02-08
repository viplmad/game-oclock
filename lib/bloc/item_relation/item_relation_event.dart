import 'package:equatable/equatable.dart';

import 'package:game_collection/model/collection_item.dart';


abstract class ItemRelationEvent extends Equatable {
  const ItemRelationEvent();

  @override
  List<Object> get props => [];
}

class LoadItemRelation extends ItemRelationEvent {}

class UpdateItemRelation extends ItemRelationEvent {
  const UpdateItemRelation(this.items);

  final List<CollectionItem> items;

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'UpdateItemRelation { '
      'items: $items'
      ' }';
}