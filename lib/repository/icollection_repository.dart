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
  Future<dynamic> relateGamePlatform(int gameID, int platformID);
  Future<dynamic> relateGamePurchase(int gameID, int purchaseID);
  Future<dynamic> relateGameDLC(int gameID, int dlcID);
  Future<dynamic> relateGameTag(int gameID, int tagID);

    //DLC
  Future<DLC> createDLC(String name);
  Future<dynamic> relateDLCPurchase(int dlcID, int purchaseID);

    //Platform
  Future<Platform> createPlatform(String name);
  Future<dynamic> relatePlatformSystem(int platformID, int systemID);

    //Purchase
  Future<Purchase> createPurchase(String description);
  Future<dynamic> relatePurchaseType(int purchaseID, int typeID);

    //Store
  Future<Store> createStore(String name);
  Future<dynamic> relateStorePurchase(int storeID, int purchaseID);

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
  Stream<List<Game>> getOwnedWithView(GameView gameView, [int limit]);
  Stream<List<Game>> getRomsWithView(GameView gameView, [int limit]);
  Stream<Game> getGameWithID(int id);
  Stream<List<Platform>> getPlatformsFromGame(int id);
  Stream<List<Purchase>> getPurchasesFromGame(int id);
  Stream<List<DLC>> getDLCsFromGame(int id);
  Stream<List<Tag>> getTagsFromGame(int id);

    //DLC
  Stream<List<DLC>> getAllDLCs();
  Stream<List<DLC>> getDLCsWithView(DLCView dlcView, [int limit]);
  Stream<DLC> getDLCWithID(int id);
  Stream<Game> getBaseGameFromDLC(int id);
  Stream<List<Purchase>> getPurchasesFromDLC(int id);

    //Platform
  Stream<List<Platform>> getAllPlatforms();
  Stream<List<Platform>> getPlatformsWithView(PlatformView platformView, [int limit]);
  Stream<Platform> getPlatformWithID(int id);
  Stream<List<Game>> getGamesFromPlatform(int id);
  Stream<List<System>> getSystemsFromPlatform(int id);

    //Purchase
  Stream<List<Purchase>> getAllPurchases();
  Stream<List<Purchase>> getPurchasesWithView(PurchaseView purchaseView, [int limit]);
  Stream<Purchase> getPurchaseWithID(int id);
  Stream<Store> getStoreFromPurchase(int storeID);
  Stream<List<Game>> getGamesFromPurchase(int id);
  Stream<List<DLC>> getDLCsFromPurchase(int id);
  Stream<List<PurchaseType>> getTypesFromPurchase(int id);

    //Store
  Stream<List<Store>> getAllStores();
  Stream<List<Store>> getStoresWithView(StoreView storeView, [int limit]);
  Stream<Store> getStoreWithID(int id);
  Stream<List<Purchase>> getPurchasesFromStore(int id);

    //System
  Stream<List<System>> getAllSystems();
  Stream<List<System>> getSystemsWithView(SystemView systemView, [int limit]);
  Stream<System> getSystemWithID(int id);
  Stream<List<Platform>> getPlatformsFromSystem(int id);

    //Tag
  Stream<List<Tag>> getAllTags();
  Stream<List<Tag>> getTagsWithView(TagView tagView, [int limit]);
  Stream<Tag> getTagWithID(int id);
  Stream<List<Game>> getGamesFromTag(int id);

    //Type
  Stream<List<PurchaseType>> getAllTypes();
  Stream<List<PurchaseType>> getTypesWithView(TypeView typeView, [int limit]);
  Stream<PurchaseType> getTypeWithID(int id);
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
  Future<dynamic> deleteGamePlatform(int gameID, int platformID);
  Future<dynamic> deleteGamePurchase(int gameID, int purchaseID);
  Future<dynamic> deleteGameDLC(int dlcID);
  Future<dynamic> deleteGameTag(int gameID, int tagID);

    //DLC
  Future<dynamic> deleteDLC(int id);
  Future<dynamic> deleteDLCPurchase(int dlcID, int purchaseID);

    //Platform
  Future<dynamic> deletePlatform(int id);
  Future<dynamic> deletePlatformSystem(int platformID, int systemID);

    //Purchase
  Future<dynamic> deletePurchase(int id);
  Future<dynamic> deletePurchaseType(int purchaseID, int typeID);

    //Store
  Future<dynamic> deleteStore(int id);
  Future<dynamic> deleteStorePurchase(int purchaseID);

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
  Future<Game> uploadGameCover(int gameID, String uploadImagePath, [String oldImageName]);
  Future<Game> renameGameCover(int gameID, String imageName, String newImageName);
  Future<Game> deleteGameCover(int gameID, String imageName);
    //DLC
  Future<DLC> uploadDLCCover(int dlcID, String uploadImagePath, [String oldImageName]);
  Future<DLC> renameDLCCover(int dlcID, String imageName, String newImageName);
  Future<DLC> deleteDLCCover(int dlcID, String imageName);
    //Platform
  Future<Platform> uploadPlatformIcon(int platformID, String uploadImagePath, [String oldImageName]);
  Future<Platform> renamePlatformIcon(int platformID, String imageName, String newImageName);
  Future<Platform> deletePlatformIcon(int platformID, String imageName);
    //Store
  Future<Store> uploadStoreIcon(int storeID, String uploadImagePath, [String oldImageName]);
  Future<Store> renameStoreIcon(int storeID, String imageName, String newImageName);
  Future<Store> deleteStoreIcon(int storeID, String imageName);
    //System
  Future<System> uploadSystemIcon(int systemID, String uploadImagePath, [String oldImageName]);
  Future<System> renameSystemIcon(int systemID, String imageName, String newImageName);
  Future<System> deleteSystemIcon(int systemID, String imageName);
  //#endregion IMAGE

}