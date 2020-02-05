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
  Future<dynamic> insertPlatform(String name);
  Future<dynamic> insertPlatformSystem(int platformID, int systemID);

    //Purchase
  Future<dynamic> insertPurchase(String description);
  Future<dynamic> insertPurchaseType(int purchaseID, int typeID);

    //Store
  Future<dynamic> insertStore(String name);
  Future<dynamic> insertStorePurchase(int storeID, int purchaseID);

    //System
  Future<dynamic> insertSystem(String name);

    //Tag
  Future<dynamic> insertTag(String name);

    //Type
  Future<dynamic> insertType(String name);
  //#endregion CREATE


  //#region READ
    //Game
  Stream<List<Game>> getAllGames([List<String> sortFields]);
  Stream<Game> getGameWithID(int ID);
  Stream<List<Platform>> getPlatformsFromGame(int ID);
  Stream<List<Purchase>> getPurchasesFromGame(int ID);
  Stream<List<DLC>> getDLCsFromGame(int ID);
  Stream<List<Tag>> getTagsFromGame(int ID);

    //DLC
  Stream<List<DLC>> getAllDLCs([List<String> sortFields]);
  Stream<DLC> getDLCWithID(int ID);
  Stream<Game> getBaseGameFromDLC(int baseGameID);
  Stream<List<Purchase>> getPurchasesFromDLC(int ID);

    //Platform
  Stream<List<Platform>> getAllPlatforms([List<String> sortFields]);
  Stream<List<Game>> getGamesFromPlatform(int ID);
  Stream<List<System>> getSystemsFromPlatform(int ID);

    //Purchase
  Stream<List<Purchase>> getAllPurchases([List<String> sortFields]);
  Stream<Store> getStoreFromPurchase(int storeID);
  Stream<List<Game>> getGamesFromPurchase(int ID);
  Stream<List<DLC>> getDLCsFromPurchase(int ID);
  Stream<List<PurchaseType>> getTypesFromPurchase(int ID);

    //Store
  Stream<List<Store>> getAllStores([List<String> sortFields]);
  Stream<List<Purchase>> getPurchasesFromStore(int ID);

    //System
  Stream<List<System>> getAllSystems([List<String> sortFields]);
  Stream<List<Platform>> getPlatformsFromSystem(int ID);

    //Tag
  Stream<List<Tag>> getAllTags([List<String> sortFields]);
  Stream<List<Game>> getGamesFromTag(int ID);

    //Type
  Stream<List<PurchaseType>> getAllTypes([List<String> sortFields]);
  Stream<List<Purchase>> getPurchasesFromType(int ID);
  //#endregion READ


  //#region UPDATE
    //Game
  Future<dynamic> updateGame<T>(int ID, String fieldName, T newValue);

    //DLC
  Future<DLC> updateDLC<T>(int ID, String fieldName, T newValue);

    //Platform
  Future<dynamic> updatePlatform<T>(int ID, String fieldName, T newValue);

    //Purchase
  Future<dynamic> updatePurchase<T>(int ID, String fieldName, T newValue);

    //Store
  Future<dynamic> updateStore<T>(int ID, String fieldName, T newValue);

    //System
  Future<dynamic> updateSystem<T>(int ID, String fieldName, T newValue);

    //Tag
  Future<dynamic> updateTag<T>(int ID, String fieldName, T newValue);

    //Type
  Future<dynamic> updateType<T>(int ID, String fieldName, T newValue);
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