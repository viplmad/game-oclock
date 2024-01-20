import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:game_oclock_client/api.dart'
    show ErrorCode, GamesFinishedReviewDTO, GamesPlayedReviewDTO;

import 'package:logic/service/service.dart'
    show GameFinishService, GameLogService, GameOClockService;
import 'package:logic/bloc/bloc_utils.dart';
import 'package:logic/utils/datetime_extension.dart';

import '../review_manager/review_manager.dart';
import 'review.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc({
    required GameOClockService collectionService,
    required this.managerBloc,
  })  : logService = collectionService.gameLogService,
        finishService = collectionService.gameFinishService,
        super(ReviewLoading()) {
    on<LoadReview>(_mapLoadToState);
    on<ReloadReview>(_mapReloadToState);
  }

  final GameLogService logService;
  final GameFinishService finishService;
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
      final int year = (state as ReviewLoaded).year;

      emit(
        ReviewLoading(),
      );

      await _mapAnyLoadToState(year, emit);
    } else if (state is! ReviewLoading) {
      await _mapAnyLoadToState(null, emit);
    }
  }

  Future<void> _mapAnyLoadToState(int? year, Emitter<ReviewState> emit) async {
    try {
      final int finalYear = year ?? DateTime.now().year;
      final GamesPlayedReviewDTO playedData = await _getPlayed(finalYear);
      final GamesFinishedReviewDTO finishedData = await _getFinished(finalYear);

      emit(
        ReviewLoaded(finalYear, playedData, finishedData),
      );
    } catch (e) {
      _handleError(e, emit);
    }
  }

  void _handleError(Object e, Emitter<ReviewState> emit) {
    BlocUtils.handleErrorWithManager(
      e,
      emit,
      managerBloc,
      () => ReviewError(),
      (ErrorCode error, String errorDescription) =>
          WarnReviewNotLoaded(error, errorDescription),
    );
  }

  Future<GamesPlayedReviewDTO> _getPlayed(int year) {
    final DateTime startDate = DateTime(year).atFirstDayOfYear();
    final DateTime endDate = startDate.atLastDayOfYear();

    return logService.getReview(startDate, endDate);
  }

  Future<GamesFinishedReviewDTO> _getFinished(int year) {
    final DateTime startDate = DateTime(year).atFirstDayOfYear();
    final DateTime endDate = startDate.atLastDayOfYear();

    return finishService.getReview(startDate, endDate);
  }
}
