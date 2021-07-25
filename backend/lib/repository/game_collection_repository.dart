import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;

import 'repository.dart';


class GameCollectionRepository {
  GameCollectionRepository();

  void connect(ItemConnector itemConnector, ImageConnector imageConnector) {
    gameRepository = GameRepository(itemConnector, imageConnector);
    gameFinishRepository = GameFinishRepository(itemConnector, imageConnector);
    gameTimeLogRepository = GameTimeLogRepository(itemConnector, imageConnector);
    dlcRepository = DLCRepository(itemConnector, imageConnector);
    dlcFinishRepository = DLCFinishRepository(itemConnector, imageConnector);
    platformRepository = PlatformRepository(itemConnector, imageConnector);
    purchaseRepository = PurchaseRepository(itemConnector, imageConnector);
    storeRepository = StoreRepository(itemConnector, imageConnector);
    systemRepository = SystemRepository(itemConnector, imageConnector);
    gameTagRepository = GameTagRepository(itemConnector, imageConnector);
    purchaseTypeRepository = PurchaseTypeRepository(itemConnector, imageConnector);
  }

  Future<Object?> open() => gameRepository.open();
  void reconnect() => gameRepository.reconnect();

  late final GameRepository gameRepository;
  late final GameFinishRepository gameFinishRepository;
  late final GameTimeLogRepository gameTimeLogRepository;
  late final DLCRepository dlcRepository;
  late final DLCFinishRepository dlcFinishRepository;
  late final PlatformRepository platformRepository;
  late final PurchaseRepository purchaseRepository;
  late final StoreRepository storeRepository;
  late final SystemRepository systemRepository;
  late final GameTagRepository gameTagRepository;
  late final PurchaseTypeRepository purchaseTypeRepository;
}