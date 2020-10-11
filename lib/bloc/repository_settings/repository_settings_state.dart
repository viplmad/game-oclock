import 'package:equatable/equatable.dart';

import 'package:game_collection/connector/item/sql/postgres/postgres_connector.dart';
import 'package:game_collection/connector/image/cloudinary/cloudinary_connector.dart';


abstract class RepositorySettingsState extends Equatable {
  const RepositorySettingsState();

  @override
  List<Object> get props => [];
}

class RepositorySettingsLoading extends RepositorySettingsState {}

class EmptyRepositorySettings extends RepositorySettingsState {}

class RemoteRepositorySettingsLoaded extends RepositorySettingsState {
  RemoteRepositorySettingsLoaded(this.postgresInstance, this.cloudinaryInstance);

  final PostgresInstance postgresInstance;
  final CloudinaryInstance cloudinaryInstance;

  @override
  List<Object> get props => [postgresInstance, cloudinaryInstance];

  @override
  String toString() => 'UpdatePostgresConnectionSettings { '
      'postgres instance: $postgresInstance, '
      'cloudinary instance: $cloudinaryInstance'
      ' }';
}

/*class LocalRepositorySettingsLoaded extends RepositorySettingsState {}*/

class RepositorySettingsUpdated extends RepositorySettingsState {}

class RepositorySettingsNotUpdated extends RepositorySettingsState {
  const RepositorySettingsNotUpdated(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'RepositorySettingsNotUpdated { '
      'error: $error'
      ' }';
}