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
  Stream<Game> getGameWithID(int ID);
  Stream<List<Platform>> getPlatformsFromGame(int ID);
  Stream<List<Purchase>> getPurchasesFromGame(int ID);
  Stream<List<DLC>> getDLCsFromGame(int ID);
  Stream<List<Tag>> getTagsFromGame(int ID);

    //DLC
  Stream<List<DLC>> getAllDLCs();
  Stream<List<DLC>> getDLCsWithView(DLCView dlcView, [int limit]);
  Stream<DLC> getDLCWithID(int ID);
  Stream<Game> getBaseGameFromDLC(int ID);
  Stream<List<Purchase>> getPurchasesFromDLC(int ID);

    //Platform
  Stream<List<Platform>> getAllPlatforms();
  Stream<List<Platform>> getPlatformsWithView(PlatformView platformView, [int limit]);
  Stream<Platform> getPlatformWithID(int ID);
  Stream<List<Game>> getGamesFromPlatform(int ID);
  Stream<List<System>> getSystemsFromPlatform(int ID);

    //Purchase
  Stream<List<Purchase>> getAllPurchases();
  Stream<List<Purchase>> getPurchasesWithView(PurchaseView purchaseView, [int limit]);
  Stream<Purchase> getPurchaseWithID(int ID);
  Stream<Store> getStoreFromPurchase(int storeID);
  Stream<List<Game>> getGamesFromPurchase(int ID);
  Stream<List<DLC>> getDLCsFromPurchase(int ID);
  Stream<List<PurchaseType>> getTypesFromPurchase(int ID);

    //Store
  Stream<List<Store>> getAllStores();
  Stream<List<Store>> getStoresWithView(StoreView storeView, [int limit]);
  Stream<Store> getStoreWithID(int ID);
  Stream<List<Purchase>> getPurchasesFromStore(int ID);

    //System
  Stream<List<System>> getAllSystems();
  Stream<List<System>> getSystemsWithView(SystemView systemView, [int limit]);
  Stream<System> getSystemWithID(int ID);
  Stream<List<Platform>> getPlatformsFromSystem(int ID);

    //Tag
  Stream<List<Tag>> getAllTags();
  Stream<List<Tag>> getTagsWithView(TagView tagView, [int limit]);
  Stream<Tag> getTagWithID(int ID);
  Stream<List<Game>> getGamesFromTag(int ID);

    //Type
  Stream<List<PurchaseType>> getAllTypes();
  Stream<List<PurchaseType>> getTypesWithView(TypeView typeView, [int limit]);
  Stream<PurchaseType> getTypeWithID(int ID);
  Stream<List<Purchase>> getPurchasesFromType(int ID);
  //#endregion READ


  //#region UPDATE
    //Game
  Future<Game> updateGame<T>(int ID, String fieldName, T newValue);

    //DLC
  Future<DLC> updateDLC<T>(int ID, String fieldName, T newValue);

    //Platform
  Future<Platform> updatePlatform<T>(int ID, String fieldName, T newValue);

    //Purchase
  Future<Purchase> updatePurchase<T>(int ID, String fieldName, T newValue);

    //Store
  Future<Store> updateStore<T>(int ID, String fieldName, T newValue);

    //System
  Future<System> updateSystem<T>(int ID, String fieldName, T newValue);

    //Tag
  Future<Tag> updateTag<T>(int ID, String fieldName, T newValue);

    //Type
  Future<PurchaseType> updateType<T>(int ID, String fieldName, T newValue);
  //#endregion UPDATE


  //#region DELETE
    //Game
  Future<dynamic> deleteGame(int ID);
  Future<dynamic> deleteGamePlatform(int gameID, int platformID);
  Future<dynamic> deleteGamePurchase(int gameID, int purchaseID);
  Future<dynamic> deleteGameDLC(int dlcID);
  Future<dynamic> deleteGameTag(int gameID, int tagID);

    //DLC
  Future<dynamic> deleteDLC(int ID);
  Future<dynamic> deleteDLCPurchase(int dlcID, int purchaseID);

    //Platform
  Future<dynamic> deletePlatform(int ID);
  Future<dynamic> deletePlatformSystem(int platformID, int systemID);

    //Purchase
  Future<dynamic> deletePurchase(int ID);
  Future<dynamic> deletePurchaseType(int purchaseID, int typeID);

    //Store
  Future<dynamic> deleteStore(int ID);
  Future<dynamic> deleteStorePurchase(int purchaseID);

    //System
  Future<dynamic> deleteSystem(int ID);

    //Tag
  Future<dynamic> deleteTag(int ID);

    //Type
  Future<dynamic> deleteType(int ID);
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