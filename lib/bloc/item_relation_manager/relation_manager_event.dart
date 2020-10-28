import 'package:equatable/equatable.dart';


abstract class RelationManagerEvent extends Equatable {
  const RelationManagerEvent();

  @override
  List<Object> get props => [];
}

class AddRelation<O> extends RelationManagerEvent {
  const AddRelation(this.otherItem);

  final O otherItem;

  @override
  List<Object> get props => [otherItem];

  @override
  String toString() => 'AddItemRelation { '
      'otherItem: $otherItem'
      ' }';
}

class DeleteRelation<O> extends RelationManagerEvent {
  const DeleteRelation(this.otherItem);

  final O otherItem;

  @override
  List<Object> get props => [otherItem];

  @override
  String toString() => 'DeleteItemRelation { '
      'otherItem: $otherItem'
      ' }';
}