import 'package:equatable/equatable.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

abstract class ItemDetailState extends Equatable {
  const ItemDetailState();

  @override
  List<Object> get props => <Object>[];
}

class ItemLoading extends ItemDetailState {}

class ItemLoaded<T extends PrimaryModel> extends ItemDetailState {
  const ItemLoaded(this.item);

  final T item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'ItemLoaded { '
      'item: $item'
      ' }';
}

class ItemDetailError extends ItemDetailState {}
