import 'package:equatable/equatable.dart';

import 'package:game_collection/model/repository_radio.dart';


class RepositorySettingsRadioState extends Equatable {
  const RepositorySettingsRadioState([this.radio = RepositorySettingsRadio.Remote]);

  final RepositorySettingsRadio radio;

  @override
  List<Object> get props => [radio];

  @override
  String toString() => 'RepositorySettingsRadioUpdated { '
      'radio: $radio'
      ' }';
}