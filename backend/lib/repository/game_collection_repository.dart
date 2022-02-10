import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;

import 'repository.dart';


class GameCollectionRepository {
  GameCollectionRepository();

  late GameRepository gameRepository;
  late GameFinishRepository gameFinishRepository;
  late GameTimeLogRepository gameTimeLogRepository;
  late DLCRepository dlcRepository;
  late DLCFinishRepository dlcFinishRepository;
  late PlatformRepository platformRepository;
  late PurchaseRepository purchaseRepository;
  late StoreRepository storeRepository;
  late SystemRepository systemRepository;
  late GameTagRepository gameTagRepository;
  late PurchaseTypeRepository purchaseTypeRepository;

  late GameStatisticsRepository gameStatisticsRepository;

  void connect(ItemConnector itemConnector, ImageConnector? imageConnector) {
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

    gameStatisticsRepository = GameStatisticsRepository(itemConnector);
  }

  Future<Object?> open() => gameRepository.open();
  Future<Object?> close() => gameRepository.close();

  bool isOpen() => gameRepository.isOpen();
  bool isClosed() => gameRepository.isClosed();

  void reconnect() => gameRepository.reconnect();
}