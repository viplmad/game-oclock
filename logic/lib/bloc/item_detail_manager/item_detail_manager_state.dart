import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

abstract class ItemDetailManagerState extends Equatable {
  const ItemDetailManagerState();

  @override
  List<Object> get props => <Object>[];
}

class ItemDetailManagerInitialised extends ItemDetailManagerState {}

class ItemFieldUpdated extends ItemDetailManagerState {}

class ItemFieldNotUpdated extends ItemDetailManagerState {
  const ItemFieldNotUpdated(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ItemFieldNotUpdated { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}

class ItemImageUpdated extends ItemDetailManagerState {}

class ItemImageNotUpdated extends ItemDetailManagerState {
  const ItemImageNotUpdated(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ItemImageNotUpdated { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}

class ItemDetailNotLoaded extends ItemDetailManagerState {
  const ItemDetailNotLoaded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ItemDetailNotLoaded { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
