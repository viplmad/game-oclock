import 'package:equatable/equatable.dart';

import 'package:game_collection/model/entity.dart';


abstract class EntityListEvent extends Equatable {
  const EntityListEvent();

  @override
  List<Object> get props => [];
}

class LoadEntityList extends EntityListEvent {}

class AddEntity extends EntityListEvent {
  final Entity entity;

  const AddEntity(this.entity);

  @override
  List<Object> get props => [entity];

  @override
  String toString() => 'AddEntity { '
      'entity: $entity'
      ' }';
}

class DeleteEntity extends EntityListEvent {
  final Entity entity;

  const DeleteEntity(this.entity);

  @override
  List<Object> get props => [entity];

  @override
  String toString() => 'DeleteEntity { '
      'entity: $entity'
      ' }';
}

class UpdateEntityList extends EntityListEvent {
  final List<Entity> entities;

  const UpdateEntityList(this.entities);

  @override
  List<Object> get props => [entities];

  @override
  String toString() => 'UpdateEntityList { '
      'entities: $entities'
      ' }';
}