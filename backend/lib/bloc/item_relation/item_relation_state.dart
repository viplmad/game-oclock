import 'package:equatable/equatable.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

abstract class ItemRelationState extends Equatable {
  const ItemRelationState();

  @override
  List<Object> get props => <Object>[];
}

class ItemRelationLoading extends ItemRelationState {}

class ItemRelationLoaded<W extends PrimaryModel> extends ItemRelationState {
  const ItemRelationLoaded(this.otherItems);

  final List<W> otherItems;

  @override
  List<Object> get props => <Object>[otherItems];

  @override
  String toString() => 'ItemRelationLoaded { '
      'otherItems: $otherItems'
      ' }';
}

class ItemRelationNotLoaded extends ItemRelationState {
  const ItemRelationNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemRelationNotLoaded { '
      'error: $error'
      ' }';
}
