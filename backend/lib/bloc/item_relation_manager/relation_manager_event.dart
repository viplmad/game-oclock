import 'package:equatable/equatable.dart';


abstract class RelationManagerEvent extends Equatable {
  const RelationManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class AddRelation<O extends Object> extends RelationManagerEvent {
  const AddRelation(this.otherItem);

  final O otherItem;

  @override
  List<Object> get props => <Object>[otherItem];

  @override
  String toString() => 'AddItemRelation { '
      'otherItem: $otherItem'
      ' }';
}

class DeleteRelation<O extends Object> extends RelationManagerEvent {
  const DeleteRelation(this.otherItem);

  final O otherItem;

  @override
  List<Object> get props => <Object>[otherItem];

  @override
  String toString() => 'DeleteItemRelation { '
      'otherItem: $otherItem'
      ' }';
}