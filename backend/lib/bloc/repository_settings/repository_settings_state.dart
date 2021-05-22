import 'package:equatable/equatable.dart';

import 'package:backend/connector/connector.dart';

import 'package:backend/model/repository_type.dart';


abstract class RepositorySettingsState extends Equatable {
  const RepositorySettingsState();

  @override
  List<Object> get props => <Object>[];
}

class RepositorySettingsLoading extends RepositorySettingsState {}

class EmptyRepositorySettings extends RepositorySettingsState {}

class RemoteRepositorySettingsLoaded extends RepositorySettingsState {
  const RemoteRepositorySettingsLoaded(this.postgresInstance, this.cloudinaryInstance);

  final PostgresInstance postgresInstance;
  final CloudinaryInstance cloudinaryInstance;

  final RepositoryType radio = RepositoryType.Remote;

  @override
  List<Object> get props => <Object>[postgresInstance, cloudinaryInstance];

  @override
  String toString() => 'UpdatePostgresConnectionSettings { '
      'postgres instance: $postgresInstance, '
      'cloudinary instance: $cloudinaryInstance'
      ' }';
}

/*class LocalRepositorySettingsLoaded extends RepositorySettingsState {}*/