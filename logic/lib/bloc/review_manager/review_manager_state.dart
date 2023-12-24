import 'package:equatable/equatable.dart';

abstract class ReviewManagerState extends Equatable {
  const ReviewManagerState();

  @override
  List<Object> get props => <Object>[];
}

class ReviewManagerInitialised extends ReviewManagerState {}

class ReviewNotLoaded extends ReviewManagerState {
  const ReviewNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ReviewNotLoaded { '
      'error: $error'
      ' }';
}
