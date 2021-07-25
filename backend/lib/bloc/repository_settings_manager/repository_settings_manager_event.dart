import 'package:equatable/equatable.dart';

import 'package:backend/connector/connector.dart' show ProviderInstance;

import 'package:backend/model/repository_type.dart';


abstract class RepositorySettingsManagerEvent extends Equatable {
  const RepositorySettingsManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateConnectionSettings extends RepositorySettingsManagerEvent {
  const UpdateConnectionSettings(this.itemType, this.itemInstance, this.imageType, this.imageInstance);

  final ItemConnectorType itemType;
  final ProviderInstance itemInstance;
  final ImageConnectorType imageType;
  final ProviderInstance imageInstance;

  @override
  List<Object> get props => <Object>[itemInstance, imageInstance];

  @override
  String toString() => 'UpdatePostgresConnectionSettings { '
      'itemInstance: $itemInstance, '
      'imageInstance: $imageInstance'
      ' }';
}