import 'package:bloc/bloc.dart';

import 'calendar_manager.dart';

class CalendarManagerBloc
    extends Bloc<CalendarManagerEvent, CalendarManagerState> {
  CalendarManagerBloc() : super(CalendarManagerInitialised()) {
    on<WarnCalendarNotLoaded>(_mapWarnNotLoadedToState);
  }

  void _mapWarnNotLoadedToState(
    WarnCalendarNotLoaded event,
    Emitter<CalendarManagerState> emit,
  ) {
    emit(CalendarNotLoaded(event.error, event.errorDescription));

    emit(
      CalendarManagerInitialised(),
    );
  }
}
