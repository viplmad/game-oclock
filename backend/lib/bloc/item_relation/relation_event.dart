import 'package:equatable/equatable.dart';


abstract class RelationEvent extends Equatable {
  const RelationEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadRelation extends RelationEvent {}

class UpdateElementRelation<O extends Object> extends RelationEvent {
  const UpdateElementRelation(this.otherItems);

  final List<O> otherItems;

  @override
  List<Object> get props => <Object>[otherItems];

  @override
  String toString() => 'UpdateItemRelation { '
      'otherItems: $otherItems'
      ' }';
}

class UpdateRelationElement<O extends Object> extends RelationEvent {
  const UpdateRelationElement(this.oldItem, this.item);

  final O oldItem;
  final O item;

  @override
  List<Object> get props => <Object>[oldItem, item];

  @override
  String toString() => 'UpdateRelationItem { '
      'oldItem: $oldItem, '
      'item: $item'
      ' }';
}