import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart';

import 'item_statistics.dart';


abstract class ItemStatisticsBloc<T extends Item, D extends ItemData<T>> extends Bloc<ItemStatisticsEvent, ItemStatisticsState> {
  ItemStatisticsBloc({
    required this.items,
  }) : super(ItemStatisticsLoading()) {

    on<LoadGeneralItemStatistics>(_mapLoadGeneralToState);
    on<LoadYearItemStatistics>(_mapLoadYearToState);

  }

  final List<T> items;

  void _mapLoadGeneralToState(LoadGeneralItemStatistics event, Emitter<ItemStatisticsState> emit) async {

    emit(
      ItemStatisticsLoading(),
    );

    try {

      final D itemData = await getGeneralItemData();
      emit(
        ItemGeneralStatisticsLoaded<T, D>(itemData),
      );

    } catch (e) {

      emit(
        ItemStatisticsNotLoaded(e.toString()),
      );

    }

  }

  void _mapLoadYearToState(LoadYearItemStatistics event, Emitter<ItemStatisticsState> emit) async {

    emit(
      ItemStatisticsLoading(),
    );

    try {

      final D itemData = await getItemData(event);
      emit(
        ItemYearStatisticsLoaded<T, D>(
          itemData,
          event.year,
        ),
      );

    } catch (e) {

      emit(
        ItemStatisticsNotLoaded(e.toString()),
      );

    }

  }

  @protected
  Future<D> getGeneralItemData();
  @protected
  Future<D> getItemData(LoadYearItemStatistics event);
}