import 'package:equatable/equatable.dart';

import 'package:backend/model/repository_type.dart';


abstract class RepositorySettingsManagerState extends Equatable {
  const RepositorySettingsManagerState();

  @override
  List<Object> get props => <Object>[];
}

class Initialised extends RepositorySettingsManagerState {}

class ItemConnectionSettingsUpdated extends RepositorySettingsManagerState {
  const ItemConnectionSettingsUpdated(this.type);

  final ItemConnectorType type;

  @override
  List<Object> get props => <Object>[type];

  @override
  String toString() => 'ItemConnectionSettingsUpdated { '
      'type: $type'
      ' }';
}

class ImageConnectionSettingsUpdated extends RepositorySettingsManagerState {
  const ImageConnectionSettingsUpdated(this.type);

  final ImageConnectorType type;

  @override
  List<Object> get props => <Object>[type];

  @override
  String toString() => 'ImageConnectionSettingsUpdated { '
      'type: $type'
      ' }';
}

class RepositorySettingsNotUpdated extends RepositorySettingsManagerState {
  const RepositorySettingsNotUpdated(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'RepositorySettingsNotUpdated { '
      'error: $error'
      ' }';
}

class ItemConnectionSettingsDeleted extends RepositorySettingsManagerState {}

class ImageConnectionSettingsDeleted extends RepositorySettingsManagerState {}

class RepositorySettingsNotDeleted extends RepositorySettingsManagerState {
  const RepositorySettingsNotDeleted(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'RepositorySettingsNotDeleted { '
      'error: $error'
      ' }';
}