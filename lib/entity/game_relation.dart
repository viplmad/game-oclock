import 'entity.dart';


class GamePlatformRelationData {
  GamePlatformRelationData._();

  static const String table = 'Game-Platform';

  static const String _gameField = GameEntityData.relationField;
  static const String _platformField = PlatformEntityData.relationField;

  static const Map<String, Type> fields = <String, Type>{
    _gameField : int,
    _platformField : int,
  };

  static Map<String, dynamic> getIdMap(int gameId, int platformId) {

    return <String, dynamic>{
      _gameField : gameId,
      _platformField : platformId,
    };

  }
}

class GamePurchaseRelationData {
  GamePurchaseRelationData._();

  static const String table = 'Game-Purchase';

  static const String _gameField = GameEntityData.relationField;
  static const String _purchaseField = PurchaseEntityData.relationField;

  static const Map<String, Type> fields = <String, Type>{
    _gameField : int,
    _purchaseField : int,
  };

  static Map<String, dynamic> getIdMap(int gameId, int purchaseId) {

    return <String, dynamic>{
      _gameField : gameId,
      _purchaseField : purchaseId,
    };

  }
}

class GameTagRelationData {
  GameTagRelationData._();

  static const String table = 'Game-Tag';

  static const String _gameField = GameEntityData.relationField;
  static const String _tagField = GameTagEntityData.relationField;

  static const Map<String, Type> fields = <String, Type>{
    _gameField : int,
    _tagField : int,
  };

  static Map<String, dynamic> getIdMap(int gameId, int tagId) {

    return <String, dynamic>{
      _gameField : gameId,
      _tagField : tagId,
    };

  }
}