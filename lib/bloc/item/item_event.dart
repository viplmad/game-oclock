import 'package:equatable/equatable.dart';

import 'package:game_collection/model/collection_item.dart';


abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class AddItem extends ItemEvent {
  const AddItem(this.item);

  final CollectionItem item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'AddItem { '
      'item: $item'
      ' }';
}

class DeleteItem extends ItemEvent {
  const DeleteItem(this.item);

  final CollectionItem item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'DeleteItem { '
      'item: $item'
      ' }';
}

abstract class UpdateItem extends ItemEvent {
  const UpdateItem(this.item, this.field);

  final CollectionItem item;
  final String field;

  @override
  List<Object> get props => [item, field];

  @override
  String toString() => 'UpdateItem { '
      'item: $item, '
      'item: $field'
      ' }';
}

class UpdateItemField extends UpdateItem {
  const UpdateItemField(CollectionItem item, String field, this.value) : super(item, field);

  final dynamic value;

  @override
  List<Object> get props => [item, field, value];

  @override
  String toString() => 'UpdateItemField { '
      'item: $item, '
      'field: $field, '
      'value: $value'
      ' }';
}

class UpdateItemRelation extends UpdateItem {
  const UpdateItemRelation(CollectionItem item, String field, this.otherItem) : super(item, field);

  final CollectionItem otherItem;

  @override
  List<Object> get props => [item, field, otherItem];

  @override
  String toString() => 'UpdateItemRelation { '
      'item: $item, '
      'field: $field, '
      'other item: $otherItem'
      ' }';
}