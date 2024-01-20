import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

abstract class ReviewManagerEvent extends Equatable {
  const ReviewManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class WarnReviewNotLoaded extends ReviewManagerEvent {
  const WarnReviewNotLoaded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'WarnReviewNotLoaded { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
