import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode, PrimaryModel;

abstract class ItemRelationManagerEvent extends Equatable {
  const ItemRelationManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class AddItemRelation<N extends Object> extends ItemRelationManagerEvent {
  const AddItemRelation(this.otherItem);

  final N otherItem;

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

class WarnItemRelationNotLoaded extends ItemRelationManagerEvent {
  const WarnItemRelationNotLoaded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'WarnItemRelationNotLoaded { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
