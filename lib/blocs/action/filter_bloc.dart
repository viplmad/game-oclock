import 'package:game_oclock/models/models.dart' show ListSearch, SearchDTO;

import 'action.dart'
    show ActionFinal, ActionSuccess, ConsumerActionBloc, FunctionActionBloc;

class SearchGetBloc extends FunctionActionBloc<String, ListSearch> {
  SearchGetBloc({required this.space});

  final String space;

  @override
  Future<ActionFinal<ListSearch>> doAction(
    final String event,
    final ListSearch? lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess(
      data: ListSearch(name: space + event, search: SearchDTO()),
    );
  }
}

class SearchCreateBloc extends ConsumerActionBloc<ListSearch> {
  SearchCreateBloc({required this.space});

  final String space;

  @override
  Future<ActionFinal<void>> doAction(
    final ListSearch event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 5));
    return ActionSuccess.empty();
  }
}

class SearchUpdateBloc extends ConsumerActionBloc<ListSearch> {
  SearchUpdateBloc({required this.space});

  final String space;

  @override
  Future<ActionFinal<void>> doAction(
    final ListSearch event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess.empty();
  }
}
