import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart';


abstract class ItemRelationManagerEvent extends Equatable {
  const ItemRelationManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class AddItemRelation<W extends CollectionItem> extends ItemRelationManagerEvent {
  const AddItemRelation(this.otherItem);

  final W otherItem;

  @override
  List<Object> get props => <Object>[otherItem];

  @override
  String toString() => 'AddItemRelation { '
      'otherItem: $otherItem'
      ' }';
}

class DeleteItemRelation<W extends CollectionItem> extends ItemRelationManagerEvent {
  const DeleteItemRelation(this.otherItem);

  final W otherItem;

  @override
  List<Object> get props => <Object>[otherItem];

  @override
  String toString() => 'DeleteItemRelation { '
      'otherItem: $otherItem'
      ' }';
}