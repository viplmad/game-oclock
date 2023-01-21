import 'package:equatable/equatable.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

abstract class ItemRelationManagerEvent extends Equatable {
  const ItemRelationManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class AddItemRelation<W extends PrimaryModel> extends ItemRelationManagerEvent {
  const AddItemRelation(this.otherItem);

  final W otherItem;

  @override
  List<Object> get props => <Object>[otherItem];

  @override
  String toString() => 'AddItemRelation { '
      'otherItem: $otherItem'
      ' }';
}

class DeleteItemRelation<W extends PrimaryModel>
    extends ItemRelationManagerEvent {
  const DeleteItemRelation(this.otherItem);

  final W otherItem;

  @override
  List<Object> get props => <Object>[otherItem];

  @override
  String toString() => 'DeleteItemRelation { '
      'otherItem: $otherItem'
      ' }';
}

class WarneItemRelationNotLoaded extends ItemRelationManagerEvent {
  const WarneItemRelationNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'WarneItemRelationNotLoaded { '
      'error: $error'
      ' }';
}
