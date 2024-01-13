import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart'
    show GamesFinishedReviewDTO, GamesPlayedReviewDTO;

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => <Object>[];
}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  const ReviewLoaded(this.year, this.playedData, this.finishedData);

  final int year;
  final GamesPlayedReviewDTO playedData;
  final GamesFinishedReviewDTO finishedData;

  @override
  List<Object> get props => <Object>[year, playedData, finishedData];

  @override
  String toString() => 'ReviewLoaded { '
      'year: $year, '
      'playedData: $playedData, '
      'finishedData: $finishedData'
      ' }';
}

class ReviewError extends ReviewState {}
