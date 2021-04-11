import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemSearchState extends Equatable {
  const ItemSearchState();

  @override
  List<Object> get props => <Object>[];
}

class ItemSearchEmpty<T extends CollectionItem> extends ItemSearchState {
  // ignore: always_specify_types
  const ItemSearchEmpty([this.suggestions = const []]);

  final List<T> suggestions;

  @override
  List<Object> get props => <Object>[suggestions];

  @override
  String toString() => 'ItemSearchEmpty { '
      'suggestions: $suggestions'
      ' }';
}

class ItemSearchLoading extends ItemSearchState {}

class ItemSearchSuccess<T extends CollectionItem> extends ItemSearchState {
  const ItemSearchSuccess(this.results);

  final List<T> results;

  @override
  List<Object> get props => <Object>[results];

  @override
  String toString() => 'ItemSearchSuccess { '
      'results: $results'
      ' }';
}

class ItemSearchError extends ItemSearchState {
  const ItemSearchError(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemSearchError { '
      'error: $error'
      ' }';
}