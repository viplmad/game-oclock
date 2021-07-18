import 'package:backend/model/model.dart' show Platform;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import 'item_detail_manager.dart';


class PlatformDetailManagerBloc extends ItemDetailManagerBloc<Platform, PlatformRepository> {
  PlatformDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(itemId: itemId, repository: collectionRepository.platformRepository);

  @override
  Future<Platform?> addImage(AddItemImage<Platform> event) {

    return repository.uploadPlatformIcon(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<Platform?> updateImageName(UpdateItemImageName<Platform> event) {

    return repository.renamePlatformIcon(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<Platform?> deleteImage(DeleteItemImage<Platform> event) {

    return repository.deletePlatformIcon(itemId, event.imageName);

  }
}