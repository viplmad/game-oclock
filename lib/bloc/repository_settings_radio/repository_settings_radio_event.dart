import 'package:equatable/equatable.dart';

import 'package:game_collection/model/repository_radio.dart';


abstract class RepositorySettingsRadioEvent extends Equatable {
  const RepositorySettingsRadioEvent();

  @override
  List<Object> get props => [];
}

class UpdateRepositorySettingsRadio extends RepositorySettingsRadioEvent {
  const UpdateRepositorySettingsRadio(this.radio);

  final RepositorySettingsRadio radio;

  @override
  List<Object> get props => [radio];

  @override
  String toString() => 'UpdateRepositorySettingsRadio { '
      'radio: $radio'
      ' }';
}