import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart' show ItemStatistics;
import 'package:backend/repository/repository.dart' show StatisticsRepository;

import '../bloc_utils.dart';
import 'item_statistics.dart';

abstract class ItemStatisticsBloc<GS extends ItemStatistics,
        YS extends ItemStatistics, R extends StatisticsRepository>
    extends Bloc<ItemStatisticsEvent, ItemStatisticsState> {
  ItemStatisticsBloc({
    required this.viewIndex,
    required this.viewYear,
    required this.repository,
  }) : super(ItemStatisticsLoading()) {
    on<LoadGeneralItemStatistics>(_mapLoadGeneralToState);
    on<LoadYearItemStatistics>(_mapLoadYearToState);
  }

  final int viewIndex;
  final int? viewYear;
  final R repository;

  Future<void> _checkConnection(Emitter<ItemStatisticsState> emit) async {
    await BlocUtils.checkConnection<ItemStatisticsState,
        ItemStatisticsNotLoaded>(
      repository,
      emit,
      (final String error) => ItemStatisticsNotLoaded(error),
    );
  }

  void _mapLoadGeneralToState(
    LoadGeneralItemStatistics event,
    Emitter<ItemStatisticsState> emit,
  ) async {
    await _checkConnection(emit);

    emit(
      ItemStatisticsLoading(),
    );

    try {
      final GS itemData = await getGeneralItemData();
      emit(
        ItemGeneralStatisticsLoaded<GS>(itemData),
      );
    } catch (e) {
      emit(
        ItemStatisticsNotLoaded(e.toString()),
      );
    }
  }

  void _mapLoadYearToState(
    LoadYearItemStatistics event,
    Emitter<ItemStatisticsState> emit,
  ) async {
    await _checkConnection(emit);

    emit(
      ItemStatisticsLoading(),
    );

    try {
      final YS itemData = await getYearItemData(event);
      emit(
        ItemYearStatisticsLoaded<YS>(
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
  Future<GS> getGeneralItemData();
  @protected
  Future<YS> getYearItemData(LoadYearItemStatistics event);
}
