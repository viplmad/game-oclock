import 'package:game_oclock_client/api.dart'
    show NewPlatformDTO, PlatformDTO, PlatformPageResult;

import 'package:logic/model/model.dart' show PlatformView;
import 'package:logic/service/service.dart'
    show PlatformService, GameOClockService;

import 'item_list.dart';

class PlatformListBloc
    extends ItemListBloc<PlatformDTO, NewPlatformDTO, PlatformService> {
  PlatformListBloc({
    required GameOClockService collectionService,
    required super.managerBloc,
  }) : super(service: collectionService.platformService);

  @override
  Future<List<PlatformDTO>> getAllWithView(
    int viewIndex, [
    int? page,
  ]) async {
    final PlatformView view = PlatformView.values[viewIndex];
    switch (view) {
      case PlatformView.main:
        final PlatformPageResult result = await service.getAll(page: page);
        return result.data;
      case PlatformView.lastAdded:
        final PlatformPageResult result =
            await service.getLastAdded(page: page);
        return result.data;
      case PlatformView.lastUpdated:
        final PlatformPageResult result =
            await service.getLastUpdated(page: page);
        return result.data;
    }
  }
}
