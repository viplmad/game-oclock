import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode, PrimaryModel;

abstract class ItemSearchState extends Equatable {
  const ItemSearchState();

  @override
  List<Object> get props => <Object>[];
}

class ItemSearchEmpty<T extends PrimaryModel> extends ItemSearchState {
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

class ItemSearchSuccess<T extends PrimaryModel> extends ItemSearchState {
  const ItemSearchSuccess(this.query, this.results);

  final String query;
  final List<T> results;

  @override
  List<Object> get props => <Object>[query, results];

  @override
  String toString() => 'ItemSearchSuccess { '
      'query: $query, '
      'results: $results'
      ' }';
}

class ItemSearchError extends ItemSearchState {
  const ItemSearchError(this.query, this.error, this.errorDescription);

  final String query;
  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ItemSearchError { '
      'query: $query, '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
