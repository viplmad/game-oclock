import 'package:game_collection/model/model.dart';


abstract class ICollectionRepository {
  static ICollectionRepository iCollectionRepository;

  Future<dynamic> open();
  Future<dynamic> close();

  bool isOpen();
  bool isClosed();

  void reconnect();

  //#region CREATE
    //Game
  Future<Game> createGame(String name, String edition);
  Future<dynamic> relateGamePlatform(int gameId, int platformId);
  Future<dynamic> relateGamePurchase(int gameId, int purchaseId);
  Future<dynamic> relateGameDLC(int gameId, int dlcId);
  Future<dynamic> relateGameTag(int gameId, int tagId);

  Future<dynamic> relateGameFinishDate(int gameId, DateTime date);
  Future<dynamic> relateGameTimeLog(int gameId, DateTime dateTime, Duration duration);

    //DLC
  Future<DLC> createDLC(String name);
  Future<dynamic> relateDLCPurchase(int dlcId, int purchaseId);

  Future<dynamic> relateDLCFinishDate(int dlcId, DateTime date);

    //Platform
  Future<Platform> createPlatform(String name);
  Future<dynamic> relatePlatformSystem(int platformId, int systemId);

    //Purchase
  Future<Purchase> createPurchase(String description);
  Future<dynamic> relatePurchaseType(int purchaseId, int typeId);

    //Store
  Future<Store> createStore(String name);
  Future<dynamic> relateStorePurchase(int storeId, int purchaseId);

    //System
  Future<System> createSystem(String name);

    //Tag
  Future<Tag> createTag(String name);

    //Type
  Future<PurchaseType> createType(String name);
  //#endregion CREATE


  //#region READ
    //Game
  Stream<List<Game>> getAllGames();
  Stream<List<Game>> getAllOwned();
  Stream<List<Game>> getAllRoms();
  Stream<List<Game>> getAllWithView(GameView gameView, [int limit]);
  Stream<List<Game>> getAllWithYearView(GameView gameView, int year, [int limit]);
  Stream<List<Game>> getOwnedWithView(GameView gameView, [int limit]);
  Stream<List<Game>> getOwnedWithYearView(GameView gameView, int year, [int limit]);
  Stream<List<Game>> getRomsWithView(GameView gameView, [int limit]);
  Stream<List<Game>> getRomsWithYearView(GameView gameView, int year, [int limit]);
  Stream<Game> getGameWithId(int id);
  Stream<List<Platform>> getPlatformsFromGame(int id);
  Stream<List<Purchase>> getPurchasesFromGame(int id);
  Stream<List<DLC>> getDLCsFromGame(int id);
  Stream<List<Tag>> getTagsFromGame(int id);

  Stream<List<DateTime>> getFinishDatesFromGame(int id);
  Stream<List<TimeLog>> getTimeLogsFromGame(int id);

    //DLC
  Stream<List<DLC>> getAllDLCs();
  Stream<List<DLC>> getDLCsWithView(DLCView dlcView, [int limit]);
  Stream<DLC> getDLCWithId(int id);
  Stream<Game> getBaseGameFromDLC(int id);
  Stream<List<Purchase>> getPurchasesFromDLC(int id);

  Stream<List<DateTime>> getFinishDatesFromDLC(int id);

    //Platform
  Stream<List<Platform>> getAllPlatforms();
  Stream<List<Platform>> getPlatformsWithView(PlatformView platformView, [int limit]);
  Stream<Platform> getPlatformWithId(int id);
  Stream<List<Game>> getGamesFromPlatform(int id);
  Stream<List<System>> getSystemsFromPlatform(int id);

    //Purchase
  Stream<List<Purchase>> getAllPurchases();
  Stream<List<Purchase>> getPurchasesWithView(PurchaseView purchaseView, [int limit]);
  Stream<List<Purchase>> getPurchasesWithYearView(PurchaseView purchaseView, int year, [int limit]);
  Stream<Purchase> getPurchaseWithId(int id);
  Stream<Store> getStoreFromPurchase(int storeId);
  Stream<List<Game>> getGamesFromPurchase(int id);
  Stream<List<DLC>> getDLCsFromPurchase(int id);
  Stream<List<PurchaseType>> getTypesFromPurchase(int id);

    //Store
  Stream<List<Store>> getAllStores();
  Stream<List<Store>> getStoresWithView(StoreView storeView, [int limit]);
  Stream<Store> getStoreWithId(int id);
  Stream<List<Purchase>> getPurchasesFromStore(int id);

    //System
  Stream<List<System>> getAllSystems();
  Stream<List<System>> getSystemsWithView(SystemView systemView, [int limit]);
  Stream<System> getSystemWithId(int id);
  Stream<List<Platform>> getPlatformsFromSystem(int id);

    //Tag
  Stream<List<Tag>> getAllTags();
  Stream<List<Tag>> getTagsWithView(TagView tagView, [int limit]);
  Stream<Tag> getTagWithId(int id);
  Stream<List<Game>> getGamesFromTag(int id);

    //Type
  Stream<List<PurchaseType>> getAllTypes();
  Stream<List<PurchaseType>> getTypesWithView(TypeView typeView, [int limit]);
  Stream<PurchaseType> getTypeWithId(int id);
  Stream<List<Purchase>> getPurchasesFromType(int id);
  //#endregion READ


  //#region UPDATE
    //Game
  Future<Game> updateGame<T>(int id, String fieldName, T newValue);

    //DLC
  Future<DLC> updateDLC<T>(int id, String fieldName, T newValue);

    //Platform
  Future<Platform> updatePlatform<T>(int id, String fieldName, T newValue);

    //Purchase
  Future<Purchase> updatePurchase<T>(int id, String fieldName, T newValue);

    //Store
  Future<Store> updateStore<T>(int id, String fieldName, T newValue);

    //System
  Future<System> updateSystem<T>(int id, String fieldName, T newValue);

    //Tag
  Future<Tag> updateTag<T>(int id, String fieldName, T newValue);

    //Type
  Future<PurchaseType> updateType<T>(int id, String fieldName, T newValue);
  //#endregion UPDATE


  //#region DELETE
    //Game
  Future<dynamic> deleteGame(int id);
  Future<dynamic> deleteGamePlatform(int gameId, int platformId);
  Future<dynamic> deleteGamePurchase(int gameId, int purchaseId);
  Future<dynamic> deleteGameDLC(int dlcId);
  Future<dynamic> deleteGameTag(int gameId, int tagId);

  Future<dynamic> deleteGameFinishDate(int gameId, DateTime date);
  Future<dynamic> deleteGameTimeLog(int gameId, DateTime dateTime);

    //DLC
  Future<dynamic> deleteDLC(int id);
  Future<dynamic> deleteDLCPurchase(int dlcId, int purchaseId);

  Future<dynamic> deleteDLCFinishDate(int dlcId, DateTime date);

    //Platform
  Future<dynamic> deletePlatform(int id);
  Future<dynamic> deletePlatformSystem(int platformId, int systemId);

    //Purchase
  Future<dynamic> deletePurchase(int id);
  Future<dynamic> deletePurchaseType(int purchaseId, int typeId);

    //Store
  Future<dynamic> deleteStore(int id);
  Future<dynamic> deleteStorePurchase(int purchaseId);

    //System
  Future<dynamic> deleteSystem(int id);

    //Tag
  Future<dynamic> deleteTag(int id);

    //Type
  Future<dynamic> deleteType(int id);
  //#endregion DELETE


  //#region SEARCH
  Stream<List<Game>> getGamesWithName(String name, int maxResults);
  Stream<List<DLC>> getDLCsWithName(String name, int maxResults);
  Stream<List<Platform>> getPlatformsWithName(String name, int maxResults);
  Stream<List<Purchase>> getPurchasesWithDescription(String description, int maxResults);
  Stream<List<Store>> getStoresWithName(String name, int maxResults);
  Stream<List<System>> getSystemsWithName(String name, int maxResults);
  Stream<List<Tag>> getTagsWithName(String name, int maxResults);
  Stream<List<PurchaseType>> getTypesWithName(String name, int maxResults);
  //#endregion SEARCH


  //#region IMAGE
    //Game
  Future<Game> uploadGameCover(int gameId, String uploadImagePath, [String oldImageName]);
  Future<Game> renameGameCover(int gameId, String imageName, String newImageName);
  Future<Game> deleteGameCover(int gameId, String imageName);
    //DLC
  Future<DLC> uploadDLCCover(int dlcId, String uploadImagePath, [String oldImageName]);
  Future<DLC> renameDLCCover(int dlcId, String imageName, String newImageName);
  Future<DLC> deleteDLCCover(int dlcId, String imageName);
    //Platform
  Future<Platform> uploadPlatformIcon(int platformId, String uploadImagePath, [String oldImageName]);
  Future<Platform> renamePlatformIcon(int platformId, String imageName, String newImageName);
  Future<Platform> deletePlatformIcon(int platformId, String imageName);
    //Store
  Future<Store> uploadStoreIcon(int storeId, String uploadImagePath, [String oldImageName]);
  Future<Store> renameStoreIcon(int storeId, String imageName, String newImageName);
  Future<Store> deleteStoreIcon(int storeId, String imageName);
    //System
  Future<System> uploadSystemIcon(int systemId, String uploadImagePath, [String oldImageName]);
  Future<System> renameSystemIcon(int systemId, String imageName, String newImageName);
  Future<System> deleteSystemIcon(int systemId, String imageName);
  //#endregion IMAGE
}