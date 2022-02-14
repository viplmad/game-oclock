import 'package:equatable/equatable.dart';

import 'package:backend/connector/connector.dart' show ProviderInstance;

import 'package:backend/model/repository_type.dart';

abstract class RepositorySettingsManagerEvent extends Equatable {
  const RepositorySettingsManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateItemConnectionSettings extends RepositorySettingsManagerEvent {
  const UpdateItemConnectionSettings(this.type, this.instance);

  final ItemConnectorType type;
  final ProviderInstance instance;

  @override
  List<Object> get props => <Object>[instance];

  @override
  String toString() => 'UpdateItemConnectionSettings { '
      'instance: $instance'
      ' }';
}

class UpdateImageConnectionSettings extends RepositorySettingsManagerEvent {
  const UpdateImageConnectionSettings(this.type, this.instance);

  final ImageConnectorType type;
  final ProviderInstance instance;

  @override
  List<Object> get props => <Object>[instance];

  @override
  String toString() => 'UpdateImageConnectionSettings { '
      'instance: $instance'
      ' }';
}

class DeleteItemConnectionSettings extends RepositorySettingsManagerEvent {}

class DeleteImageConnectionSettings extends RepositorySettingsManagerEvent {}
