import 'package:equatable/equatable.dart';

import 'package:game_collection_client/api.dart' show GamesWithLogsExtendedDTO;

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => <Object>[];
}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  const ReviewLoaded(this.year, this.data);

  final int year;
  final GamesWithLogsExtendedDTO data;

  @override
  List<Object> get props => <Object>[data];

  @override
  String toString() => 'ReviewLoaded { '
      'data: $data'
      ' }';
}

class ReviewError extends ReviewState {}
