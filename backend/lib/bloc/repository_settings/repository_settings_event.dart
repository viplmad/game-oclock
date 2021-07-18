import 'package:equatable/equatable.dart';


abstract class RepositorySettingsEvent extends Equatable {
  const RepositorySettingsEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadRepositorySettings extends RepositorySettingsEvent {}