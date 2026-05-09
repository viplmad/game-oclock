import 'package:equatable/equatable.dart';
import 'package:game_oclock/models/models.dart' show ErrorDTO;
import 'package:game_oclock_client/api.dart';

sealed class ListState<T> extends Equatable {
  const ListState();
}

final class ListInitial<T> extends ListState<T> {
  const ListInitial();

  @override
  List<Object?> get props => [];
}

final class ListLoadInProgress<T> extends ListState<T> {
  final List<T>? data;
  final ListSearchDTO? search;
  final String? quicksearch;

  const ListLoadInProgress({
    required this.data,
    required this.search,
    required this.quicksearch,
  });

  @override
  List<Object?> get props => [data, search, quicksearch];
}

sealed class ListFinal<T> extends ListState<T> {
  final List<T> data;
  final int total;
  final ListSearchDTO search;
  final String? quicksearch;

  const ListFinal({
    required this.data,
    required this.total,
    required this.search,
    required this.quicksearch,
  });

  @override
  List<Object?> get props => [search, quicksearch];
}

final class ListLoadSuccess<T> extends ListFinal<T> {
  const ListLoadSuccess({
    required super.data,
    required super.total,
    required super.search,
    required super.quicksearch,
  });
}

final class ListLoadFailure<T> extends ListFinal<T> {
  final ErrorDTO error;

  const ListLoadFailure({
    required this.error,
    required super.data,
    required super.total,
    required super.search,
    required super.quicksearch,
  });

  @override
  List<Object?> get props => [error, ...super.props];
}
