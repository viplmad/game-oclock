import 'package:bloc/bloc.dart';

import 'tab.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(const TabState()) {
    on<UpdateTab>(_mapUpdateTabToState);
    on<UpdateMainTab>(_mapUpdateMainTabToState);
    on<UpdateGameTab>(_mapUpdateGameTabToState);
  }

  void _mapUpdateTabToState(UpdateTab event, Emitter<TabState> emit) {
    emit(
      TabState(
        event.mainTab,
        event.gameTab,
      ),
    );
  }

  void _mapUpdateMainTabToState(UpdateMainTab event, Emitter<TabState> emit) {
    emit(
      TabState(
        event.mainTab,
        state.gameTab,
      ),
    );
  }

  void _mapUpdateGameTabToState(UpdateGameTab event, Emitter<TabState> emit) {
    emit(
      TabState(
        state.mainTab,
        event.gameTab,
      ),
    );
  }
}
