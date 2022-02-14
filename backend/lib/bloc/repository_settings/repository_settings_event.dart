import 'package:equatable/equatable.dart';

import 'package:backend/model/repository_type.dart';

abstract class RepositorySettingsEvent extends Equatable {
  const RepositorySettingsEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadRepositorySettings extends RepositorySettingsEvent {}

class UpdateRepositorySettings extends RepositorySettingsEvent {
  const UpdateRepositorySettings(
    this.savedItemConnection,
    this.savedImageConnection,
  );

  final ItemConnectorType? savedItemConnection;
  final ImageConnectorType? savedImageConnection;

  @override
  List<Object> get props =>
      <Object>[savedItemConnection ?? '', savedImageConnection ?? ''];

  @override
  String toString() => 'UpdateRepositorySettings { '
      'savedItemConnection: $savedItemConnection, '
      'savedImageConnection: $savedImageConnection'
      ' }';
}
