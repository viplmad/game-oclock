import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemSearchState extends Equatable {
  const ItemSearchState();

  @override
  List<Object> get props => [];
}

class ItemSearchEmpty extends ItemSearchState {
  ItemSearchEmpty([this.suggestions = const []]);

  final List<CollectionItem> suggestions;

  @override
  List<Object> get props => [suggestions];

  @override
  String toString() => 'ItemSearchEmpty { '
      'suggestions: $suggestions'
      ' }';
}

class ItemSearchLoading extends ItemSearchState {}

class ItemSearchSuccess extends ItemSearchState {
  ItemSearchSuccess(this.results);

  final List<CollectionItem> results;

  @override
  List<Object> get props => [results];

  @override
  String toString() => 'ItemSearchSuccess { '
      'results: $results'
      ' }';
}

class ItemSearchError extends ItemSearchState {
  ItemSearchError(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemSearchError { '
      'error: $error'
      ' }';
}