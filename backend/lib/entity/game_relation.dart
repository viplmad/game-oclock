import 'package:backend/query/query.dart';

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

  static Query getIdQuery(int gameId, int platformId) {

    final Query idQuery = Query();
    idQuery.addAnd(_gameField, gameId);
    idQuery.addAnd(_platformField, platformId);

    return idQuery;

  }

  static Map<String, dynamic> createDynamicMap(int gameId, int platformId) {

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

  static Query getIdQuery(int gameId, int purchaseId) {

    final Query idQuery = Query();
    idQuery.addAnd(_gameField, gameId);
    idQuery.addAnd(_purchaseField, purchaseId);

    return idQuery;

  }

  static Map<String, dynamic> createDynamicMap(int gameId, int purchaseId) {

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

  static Query getIdQuery(int gameId, int tagId) {

    final Query idQuery = Query();
    idQuery.addAnd(_gameField, gameId);
    idQuery.addAnd(_tagField, tagId);

    return idQuery;

  }

  static Map<String, dynamic> createDynamicMap(int gameId, int tagId) {

    return <String, dynamic>{
      _gameField : gameId,
      _tagField : tagId,
    };

  }
}