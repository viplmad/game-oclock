import 'package:equatable/equatable.dart';

abstract class AboutEvent extends Equatable {
  const AboutEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadAbout extends AboutEvent {}
