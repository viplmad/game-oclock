import 'package:equatable/equatable.dart';

import 'package:backend/model/app_tab.dart';


abstract class TabEvent extends Equatable {
  const TabEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateTab extends TabEvent {
  const UpdateTab(this.mainTab, this.gameTab);

  final MainTab mainTab;
  final GameTab gameTab;

  @override
  List<Object> get props => <Object>[mainTab, gameTab];

  @override
  String toString() => 'UpdateTab { '
      'mainTab: $mainTab, '
      'gameTab: $gameTab'
      ' }';
}

class UpdateMainTab extends TabEvent {
  const UpdateMainTab(this.mainTab);

  final MainTab mainTab;

  @override
  List<Object> get props => <Object>[mainTab];

  @override
  String toString() => 'UpdateMainTab { '
      'mainTab: $mainTab'
      ' }';
}

class UpdateGameTab extends TabEvent {
  const UpdateGameTab(this.gameTab);

  final GameTab gameTab;

  @override
  List<Object> get props => <Object>[gameTab];

  @override
  String toString() => 'UpdateGameTab { '
      'gameTab: $gameTab'
      ' }';
}