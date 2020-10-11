import 'package:equatable/equatable.dart';

import 'package:game_collection/model/repository_type.dart';


abstract class RepositorySettingsEvent extends Equatable {
  const RepositorySettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadRepositorySettings extends RepositorySettingsEvent {}

class UpdateRepositorySettingsRadio extends RepositorySettingsEvent {
  const UpdateRepositorySettingsRadio(this.radio);

  final RepositoryType radio;

  @override
  List<Object> get props => [radio];

  @override
  String toString() => 'UpdateRepositorySettingsRadio { '
      'radio: $radio'
      ' }';
}