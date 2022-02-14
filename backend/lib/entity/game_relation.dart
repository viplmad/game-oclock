import 'entity.dart';

class GamePlatformRelationData {
  GamePlatformRelationData._();

  static const String table = 'Game-Platform';

  static const String gameField = GameEntityData.relationField;
  static const String platformField = PlatformEntityData.relationField;
}

class GamePurchaseRelationData {
  GamePurchaseRelationData._();

  static const String table = 'Game-Purchase';

  static const String gameField = GameEntityData.relationField;
  static const String purchaseField = PurchaseEntityData.relationField;
}

class GameTagRelationData {
  GameTagRelationData._();

  static const String table = 'Game-Tag';

  static const String gameField = GameEntityData.relationField;
  static const String tagField = GameTagEntityData.relationField;
}
