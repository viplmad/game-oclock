import 'package:equatable/equatable.dart';

import 'package:backend/model/repository_type.dart';

abstract class RepositorySettingsState extends Equatable {
  const RepositorySettingsState();

  @override
  List<Object> get props => <Object>[];
}

class RepositorySettingsLoading extends RepositorySettingsState {}

class RepositorySettingsLoaded extends RepositorySettingsState {
  const RepositorySettingsLoaded([
    this.activeItemConnection,
    this.activeImageConnection,
  ]) : ready = activeItemConnection != null;

  final ItemConnectorType? activeItemConnection;
  final ImageConnectorType? activeImageConnection;
  final bool ready;

  @override
  List<Object> get props =>
      <Object>[activeItemConnection ?? '', activeImageConnection ?? ''];

  @override
  String toString() => 'RepositorySettingsLoaded { '
      'savedItemConnection: $activeItemConnection, '
      'savedImageConnection: $activeImageConnection, '
      'ready: $ready'
      ' }';
}

class RepositorySettingsNotLoaded extends RepositorySettingsState {
  const RepositorySettingsNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'RepositorySettingsNotLoaded { '
      'error: $error'
      ' }';
}
