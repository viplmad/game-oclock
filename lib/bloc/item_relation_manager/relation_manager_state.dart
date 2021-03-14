import 'package:equatable/equatable.dart';


abstract class RelationManagerState extends Equatable {
  const RelationManagerState();

  @override
  List<Object> get props => [];
}

class Init extends RelationManagerState {}

class RelationAdded<O extends Object> extends RelationManagerState {
  const RelationAdded(this.otherItem);

  final O otherItem;

  @override
  List<Object> get props => [otherItem];

  @override
  String toString() => 'ItemRelationAdded { '
      'otherItem: $otherItem'
      ' }';
}

class RelationNotAdded extends RelationManagerState {
  const RelationNotAdded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemRelationNotAdded { '
      'error: $error'
      ' }';
}

class RelationDeleted<O extends Object> extends RelationManagerState {
  const RelationDeleted(this.otherItem);

  final O otherItem;

  @override
  List<Object> get props => [otherItem];

  @override
  String toString() => 'ItemRelationDeleted { '
      'otherItem: $otherItem'
      ' }';
}

class RelationNotDeleted extends RelationManagerState {
  const RelationNotDeleted(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemRelationNotDeleted { '
      'error: $error'
      ' }';
}