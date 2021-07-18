import 'package:backend/model/model.dart' show Platform;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import 'item_list_manager.dart';


class PlatformListManagerBloc extends ItemListManagerBloc<Platform, PlatformRepository> {
  PlatformListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.platformRepository);
}