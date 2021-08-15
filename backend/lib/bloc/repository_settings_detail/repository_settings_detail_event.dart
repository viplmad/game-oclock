import 'package:equatable/equatable.dart';

import 'package:backend/model/repository_type.dart';


abstract class RepositorySettingsDetailEvent extends Equatable {
  const RepositorySettingsDetailEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadItemSettingsDetail extends RepositorySettingsDetailEvent {
  const LoadItemSettingsDetail(this.itemType);

  final ItemConnectorType itemType;

  @override
  List<Object> get props => <Object>[itemType];

  @override
  String toString() => 'LoadItemSettingsDetail { '
      'itemType: $itemType'
      ' }';
}

class LoadImageSettingsDetail extends RepositorySettingsDetailEvent {
  const LoadImageSettingsDetail(this.imageType);

  final ImageConnectorType imageType;

  @override
  List<Object> get props => <Object>[imageType];

  @override
  String toString() => 'LoadImageSettingsDetail { '
      'imageType: $imageType'
      ' }';
}