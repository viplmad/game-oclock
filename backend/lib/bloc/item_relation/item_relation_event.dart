import 'package:equatable/equatable.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

abstract class ItemRelationEvent extends Equatable {
  const ItemRelationEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadItemRelation extends ItemRelationEvent {}

class ReloadItemRelation extends ItemRelationEvent {}

class UpdateItemRelation<W extends PrimaryModel> extends ItemRelationEvent {
  const UpdateItemRelation(this.otherItems);

  final List<W> otherItems;

  @override
  List<Object> get props => <Object>[otherItems];

  @override
  String toString() => 'UpdateItemRelation { '
      'otherItems: $otherItems'
      ' }';
}
