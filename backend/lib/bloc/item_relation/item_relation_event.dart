import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart';


abstract class ItemRelationEvent extends Equatable {
  const ItemRelationEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadItemRelation extends ItemRelationEvent {}

class UpdateItemRelation<W extends CollectionItem> extends ItemRelationEvent {
  const UpdateItemRelation(this.otherItems);

  final List<W> otherItems;

  @override
  List<Object> get props => <Object>[otherItems];

  @override
  String toString() => 'UpdateItemRelation { '
      'otherItems: $otherItems'
      ' }';
}

class UpdateRelationItem<T extends CollectionItem> extends ItemRelationEvent {
  const UpdateRelationItem(this.item);

  final T item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'UpdateRelationItem { '
      'item: $item'
      ' }';
}