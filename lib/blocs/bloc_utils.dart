import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

EventTransformer<T> debounce<T>(final Duration duration) {
  return (final events, final mapper) =>
      events.debounceTime(duration).flatMap(mapper);
}
