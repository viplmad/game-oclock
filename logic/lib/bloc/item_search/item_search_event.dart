import 'package:equatable/equatable.dart';

abstract class ItemSearchEvent extends Equatable {
  const ItemSearchEvent();

  @override
  List<Object> get props => <Object>[];
}

class ReloadItemSearch extends ItemSearchEvent {}

class SearchTextChanged extends ItemSearchEvent {
  const SearchTextChanged([this.query = '']);

  final String query;

  @override
  List<Object> get props => <Object>[query];

  @override
  String toString() => 'SearchTextChanged { '
      'query: $query'
      ' }';
}
