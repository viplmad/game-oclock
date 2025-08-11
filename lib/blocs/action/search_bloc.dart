import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show ListSearch;

import 'action.dart'
    show ActionFinal, ActionSuccess, ConsumerActionBloc, FunctionActionBloc;

class SearchGetBloc extends FunctionActionBloc<String, ListSearch> {
  SearchGetBloc({required this.space});

  final String space;

  @override
  Future<ActionFinal<ListSearch, String>> doAction(
    final String event,
    final ListSearch? lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess(
      data: mockSearch(name: space + event, filters: 3),
      event: event,
    );
  }
}

class SearchCreateBloc extends ConsumerActionBloc<ListSearch> {
  SearchCreateBloc({required this.space});

  final String space;

  @override
  Future<ActionFinal<void, ListSearch>> doAction(
    final ListSearch event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 5));
    return ActionSuccess.empty(event);
  }
}

class SearchUpdateBloc extends ConsumerActionBloc<ListSearch> {
  SearchUpdateBloc({required this.space});

  final String space;

  @override
  Future<ActionFinal<void, ListSearch>> doAction(
    final ListSearch event,
    final void lastData,
  ) async {
    print('${event.search.filter}');
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess.empty(event);
  }
}
