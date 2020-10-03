import 'dart:async';

import 'package:bloc/bloc.dart';

import 'tab.dart';


class TabBloc extends Bloc<TabEvent, TabState> {

  @override
  TabState get initialState => TabState();

  @override
  Stream<TabState> mapEventToState(TabEvent event) async* {

    if(event is UpdateTab) {

      yield* _mapUpdateTabToState(event);

    } else if(event is UpdateMainTab) {

      yield* _mapUpdateMainTabToState(event);

    } else if(event is UpdateGameTab) {

      yield* _mapUpdateGameTabToState(event);

    }

  }

  Stream<TabState> _mapUpdateTabToState(UpdateTab event) async* {

    yield TabState(
      event.mainTab,
      event.gameTab,
    );

  }

  Stream<TabState> _mapUpdateMainTabToState(UpdateMainTab event) async* {

    yield TabState(
      event.mainTab,
      state.gameTab,
    );

  }

  Stream<TabState> _mapUpdateGameTabToState(UpdateGameTab event) async* {

    yield TabState(
      state.mainTab,
      event.gameTab,
    );

  }

}