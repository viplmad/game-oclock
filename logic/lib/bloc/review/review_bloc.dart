import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show GamesWithLogsExtendedDTO;

import 'package:logic/service/service.dart'
    show GameOClockService, GameLogService;
import 'package:logic/utils/datetime_extension.dart';

import '../review_manager/review_manager.dart';
import 'review.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc({
    required GameOClockService collectionService,
    required this.managerBloc,
  })  : service = collectionService.gameLogService,
        super(ReviewLoading()) {
    on<LoadReview>(_mapLoadToState);
    on<ReloadReview>(_mapReloadToState);
  }

  final GameLogService service;
  final ReviewManagerBloc managerBloc;

  void _mapLoadToState(LoadReview event, Emitter<ReviewState> emit) async {
    emit(
      ReviewLoading(),
    );

    await _mapAnyLoadToState(event.year, emit);
  }

  void _mapReloadToState(
    ReloadReview event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is ReviewLoaded) {
      final int previousYear = (state as ReviewLoaded).year;

      _mapAnyLoadToState(previousYear, emit);
    } else {
      // TODO: careful if still loading
      await _mapAnyLoadToState(null, emit);
    }
  }

  Future<void> _mapAnyLoadToState(int? year, Emitter<ReviewState> emit) async {
    try {
      final int finalYear = year ?? DateTime.now().year;
      final GamesWithLogsExtendedDTO data = await _get(finalYear);

      emit(
        ReviewLoaded(finalYear, data),
      );
    } catch (e) {
      managerBloc.add(WarnReviewNotLoaded(e.toString()));
      emit(
        ReviewError(),
      );
    }
  }

  Future<GamesWithLogsExtendedDTO> _get(int year) {
    final DateTime startDate = DateTime(year).atFirstDayOfYear();
    final DateTime endDate = startDate.atLastDayOfYear();

    return service.getReview(startDate, endDate);
  }
}
