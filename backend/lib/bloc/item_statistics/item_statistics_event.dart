import 'package:equatable/equatable.dart';

abstract class ItemStatisticsEvent extends Equatable {
  const ItemStatisticsEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadGeneralItemStatistics extends ItemStatisticsEvent {}

class LoadYearItemStatistics extends ItemStatisticsEvent {
  const LoadYearItemStatistics(this.year);

  final int year;

  @override
  List<Object> get props => <Object>[year];

  @override
  String toString() => 'LoadYearItemStatistics { '
      'year: $year'
      ' }';
}
