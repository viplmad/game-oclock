import 'package:equatable/equatable.dart';


abstract class ItemSearchEvent extends Equatable {
  const ItemSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchTextChanged extends ItemSearchEvent {
  const SearchTextChanged([this.query = '']);

  final String query;

  @override
  List<Object> get props => [query];

  @override
  String toString() => 'SearchTextChanged { '
      'query: $query'
      ' }';
}

class AddItem extends ItemSearchEvent {
  const AddItem([this.title]);

  final String title;

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'AddItem { '
      'title: $title'
      ' }';
}