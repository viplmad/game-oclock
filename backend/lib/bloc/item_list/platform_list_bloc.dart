import 'package:game_collection_client/api.dart'
    show PlatformDTO, NewPlatformDTO;

import 'package:backend/service/service.dart'
    show PlatformService, GameCollectionService;
import 'package:backend/model/model.dart' show PlatformView;

import 'item_list.dart';

class PlatformListBloc
    extends ItemListBloc<PlatformDTO, NewPlatformDTO, PlatformService> {
  PlatformListBloc({
    required GameCollectionService collectionService,
    required super.managerBloc,
  }) : super(service: collectionService.platformService);

  @override
  Future<ViewParameters> getStartViewIndex() {
    return Future<ViewParameters>.value(
      ViewParameters(PlatformView.main.index),
    );
  }
}
