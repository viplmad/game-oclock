import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

abstract class ReviewManagerState extends Equatable {
  const ReviewManagerState();

  @override
  List<Object> get props => <Object>[];
}

class ReviewManagerInitialised extends ReviewManagerState {}

class ReviewNotLoaded extends ReviewManagerState {
  const ReviewNotLoaded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ReviewNotLoaded { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
