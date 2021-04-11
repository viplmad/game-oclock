import 'package:equatable/equatable.dart';


abstract class RelationState extends Equatable {
  const RelationState();

  @override
  List<Object> get props => <Object>[];
}

class RelationLoading extends RelationState {}

class RelationLoaded<O extends Object> extends RelationState {
  const RelationLoaded(this.otherItems);

  final List<O> otherItems;

  @override
  List<Object> get props => <Object>[otherItems];

  @override
  String toString() => 'ItemRelationLoaded { '
      'otherItems: $otherItems'
      ' }';
}

class RelationNotLoaded extends RelationState {
  const RelationNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemRelationNotLoaded { '
      'error: $error'
      ' }';
}