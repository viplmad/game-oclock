import 'package:equatable/equatable.dart';
import 'package:game_oclock/models/models.dart' show ListSearch;

sealed class ListEvent extends Equatable {
  const ListEvent();
}

final class ListLoaded extends ListEvent {
  final ListSearch search;

  const ListLoaded({required this.search});

  @override
  List<Object?> get props => [search];
}

final class ListQuicksearchChanged extends ListEvent {
  final String? quicksearch;

  const ListQuicksearchChanged({required this.quicksearch});

  @override
  List<Object?> get props => [quicksearch];
}

final class ListSearchChanged extends ListEvent {
  final ListSearch search;

  const ListSearchChanged({required this.search});

  @override
  List<Object?> get props => [search];
}

final class ListPageIncremented extends ListEvent {
  const ListPageIncremented();

  @override
  List<Object?> get props => [];
}
