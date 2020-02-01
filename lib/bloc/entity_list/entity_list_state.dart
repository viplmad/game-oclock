import 'package:equatable/equatable.dart';

import 'package:game_collection/model/entity.dart';


abstract class EntityListState extends Equatable {
  const EntityListState();

  @override
  List<Object> get props => [];
}

class EntityListLoading extends EntityListState {}

class EntityListLoaded extends EntityListState {
  final List<Entity> entities;

  const EntityListLoaded([this.entities = const []]);

  @override
  List<Object> get props => [entities];

  @override
  String toString() => 'EntityListLoaded { '
      'entities: $entities'
      ' }';
}

class EntityListNotLoaded extends EntityListState {
  final String error;

  const EntityListNotLoaded(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'EntityListNotLoaded { '
      'error: $error'
      ' }';
}