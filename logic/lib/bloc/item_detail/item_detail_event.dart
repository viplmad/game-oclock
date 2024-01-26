import 'package:equatable/equatable.dart';

abstract class ItemDetailEvent extends Equatable {
  const ItemDetailEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadItem extends ItemDetailEvent {}

class ReloadItem extends ItemDetailEvent {}
