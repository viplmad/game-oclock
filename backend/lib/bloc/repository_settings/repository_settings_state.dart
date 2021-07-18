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

class RepositorySettingsLoaded extends RepositorySettingsState {
  RepositorySettingsLoaded(this.itemType, this.itemConnector, this.imageType, this.imageConnector);

  final ItemConnectorType itemType;
  final ItemConnector itemConnector;
  final ImageConnectorType imageType;
  final ImageConnector imageConnector;

  @override
  List<Object> get props => <Object>[itemConnector, imageConnector];

  @override
  String toString() => 'RepositorySettingsLoaded { '
      'itemConnector: $itemConnector, '
      'imageConnector: $imageConnector'
      ' }';
}