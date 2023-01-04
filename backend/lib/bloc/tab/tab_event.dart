import 'package:equatable/equatable.dart';

import 'package:backend/model/app_tab.dart';

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