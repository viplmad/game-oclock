import 'package:equatable/equatable.dart';

import 'package:backend/connector/connector.dart' show ProviderInstance;

import 'package:backend/model/repository_tab.dart';
import 'package:backend/model/repository_type.dart';


abstract class RepositorySettingsState extends Equatable {
  const RepositorySettingsState([this.repositoryTab = RepositoryTab.Item]);

  final RepositoryTab repositoryTab; // TODO move to own bloc only for tab similar to TabBloc

  @override
  List<Object> get props => <Object>[];
}

class RepositorySettingsLoading extends RepositorySettingsState {}

class EmptyRepositorySettings extends RepositorySettingsState {}

class RepositorySettingsLoaded extends RepositorySettingsState {
  RepositorySettingsLoaded(this.itemType, this.itemInstance, this.imageType, this.imageInstance);

  final ItemConnectorType itemType;
  final ProviderInstance itemInstance;
  final ImageConnectorType imageType;
  final ProviderInstance imageInstance;

  @override
  List<Object> get props => <Object>[itemInstance, imageInstance];

  @override
  String toString() => 'RepositorySettingsLoaded { '
      'itemConnector: $itemInstance, '
      'imageConnector: $imageInstance'
      ' }';
}