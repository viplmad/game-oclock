import 'package:equatable/equatable.dart';

import 'package:logic/model/model.dart' show MainTab;

abstract class TabEvent extends Equatable {
  const TabEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateTab extends TabEvent {
  const UpdateTab(this.tab);

  final MainTab tab;

  @override
  List<Object> get props => <Object>[tab];

  @override
  String toString() => 'UpdateTab { '
      'mainTab: $tab'
      ' }';
}
