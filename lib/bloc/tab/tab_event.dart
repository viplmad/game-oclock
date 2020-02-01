import 'package:equatable/equatable.dart';

import 'package:game_collection/model/app_tab.dart';


abstract class TabEvent extends Equatable {
  const TabEvent();

  @override
  List<Object> get props => [];
}

class UpdateTab extends TabEvent {
  final AppTab tab;

  const UpdateTab(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'UpdateTab { '
      'tab: $tab'
      ' }';
}