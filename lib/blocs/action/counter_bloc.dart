import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:game_oclock/models/models.dart' show FormData;

import 'action.dart'
    show
        ActionFinal,
        ActionSuccess,
        ConsumerActionBloc,
        FunctionActionBloc,
        ProducerActionBloc;

class CounterProducerBloc extends ProducerActionBloc<int> {
  @override
  Future<ActionFinal<int>> doAction(
    final void event,
    final int? lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess(data: (lastData ?? 0) + 1);
  }
}

class CounterConsumerBloc extends ConsumerActionBloc<String> {
  @override
  Future<ActionFinal<void>> doAction(
    final String event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess.empty();
  }
}

class CounterFunctionBloc extends FunctionActionBloc<String, int> {
  @override
  Future<ActionFinal<int>> doAction(
    final String event,
    final int? lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess(data: (int.tryParse(event) ?? lastData ?? 0) + 1);
  }
}

class Counter extends Equatable {
  final String name;
  final int data;

  const Counter({required this.name, required this.data});

  @override
  List<Object?> get props => [name];
}

class CounterFormData extends FormData<Counter> {
  final TextEditingController name;
  final TextEditingController data;

  CounterFormData({required this.name, required this.data});

  @override
  void setValues(final Counter? counter) {
    name.value = name.value.copyWith(text: counter?.name);
    data.value = data.value.copyWith(
      text: counter == null ? null : '${counter.data}',
    );
  }
}

class CounterGetBloc extends FunctionActionBloc<String, Counter> {
  @override
  Future<ActionFinal<Counter>> doAction(
    final String event,
    final Counter? lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess(data: Counter(name: event, data: 0));
  }
}

class CounterCreateBloc extends ConsumerActionBloc<Counter> {
  @override
  Future<ActionFinal<void>> doAction(
    final Counter event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 5));
    return ActionSuccess.empty();
  }
}

class CounterUpdateBloc extends ConsumerActionBloc<Counter> {
  @override
  Future<ActionFinal<void>> doAction(
    final Counter event,
    final void lastData,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ActionSuccess.empty();
  }
}

class CounterSelectBloc extends FunctionActionBloc<Counter?, Counter?> {
  @override
  Future<ActionFinal<Counter?>> doAction(
    final Counter? event,
    final Counter? lastData,
  ) async {
    return ActionSuccess(data: event);
  }
}
