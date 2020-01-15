import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/game.dart';
import 'package:game_collection/entity/dlc.dart';
import 'package:game_collection/entity/type.dart';
import 'package:game_collection/entity/purchase.dart';
import 'package:game_collection/entity/platform.dart';
import 'package:game_collection/entity/store.dart';
import 'package:game_collection/entity/system.dart';
import 'package:game_collection/entity/tag.dart';

abstract class DBConnector {

  Future<dynamic> open();
  Future<dynamic> close();

  //READ
    //Game
  Stream<List<Game>> getAllGames();
  Stream<List<Platform>> getPlatformsFromGame(int ID);
  Stream<List<Purchase>> getPurchasesFromGame(int ID);
  Stream<List<DLC>> getDLCsFromGame(int ID);
  Stream<List<Tag>> getTagsFromGame(int ID);

    //DLC
  Stream<List<DLC>> getAllDLCs();
  Stream<Game> getBaseGameFromDLC(int baseGameID);
  Stream<List<Purchase>> getPurchasesFromDLC(int ID);

    //Platform
  Stream<List<Platform>> getAllPlatforms();
  Stream<List<Game>> getGamesFromPlatform(int ID);
  Stream<List<System>> getSystemsFromPlatform(int ID);

    //Purchase
  Stream<List<Purchase>> getAllPurchases();
  Stream<Store> getStoreFromPurchase(int storeID);
  Stream<List<Game>> getGamesFromPurchase(int ID);
  Stream<List<DLC>> getDLCsFromPurchase(int ID);
  Stream<List<PurchaseType>> getTypesFromPurchase(int ID);

    //Store
  Stream<List<Store>> getAllStores();
  Stream<List<Purchase>> getPurchasesFromStore(int ID);

    //System
  Stream<List<System>> getAllSystems();
  Stream<List<Platform>> getPlatformsFromSystem(int ID);

    //Tag
  Stream<List<Tag>> getAllTags();
  Stream<List<Game>> getGamesFromTag(int ID);

    //Type
  Stream<List<PurchaseType>> getAllTypes();
  Stream<List<Purchase>> getPurchasesFromType(int ID);

  //CREATE
    //Game
  Future<dynamic> insertGamePurchase(int gameID, int purchaseID);
  Future<dynamic> insertGameDLC(int gameID, int dlcID);
    //DLC
  Future<dynamic> insertDLC();
  Future<dynamic> insertDLCPurchase(int gameID, int purchaseID);
    //Platform
    //Purchase
  Future<dynamic> insertPurchase();
    //Store
    //System
    //Tag
    //Type

  //UPDATE
    //Game
    //DLC
  Future<dynamic> updateStringDLC(int ID, String fieldName, String newText);
  Future<dynamic> updateNumberDLC(int ID, String fieldName, int newNumber);
  Future<dynamic> updateDateDLC(int ID, String fieldName, DateTime newDate);
    //Platform
    //Purchase
  Future<dynamic> updateDescriptionPurchase(int ID, String newText);
    //Store
    //System
    //Tag
    //Type

  //DELETE
    //Game
  Future<dynamic> deleteGamePurchase(int gameID, int purchaseID);
  Future<dynamic> deleteGameDLC(int dlcID);
    //DLC
  Future<dynamic> deleteDLCPurchase(int gameID, int purchaseID);
    //Platform
    //Purchase
    //Store
    //System
    //Tag
    //Type

  //SEARCH
  Stream<List<Entity>> getSearchStream(String tableName, String query);
  Stream<List<Game>> getGamesWithName(String name);
  Stream<List<DLC>> getDLCsWithName(String name);
  Stream<List<Platform>> getPlatformsWithName(String name);
  Stream<List<Purchase>> getPurchasesWithDescription(String description);
  Stream<List<Store>> getStoresWithName(String name);
  Stream<List<System>> getSystemsWithName(String name);
  Stream<List<Tag>> getTagsWithName(String name);
  Stream<List<PurchaseType>> getTypesWithName(String name);

}