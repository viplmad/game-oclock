import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemSearchState extends Equatable {
  const ItemSearchState();

  @override
  List<Object> get props => [];
}

class ItemSearchEmpty<T extends CollectionItem> extends ItemSearchState {
  ItemSearchEmpty([this.suggestions = const []]);

  final List<T> suggestions;

  @override
  List<Object> get props => [suggestions];

  @override
  String toString() => 'ItemSearchEmpty { '
      'suggestions: $suggestions'
      ' }';
}

class ItemSearchLoading extends ItemSearchState {}

class ItemSearchSuccess<T extends CollectionItem> extends ItemSearchState {
  ItemSearchSuccess(this.results);

  final List<T> results;

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

class ItemAdded<T extends CollectionItem> extends ItemSearchState {
  const ItemAdded(this.item);

  final T item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemAdded { '
      'item: $item'
      ' }';
}

class ItemNotAdded extends ItemSearchState {
  const ItemNotAdded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ItemNotAdded { '
      'error: $error'
      ' }';
}