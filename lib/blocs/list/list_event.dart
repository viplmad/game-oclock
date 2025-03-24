import 'package:game_oclock/models/models.dart'
    show FilterDTO, SearchDTO, SortDTO;

sealed class ListEvent {}

final class ListLoaded extends ListEvent {
  final SearchDTO search;

  ListLoaded({required this.search});
}

final class ListFilterChanged extends ListEvent {
  final List<FilterDTO>? filter;
  final List<SortDTO>? sort;

  ListFilterChanged({required this.filter, required this.sort});
}

final class ListPageIncremented extends ListEvent {}
