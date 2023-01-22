import 'package:equatable/equatable.dart';

abstract class ItemDetailManagerState extends Equatable {
  const ItemDetailManagerState();

  @override
  List<Object> get props => <Object>[];
}

class ItemDetailManagerInitialised extends ItemDetailManagerState {}

class ItemFieldUpdated extends ItemDetailManagerState {}

class ItemFieldNotUpdated extends ItemDetailManagerState {
  const ItemFieldNotUpdated(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemFieldNotUpdated { '
      'error: $error'
      ' }';
}

class ItemImageUpdated extends ItemDetailManagerState {}

class ItemImageNotUpdated extends ItemDetailManagerState {
  const ItemImageNotUpdated(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemImageNotUpdated { '
      'error: $error'
      ' }';
}

class ItemDetailNotLoaded extends ItemDetailManagerState {
  const ItemDetailNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemDetailNotLoaded { '
      'error: $error'
      ' }';
}
