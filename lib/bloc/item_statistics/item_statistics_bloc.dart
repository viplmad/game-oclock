import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/model/model.dart';

import 'item_statistics.dart';


abstract class ItemStatisticsBloc<T extends CollectionItem, D extends ItemData> extends Bloc<ItemStatisticsEvent, ItemStatisticsState> {

  ItemStatisticsBloc({@required this.items}) : super(ItemStatisticsLoading());

  final List<T> items;

  @override
  Stream<ItemStatisticsState> mapEventToState(ItemStatisticsEvent event) async* {

    if(event is LoadGeneralItemStatistics) {

      yield* _mapLoadGeneralToState();

    } else if(event is LoadYearItemStatistics) {

      yield* _mapLoadYearToState(event);

    }

  }

  Stream<ItemStatisticsState> _mapLoadGeneralToState() async* {

    yield ItemStatisticsLoading();

    try {

      final D itemData = await getGeneralItemData();
      yield ItemGeneralStatisticsLoaded<D>(itemData);

    } catch (e) {

      yield ItemStatisticsNotLoaded(e.toString());

    }

  }

  Stream<ItemStatisticsState> _mapLoadYearToState(LoadYearItemStatistics event) async* {

    yield ItemStatisticsLoading();

    try {

      final D itemData = await getItemData(event);
      yield ItemYearStatisticsLoaded<D>(itemData, event.year);

    } catch (e) {

      yield ItemStatisticsNotLoaded(e.toString());

    }

  }

  Future<D> getGeneralItemData();
  Future<D> getItemData(LoadYearItemStatistics event);

}