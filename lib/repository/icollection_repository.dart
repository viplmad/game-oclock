import 'package:game_collection/model/model.dart';


abstract class ICollectionRepository {

  Future<dynamic> open();
  Future<dynamic> close();

  //#region CREATE
    //Game
  Future<Game> insertGame(String name, String edition);
  Future<dynamic> insertGamePlatform(int gameID, int platformID);
  Future<dynamic> insertGamePurchase(int gameID, int purchaseID);
  Future<dynamic> insertGameDLC(int gameID, int dlcID);
  Future<dynamic> insertGameTag(int gameID, int tagID);

    //DLC
  Future<DLC> insertDLC(String name);
  Future<dynamic> insertDLCPurchase(int dlcID, int purchaseID);

    //Platform
  Future<Platform> insertPlatform(String name);
  Future<dynamic> insertPlatformSystem(int platformID, int systemID);

    //Purchase
  Future<Purchase> insertPurchase(String description);
  Future<dynamic> insertPurchaseType(int purchaseID, int typeID);

    //Store
  Future<Store> insertStore(String name);
  Future<dynamic> insertStorePurchase(int storeID, int purchaseID);

    //System
  Future<System> insertSystem(String name);

    //Tag
  Future<Tag> insertTag(String name);

    //Type
  Future<PurchaseType> insertType(String name);
  //#endregion CREATE


  //#region READ
    //Game
  Stream<List<Game>> getAllGames();
  Stream<List<Game>> getGames([Map<String, dynamic> whereFieldsAndValues, List<String> sortFields]);
  Stream<Game> getGameWithID(int ID);
  Stream<List<Platform>> getPlatformsFromGame(int ID);
  Stream<List<Purchase>> getPurchasesFromGame(int ID);
  Stream<List<DLC>> getDLCsFromGame(int ID);
  Stream<List<Tag>> getTagsFromGame(int ID);

    //DLC
  Stream<List<DLC>> getAllDLCs();
  Stream<DLC> getDLCWithID(int ID);
  Stream<Game> getBaseGameFromDLC(int ID);
  Stream<List<Purchase>> getPurchasesFromDLC(int ID);

    //Platform
  Stream<List<Platform>> getAllPlatforms();
  Stream<Platform> getPlatformWithID(int ID);
  Stream<List<Game>> getGamesFromPlatform(int ID);
  Stream<List<System>> getSystemsFromPlatform(int ID);

    //Purchase
  Stream<List<Purchase>> getAllPurchases();
  Stream<Purchase> getPurchaseWithID(int ID);
  Stream<Store> getStoreFromPurchase(int storeID);
  Stream<List<Game>> getGamesFromPurchase(int ID);
  Stream<List<DLC>> getDLCsFromPurchase(int ID);
  Stream<List<PurchaseType>> getTypesFromPurchase(int ID);

    //Store
  Stream<List<Store>> getAllStores();
  Stream<Store> getStoreWithID(int ID);
  Stream<List<Purchase>> getPurchasesFromStore(int ID);

    //System
  Stream<List<System>> getAllSystems();
  Stream<System> getSystemWithID(int ID);
  Stream<List<Platform>> getPlatformsFromSystem(int ID);

    //Tag
  Stream<List<Tag>> getAllTags();
  Stream<Tag> getTagWithID(int ID);
  Stream<List<Game>> getGamesFromTag(int ID);

    //Type
  Stream<List<PurchaseType>> getAllTypes();
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
  Stream<List<CollectionItem>> getSearchStream(String tableName, String query, int maxResults);
  Stream<List<Game>> getGamesWithName(String name, int maxResults);
  Stream<List<DLC>> getDLCsWithName(String name, int maxResults);
  Stream<List<Platform>> getPlatformsWithName(String name, int maxResults);
  Stream<List<Purchase>> getPurchasesWithDescription(String description, int maxResults);
  Stream<List<Store>> getStoresWithName(String name, int maxResults);
  Stream<List<System>> getSystemsWithName(String name, int maxResults);
  Stream<List<Tag>> getTagsWithName(String name, int maxResults);
  Stream<List<PurchaseType>> getTypesWithName(String name, int maxResults);
  //#endregion SEARCH

  //#region UPLOAD
    //Game
  Future<dynamic> uploadGameCover(int gameID, String uploadImage);
  //TODO: add more
  //#endregion UPLOAD

  //#region DOWNLOAD
    //Game
  String getGameCoverURL(int gameID);
  //TODO: add more
  //#ENDregion DOWNLOAD
}