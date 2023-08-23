import 'package:equatable/equatable.dart';

abstract class ItemRelationManagerState extends Equatable {
  const ItemRelationManagerState();

  @override
  List<Object> get props => <Object>[];
}

class ItemRelationManagerInitialised extends ItemRelationManagerState {}

class ItemRelationAdded extends ItemRelationManagerState {}

class ItemRelationNotAdded extends ItemRelationManagerState {
  const ItemRelationNotAdded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemRelationNotAdded { '
      'error: $error'
      ' }';
}

class ItemRelationDeleted extends ItemRelationManagerState {}

class ItemRelationNotDeleted extends ItemRelationManagerState {
  const ItemRelationNotDeleted(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemRelationNotDeleted { '
      'error: $error'
      ' }';
}

class ItemRelationNotLoaded extends ItemRelationManagerState {
  const ItemRelationNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemRelationNotLoaded { '
      'error: $error'
      ' }';
}
