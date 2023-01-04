import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart' show MainTab;

import 'tab.dart';

class TabBloc extends Bloc<TabEvent, MainTab> {
  TabBloc() : super(MainTab.game) {
    on<UpdateTab>(_mapUpdateTabToState);
  }

  void _mapUpdateTabToState(UpdateTab event, Emitter<MainTab> emit) {
    emit(
      event.tab,
    );
  }
}
