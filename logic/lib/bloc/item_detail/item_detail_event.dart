import 'package:equatable/equatable.dart';

abstract class ItemDetailEvent extends Equatable {
  const ItemDetailEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadItem extends ItemDetailEvent {}

class ReloadItem extends ItemDetailEvent {
  const ReloadItem({this.silent = false});

  final bool silent;

  @override
  List<Object> get props => <Object>[silent];

  @override
  String toString() => 'ReloadItem { '
      'silent: $silent'
      ' }';
}
