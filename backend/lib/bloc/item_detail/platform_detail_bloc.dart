import 'package:backend/model/model.dart' show Platform;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class PlatformDetailBloc extends ItemDetailBloc<Platform, PlatformRepository> {
  PlatformDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required PlatformDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, repository: collectionRepository.platformRepository, managerBloc: managerBloc);
}