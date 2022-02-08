import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart' show ItemStatistics;


abstract class ItemStatisticsState extends Equatable {
  const ItemStatisticsState();

  @override
  List<Object> get props => <Object>[];
}

class ItemStatisticsLoading extends ItemStatisticsState {}

class ItemGeneralStatisticsLoaded<GS extends ItemStatistics> extends ItemStatisticsState {
  const ItemGeneralStatisticsLoaded(this.itemData);

  final GS itemData;

  @override
  List<Object> get props => <Object>[itemData];

  @override
  String toString() => 'ItemGeneralStatisticsLoaded { '
      'itemData: $itemData'
      ' }';
}

class ItemYearStatisticsLoaded<YS extends ItemStatistics> extends ItemStatisticsState {
  const ItemYearStatisticsLoaded(this.itemData, this.year);

  final YS itemData;
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