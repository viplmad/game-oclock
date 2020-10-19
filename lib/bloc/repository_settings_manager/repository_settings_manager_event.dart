import 'package:equatable/equatable.dart';

import 'package:game_collection/connector/item/sql/postgres/postgres_connector.dart';
import 'package:game_collection/connector/image/cloudinary/cloudinary_connector.dart';


abstract class RepositorySettingsManagerEvent extends Equatable {
  const RepositorySettingsManagerEvent();

  @override
  List<Object> get props => [];
}

class UpdateRemoteConnectionSettings extends RepositorySettingsManagerEvent {
  const UpdateRemoteConnectionSettings(this.postgresInstance, this.cloudinaryInstance);

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

/*class UpdateLocalConnectionSettings extends RepositorySettingsEvent {}*/