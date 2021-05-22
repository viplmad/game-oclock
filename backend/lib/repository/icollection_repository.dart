import 'package:backend/model/model.dart';


abstract class ICollectionRepository {
  static ICollectionRepository? iCollectionRepository;

  Future<dynamic> open();
  Future<dynamic> close();

  bool isOpen();
  bool isClosed();

  void reconnect();

  //#region CREATE
    //Game
  Future<Game?> createGame(Game game);
  Future<dynamic> relateGamePlatform(int gameId, int platformId);
  Future<dynamic> relateGamePurchase(int gameId, int purchaseId);
  Future<dynamic> relateGameDLC(int gameId, int dlcId);
  Future<dynamic> relateGameTag(int gameId, int tagId);

  Future<dynamic> createGameFinish(int gameId, GameFinish finish);
  Future<dynamic> createGameTimeLog(int gameId, GameTimeLog timeLog);

    //DLC
  Future<DLC?> createDLC(DLC dlc);
  Future<dynamic> relateDLCPurchase(int dlcId, int purchaseId);

  Future<dynamic> createDLCFinish(int dlcId, DLCFinish finish);

    //Platform
  Future<Platform?> createPlatform(Platform platform);
  Future<dynamic> relatePlatformSystem(int platformId, int systemId);

    //Purchase
  Future<Purchase?> createPurchase(Purchase purchase);
  Future<dynamic> relatePurchaseType(int purchaseId, int typeId);

    //Store
  Future<Store?> createStore(Store store);
  Future<dynamic> relateStorePurchase(int storeId, int purchaseId);

    //System
  Future<System?> createSystem(System system);

    //Tag
  Future<Tag?> createGameTag(Tag tag);

    //Type
  Future<PurchaseType?> createPurchaseType(PurchaseType type);
  //#endregion CREATE


  //#region READ
    //Game
  Stream<List<Game>> findAllGames();
  Stream<List<Game>> findAllOwnedGames();
  Stream<List<Game>> findAllRomGames();
  Stream<List<Game>> findAllGamesWithView(GameView gameView, [int limit]);
  Stream<List<Game>> findAllGamesWithYearView(GameView gameView, int year, [int limit]);
  Stream<List<Game>> findAllOwnedGamesWithView(GameView gameView, [int limit]);
  Stream<List<Game>> findAllOwnedGamesWithYearView(GameView gameView, int year, [int limit]);
  Stream<List<Game>> findAllRomGamesWithView(GameView gameView, [int limit]);
  Stream<List<Game>> findAllRomGamesWithYearView(GameView gameView, int year, [int limit]);
  Stream<Game?> findGameById(int id);
  Stream<List<Platform>> findAllPlatformsFromGame(int id);
  Stream<List<Purchase>> findAllPurchasesFromGame(int id);
  Stream<List<DLC>> findAllDLCsFromGame(int id);
  Stream<List<Tag>> findAllGameTagsFromGame(int id);

  Stream<List<GameFinish>> findAllGameFinishFromGame(int id);
  Stream<List<GameTimeLog>> findAllGameTimeLogsFromGame(int id);

    //DLC
  Stream<List<DLC>> findAllDLCs();
  Stream<List<DLC>> findAllDLCsWithView(DLCView dlcView, [int limit]);
  Stream<DLC?> findDLCById(int id);
  Stream<Game?> findBaseGameFromDLC(int id);
  Stream<List<Purchase>> findAllPurchasesFromDLC(int id);

  Stream<List<DLCFinish>> findAllDLCFinishFromDLC(int id);

    //Platform
  Stream<List<Platform>> findAllPlatforms();
  Stream<List<Platform>> findAllPlatformsWithView(PlatformView platformView, [int limit]);
  Stream<Platform?> findPlatformById(int id);
  Stream<List<Game>> findAllGamesFromPlatform(int id);
  Stream<List<System>> findAllSystemsFromPlatform(int id);

    //Purchase
  Stream<List<Purchase>> findAllPurchases();
  Stream<List<Purchase>> findAllPurchasesWithView(PurchaseView purchaseView, [int limit]);
  Stream<List<Purchase>> findAllPurchasesWithYearView(PurchaseView purchaseView, int year, [int limit]);
  Stream<Purchase?> findPurchaseById(int id);
  Stream<Store?> findStoreFromPurchase(int storeId);
  Stream<List<Game>> findAllGamesFromPurchase(int id);
  Stream<List<DLC>> findAllDLCsFromPurchase(int id);
  Stream<List<PurchaseType>> findAllPurchaseTypesFromPurchase(int id);

    //Store
  Stream<List<Store>> findAllStores();
  Stream<List<Store>> findAllStoresWithView(StoreView storeView, [int limit]);
  Stream<Store?> findStoreById(int id);
  Stream<List<Purchase>> findAllPurchasesFromStore(int storeId);

    //System
  Stream<List<System>> findAllSystems();
  Stream<List<System>> findAllSystemsWithView(SystemView systemView, [int limit]);
  Stream<System?> findSystemById(int id);
  Stream<List<Platform>> findAllPlatformsFromSystem(int id);

    //Tag
  Stream<List<Tag>> findAllGameTags();
  Stream<List<Tag>> findAllGameTagsWithView(TagView tagView, [int limit]);
  Stream<Tag?> findGameTagById(int id);
  Stream<List<Game>> findAllGamesFromGameTag(int id);

    //Type
  Stream<List<PurchaseType>> findAllPurchaseTypes();
  Stream<List<PurchaseType>> findAllPurchaseTypesWithView(TypeView typeView, [int limit]);
  Stream<PurchaseType?> findPurchaseTypeById(int id);
  Stream<List<Purchase>> findAllPurchasesFromPurchaseType(int id);
  //#endregion READ


  //#region UPDATE
    //Game
  Future<Game?> updateGame<T>(Game game, Game updatedGame, GameUpdateProperties updateProperties);

    //DLC
  Future<DLC?> updateDLC(DLC dlc, DLC updatedDlc, DLCUpdateProperties updateProperties);

    //Platform
  Future<Platform?> updatePlatform(Platform platform, Platform updatedPlatform, PlatformUpdateProperties updateProperties);

    //Purchase
  Future<Purchase?> updatePurchase(Purchase purchase, Purchase updatedPurchase, PurchaseUpdateProperties updateProperties);

    //Store
  Future<Store?> updateStore(Store store, Store updatedStore, StoreUpdateProperties updateProperties);

    //System
  Future<System?> updateSystem(System system, System updatedSystem, SystemUpdateProperties updateProperties);

    //Tag
  Future<Tag?> updateGameTag(Tag tag, Tag updatedTag, GameTagUpdateProperties updateProperties);

    //Type
  Future<PurchaseType?> updatePurchaseType(PurchaseType type, PurchaseType updatedType, PurchaseTypeUpdateProperties updateProperties);
  //#endregion UPDATE


  //#region DELETE
    //Game
  Future<dynamic> deleteGameById(int id);
  Future<dynamic> unrelateGamePlatform(int gameId, int platformId);
  Future<dynamic> unrelateGamePurchase(int gameId, int purchaseId);
  Future<dynamic> unrelateGameDLC(int dlcId);
  Future<dynamic> unrelateGameTag(int gameId, int tagId);

  Future<dynamic> deleteGameFinishById(int gameId, DateTime date);
  Future<dynamic> deleteGameTimeLogById(int gameId, DateTime dateTime);

    //DLC
  Future<dynamic> deleteDLCById(int id);
  Future<dynamic> unrelateDLCPurchase(int dlcId, int purchaseId);

  Future<dynamic> deleteDLCFinishById(int dlcId, DateTime date);

    //Platform
  Future<dynamic> deletePlatformById(int id);
  Future<dynamic> unrelatePlatformSystem(int platformId, int systemId);

    //Purchase
  Future<dynamic> deletePurchaseById(int id);
  Future<dynamic> unrelatePurchaseType(int purchaseId, int typeId);

    //Store
  Future<dynamic> deleteStoreById(int id);
  Future<dynamic> unrelateStorePurchase(int purchaseId);

    //System
  Future<dynamic> deleteSystemById(int id);

    //Tag
  Future<dynamic> deleteGameTagById(int id);

    //Type
  Future<dynamic> deletePurchaseTypeById(int id);
  //#endregion DELETE


  //#region SEARCH
  Stream<List<Game>> findAllGamesByName(String name, int maxResults);
  Stream<List<DLC>> findAllDLCsByName(String name, int maxResults);
  Stream<List<Platform>> findAllPlatformsByName(String name, int maxResults);
  Stream<List<Purchase>> findAllPurchasesByDescription(String description, int maxResults);
  Stream<List<Store>> findAllStoresByName(String name, int maxResults);
  Stream<List<System>> findAllSystemsByName(String name, int maxResults);
  Stream<List<Tag>> findAllGameTagsByName(String name, int maxResults);
  Stream<List<PurchaseType>> findAllPurchaseTypesByName(String name, int maxResults);
  //#endregion SEARCH

  Stream<List<GameWithLogs>> findAllGamesWithTimeLogsByYear(int year);

  //#region IMAGE
    //Game
  Future<Game?> uploadGameCover(int id, String uploadImagePath, [String? oldImageName]);
  Future<Game?> renameGameCover(int id, String imageName, String newImageName);
  Future<Game?> deleteGameCover(int id, String imageName);
    //DLC
  Future<DLC?> uploadDLCCover(int id, String uploadImagePath, [String? oldImageName]);
  Future<DLC?> renameDLCCover(int id, String imageName, String newImageName);
  Future<DLC?> deleteDLCCover(int id, String imageName);
    //Platform
  Future<Platform?> uploadPlatformIcon(int id, String uploadImagePath, [String? oldImageName]);
  Future<Platform?> renamePlatformIcon(int id, String imageName, String newImageName);
  Future<Platform?> deletePlatformIcon(int id, String imageName);
    //Store
  Future<Store?> uploadStoreIcon(int id, String uploadImagePath, [String? oldImageName]);
  Future<Store?> renameStoreIcon(int id, String imageName, String newImageName);
  Future<Store?> deleteStoreIcon(int id, String imageName);
    //System
  Future<System?> uploadSystemIcon(int id, String uploadImagePath, [String? oldImageName]);
  Future<System?> renameSystemIcon(int id, String imageName, String newImageName);
  Future<System?> deleteSystemIcon(int id, String imageName);
  //#endregion IMAGE
}