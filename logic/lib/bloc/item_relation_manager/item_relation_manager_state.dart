import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

abstract class ItemRelationManagerState extends Equatable {
  const ItemRelationManagerState();

  @override
  List<Object> get props => <Object>[];
}

class ItemRelationManagerInitialised extends ItemRelationManagerState {}

class ItemRelationAdded extends ItemRelationManagerState {}

class ItemRelationNotAdded extends ItemRelationManagerState {
  const ItemRelationNotAdded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ItemRelationNotAdded { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}

class ItemRelationDeleted extends ItemRelationManagerState {}

class ItemRelationNotDeleted extends ItemRelationManagerState {
  const ItemRelationNotDeleted(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ItemRelationNotDeleted { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}

class ItemRelationNotLoaded extends ItemRelationManagerState {
  const ItemRelationNotLoaded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ItemRelationNotLoaded { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
