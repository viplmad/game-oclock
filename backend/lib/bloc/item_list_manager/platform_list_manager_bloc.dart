import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_list_manager.dart';


class PlatformListManagerBloc extends ItemListManagerBloc<Platform> {
  PlatformListManagerBloc({
    required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Platform?> createFuture(AddItem<Platform> event) {

    return iCollectionRepository.createPlatform(event.item);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Platform> event) {

    return iCollectionRepository.deletePlatformById(event.item.id);

  }
}