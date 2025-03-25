import 'package:equatable/equatable.dart';
import 'package:game_oclock/models/models.dart'
    show ErrorDTO, PageResultDTO, SearchDTO;

sealed class ListState<T> extends Equatable {
  const ListState();
}

final class ListInitial<T> extends ListState<T> {
  const ListInitial();

  @override
  List<Object?> get props => [];
}

final class ListLoadInProgress<T> extends ListState<T> {
  final PageResultDTO<T>? data;
  final SearchDTO? search;

  const ListLoadInProgress({required this.data, required this.search});

  @override
  List<Object?> get props => [data, search];
}

sealed class ListFinal<T> extends ListState<T> {
  final PageResultDTO<T> data;
  final SearchDTO search;

  const ListFinal({required this.data, required this.search});

  @override
  List<Object?> get props => [data, search];
}

final class ListLoadSuccess<T> extends ListFinal<T> {
  const ListLoadSuccess({required super.data, required super.search});
}

final class ListLoadFailure<T> extends ListFinal<T> {
  final ErrorDTO error;

  const ListLoadFailure({
    required this.error,
    required super.data,
    required super.search,
  });

  @override
  List<Object?> get props => [error, ...super.props];
}
