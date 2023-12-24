import 'package:equatable/equatable.dart';

abstract class ReviewManagerEvent extends Equatable {
  const ReviewManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class WarnReviewNotLoaded extends ReviewManagerEvent {
  const WarnReviewNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'WarnReviewNotLoaded { '
      'error: $error'
      ' }';
}
