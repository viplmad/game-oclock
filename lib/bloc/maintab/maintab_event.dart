import 'package:equatable/equatable.dart';

import 'package:game_collection/model/app_tab.dart';


abstract class MainTabEvent extends Equatable {
  const MainTabEvent();

  @override
  List<Object> get props => [];
}

class UpdateMainTab extends MainTabEvent {
  final MainTab tab;

  const UpdateMainTab(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'UpdateMainTab { '
      'tab: $tab'
      ' }';
}