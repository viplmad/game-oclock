import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemStatisticsState extends Equatable {
  const ItemStatisticsState();

  @override
  List<Object> get props => <Object>[];
}

class ItemStatisticsLoading extends ItemStatisticsState {}

class ItemGeneralStatisticsLoaded<T extends CollectionItem, D extends ItemData<T>> extends ItemStatisticsState {
  const ItemGeneralStatisticsLoaded(this.itemData);

  final D itemData;

  @override
  List<Object> get props => <Object>[itemData];

  @override
  String toString() => 'ItemGeneralStatisticsLoaded { '
      'itemData: $itemData'
      ' }';
}

class ItemYearStatisticsLoaded<T extends CollectionItem, D extends ItemData<T>> extends ItemStatisticsState {
  const ItemYearStatisticsLoaded(this.itemData, this.year);

  final D itemData;
  final int year;

  @override
  List<Object> get props => <Object>[itemData, year];

  @override
  String toString() => 'ItemYearStatisticsLoaded { '
      'itemData: $itemData, '
      'year: $year'
      ' }';
}

class ItemStatisticsNotLoaded extends ItemStatisticsState {
  const ItemStatisticsNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ItemStatisticsNotLoaded { '
      'error: $error'
      ' }';
}