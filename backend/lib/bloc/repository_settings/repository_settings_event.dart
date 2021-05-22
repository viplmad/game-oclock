import 'package:equatable/equatable.dart';

import 'package:backend/model/repository_type.dart';


abstract class RepositorySettingsEvent extends Equatable {
  const RepositorySettingsEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadRepositorySettings extends RepositorySettingsEvent {}

class UpdateRepositorySettingsRadio extends RepositorySettingsEvent {
  const UpdateRepositorySettingsRadio(this.radio);

  final RepositoryType radio;

  @override
  List<Object> get props => <Object>[radio];

  @override
  String toString() => 'UpdateRepositorySettingsRadio { '
      'radio: $radio'
      ' }';
}