import 'package:equatable/equatable.dart';

import 'package:game_collection/model/app_tab.dart';


class TabState extends Equatable {
  const TabState([this.mainTab = MainTab.game, this.gameTab = GameTab.all]);

  final MainTab mainTab;
  final GameTab gameTab;

  @override
  List<Object> get props => <Object>[mainTab, gameTab];

  @override
  String toString() => 'TabUpdated { '
      'mainTab: $mainTab, '
      'gameTab: $gameTab'
      ' }';
}