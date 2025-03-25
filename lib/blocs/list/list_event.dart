import 'package:equatable/equatable.dart';
import 'package:game_oclock/models/models.dart'
    show FilterDTO, SearchDTO, SortDTO;

sealed class ListEvent extends Equatable {
  const ListEvent();
}

final class ListLoaded extends ListEvent {
  final SearchDTO search;

  const ListLoaded({required this.search});

  @override
  List<Object?> get props => [search];
}

final class ListFilterChanged extends ListEvent {
  final List<FilterDTO>? filter;
  final List<SortDTO>? sort;

  const ListFilterChanged({required this.filter, required this.sort});

  @override
  List<Object?> get props => [filter, sort];
}

final class ListPageIncremented extends ListEvent {
  const ListPageIncremented();

  @override
  List<Object?> get props => [];
}
