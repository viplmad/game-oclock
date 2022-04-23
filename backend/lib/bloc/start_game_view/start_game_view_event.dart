import 'package:equatable/equatable.dart';

abstract class StartGameViewEvent extends Equatable {
  const StartGameViewEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadStartGameView extends StartGameViewEvent {}

class UpdateStartGameView extends StartGameViewEvent {
  const UpdateStartGameView(this.startViewIndex);

  final int startViewIndex;

  @override
  List<Object> get props => <Object>[startViewIndex];

  @override
  String toString() => 'UpdateStartGameView { '
      'startViewIndex: $startViewIndex'
      ' }';
}
