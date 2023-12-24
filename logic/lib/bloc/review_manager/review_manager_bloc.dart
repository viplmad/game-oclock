import 'package:bloc/bloc.dart';

import 'review_manager.dart';

class ReviewManagerBloc extends Bloc<ReviewManagerEvent, ReviewManagerState> {
  ReviewManagerBloc() : super(ReviewManagerInitialised()) {
    on<WarnReviewNotLoaded>(_mapWarnNotLoadedToState);
  }

  void _mapWarnNotLoadedToState(
    WarnReviewNotLoaded event,
    Emitter<ReviewManagerState> emit,
  ) {
    emit(ReviewNotLoaded(event.error));
  }
}
