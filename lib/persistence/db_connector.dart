import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/game.dart' as gameEntity;
import 'package:game_collection/entity/dlc.dart' as dlcEntity;
import 'package:game_collection/entity/purchase.dart' as purchaseEntity;
import 'package:game_collection/entity/platform.dart' as platformEntity;
import 'package:game_collection/entity/store.dart' as storeEntity;
import 'package:game_collection/entity/system.dart' as systemEntity;
import 'package:game_collection/entity/tag.dart' as tagEntity;
import 'package:game_collection/entity/type.dart' as typeEntity;

abstract class IDBConnector {

  Future<dynamic> open();
  Future<dynamic> close();
  bool isOpen();
  bool isClosed();
  bool isUpdating();

  //#region CREATE
    //Game
  Future<dynamic> insertGame(String name, String edition);
  Future<dynamic> insertGamePlatform(int gameID, int platformID);
  Future<dynamic> insertGamePurchase(int gameID, int purchaseID);
  Future<dynamic> insertGameDLC(int gameID, int dlcID);
  Future<dynamic> insertGameTag(int gameID, int tagID);
    //DLC
  Future<dynamic> insertDLC(String name);
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
  Stream<List<gameEntity.Game>> getAllGames([List<String> sortFields = const [gameEntity.releaseYearField, gameEntity.nameField]]);
  Stream<List<platformEntity.Platform>> getPlatformsFromGame(int ID);
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromGame(int ID);
  Stream<List<dlcEntity.DLC>> getDLCsFromGame(int ID);
  Stream<List<tagEntity.Tag>> getTagsFromGame(int ID);

    //DLC
  Stream<List<dlcEntity.DLC>> getAllDLCs([List<String> sortFields = const [dlcEntity.releaseYearField, dlcEntity.nameField]]);
  Stream<gameEntity.Game> getBaseGameFromDLC(int baseGameID);
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromDLC(int ID);

    //Platform
  Stream<List<platformEntity.Platform>> getAllPlatforms([List<String> sortFields = const [platformEntity.typeField, platformEntity.nameField]]);
  Stream<List<gameEntity.Game>> getGamesFromPlatform(int ID);
  Stream<List<systemEntity.System>> getSystemsFromPlatform(int ID);

    //Purchase
  Stream<List<purchaseEntity.Purchase>> getAllPurchases([List<String> sortFields = const [purchaseEntity.dateField, purchaseEntity.descriptionField]]);
  Stream<storeEntity.Store> getStoreFromPurchase(int storeID);
  Stream<List<gameEntity.Game>> getGamesFromPurchase(int ID);
  Stream<List<dlcEntity.DLC>> getDLCsFromPurchase(int ID);
  Stream<List<typeEntity.PurchaseType>> getTypesFromPurchase(int ID);

    //Store
  Stream<List<storeEntity.Store>> getAllStores([List<String> sortFields = const [storeEntity.nameField]]);
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromStore(int ID);

    //System
  Stream<List<systemEntity.System>> getAllSystems([List<String> sortFields = const [systemEntity.generationField, systemEntity.manufacturerField]]);
  Stream<List<platformEntity.Platform>> getPlatformsFromSystem(int ID);

    //Tag
  Stream<List<tagEntity.Tag>> getAllTags([List<String> sortFields = const [tagEntity.nameField]]);
  Stream<List<gameEntity.Game>> getGamesFromTag(int ID);

    //Type
  Stream<List<typeEntity.PurchaseType>> getAllTypes([List<String> sortFields = const [typeEntity.nameField]]);
  Stream<List<purchaseEntity.Purchase>> getPurchasesFromType(int ID);
  //#endregion READ


  //#region UPDATE
    //Game
  Future<dynamic> updateGame<T>(int ID, String fieldName, T newValue);

    //DLC
  Future<dynamic> updateDLC<T>(int ID, String fieldName, T newValue);

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
  Stream<List<Entity>> getSearchStream(String tableName, String query, int maxResults);
  Stream<List<gameEntity.Game>> getGamesWithName(String name, int maxResults);
  Stream<List<dlcEntity.DLC>> getDLCsWithName(String name, int maxResults);
  Stream<List<platformEntity.Platform>> getPlatformsWithName(String name, int maxResults);
  Stream<List<purchaseEntity.Purchase>> getPurchasesWithDescription(String description, int maxResults);
  Stream<List<storeEntity.Store>> getStoresWithName(String name, int maxResults);
  Stream<List<systemEntity.System>> getSystemsWithName(String name, int maxResults);
  Stream<List<tagEntity.Tag>> getTagsWithName(String name, int maxResults);
  Stream<List<typeEntity.PurchaseType>> getTypesWithName(String name, int maxResults);
  //#endregion SEARCH


}