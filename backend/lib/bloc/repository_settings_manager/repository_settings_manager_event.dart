import 'package:equatable/equatable.dart';

import 'package:backend/connector/connector.dart';


abstract class RepositorySettingsManagerEvent extends Equatable {
  const RepositorySettingsManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateConnectionSettings extends RepositorySettingsManagerEvent {
  const UpdateConnectionSettings(this.postgresInstance, this.cloudinaryInstance);

  final PostgresInstance postgresInstance;
  final CloudinaryInstance cloudinaryInstance;

  @override
  List<Object> get props => <Object>[postgresInstance, cloudinaryInstance];

  @override
  String toString() => 'UpdatePostgresConnectionSettings { '
      'postgres instance: $postgresInstance, '
      'cloudinary instance: $cloudinaryInstance'
      ' }';
}