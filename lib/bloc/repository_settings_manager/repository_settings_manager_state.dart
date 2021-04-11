import 'package:equatable/equatable.dart';


abstract class RepositorySettingsManagerState extends Equatable {
  const RepositorySettingsManagerState();

  @override
  List<Object> get props => <Object>[];
}

class Initialised extends RepositorySettingsManagerState {}

class RepositorySettingsUpdated extends RepositorySettingsManagerState {}

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