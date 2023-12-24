import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadReview extends ReviewEvent {
  const LoadReview([this.year]);

  final int? year;

  @override
  List<Object> get props => <Object>[year ?? -1];

  @override
  String toString() => 'LoadReview { '
      'year: $year'
      ' }';
}

class ReloadReview extends ReviewEvent {}
