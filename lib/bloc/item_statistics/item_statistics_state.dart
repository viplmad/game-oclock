import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemStatisticsState extends Equatable {
  const ItemStatisticsState();

  @override
  List<Object> get props => [];
}

class ItemStatisticsLoading extends ItemStatisticsState {}

class ItemGeneralStatisticsLoaded<D extends ItemData> extends ItemStatisticsState {
  const ItemGeneralStatisticsLoaded(this.itemData);

  final D itemData;

  @override
  List<Object> get props => [itemData];

  @override
  String toString() => 'ItemGeneralStatisticsLoaded { '
      'itemData: $itemData'
      ' }';
}

class ItemYearStatisticsLoaded<D extends ItemData> extends ItemStatisticsState {
  const ItemYearStatisticsLoaded(this.itemData, this.year);

  final D itemData;
  final int year;

  @override
  List<Object> get props => [itemData, year];

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
  List<Object> get props => [error];

  @override
  String toString() => 'ItemStatisticsNotLoaded { '
      'error: $error'
      ' }';
}