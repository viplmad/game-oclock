import 'package:equatable/equatable.dart';

abstract class ItemDetailEvent extends Equatable {
  const ItemDetailEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadItem extends ItemDetailEvent {}

class ReloadItem extends ItemDetailEvent {
  // ignore: avoid_positional_boolean_parameters
  const ReloadItem([this.forceAdditionalFields = false]);

  final bool forceAdditionalFields;

  @override
  List<Object> get props => <Object>[forceAdditionalFields];

  @override
  String toString() => 'ReloadItem { '
      'forceAdditionalFields: $forceAdditionalFields'
      ' }';
}
