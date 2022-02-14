import 'package:equatable/equatable.dart';

import 'package:backend/connector/provider_instance.dart';

abstract class RepositorySettingsDetailState extends Equatable {
  const RepositorySettingsDetailState();

  @override
  List<Object> get props => <Object>[];
}

class RepositorySettingsDetailLoading extends RepositorySettingsDetailState {}

class RepositorySettingsDetailLoaded extends RepositorySettingsDetailState {
  const RepositorySettingsDetailLoaded(this.instance);

  final ProviderInstance? instance;
}

class RepositorySettingsDetailNotLoaded extends RepositorySettingsDetailState {
  const RepositorySettingsDetailNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'RepositorySettingsDetailNotLoaded { '
      'error: $error'
      ' }';
}
