import 'package:equatable/equatable.dart';

import 'package:backend/model/repository_type.dart';
import 'package:backend/model/repository_tab.dart';


abstract class RepositorySettingsEvent extends Equatable {
  const RepositorySettingsEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadRepositorySettings extends RepositorySettingsEvent {}

class UpdateRepositoryTab extends RepositorySettingsEvent {
  const UpdateRepositoryTab(this.repositoryTab);

  final RepositoryTab repositoryTab;

  @override
  List<Object> get props => <Object>[repositoryTab];

  @override
  String toString() => 'UpdateRepositoryTab { '
      'repositoryTab: $repositoryTab'
      ' }';
}

class UpdateItemTypeSettingsRadio extends RepositorySettingsEvent {
  const UpdateItemTypeSettingsRadio(this.itemType);

  final ItemConnectorType itemType;

  @override
  List<Object> get props => <Object>[itemType];

  @override
  String toString() => 'UpdateItemTypeSettingsRadio { '
      'itemType: $itemType'
      ' }';
}

class UpdateImageTypeSettingsRadio extends RepositorySettingsEvent {
  const UpdateImageTypeSettingsRadio(this.imageType);

  final ImageConnectorType imageType;

  @override
  List<Object> get props => <Object>[imageType];

  @override
  String toString() => 'UpdateImageTypeSettingsRadio { '
      'itemType: $imageType'
      ' }';
}