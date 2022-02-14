import 'entity.dart';

class PlatformSystemRelationData {
  PlatformSystemRelationData._();

  static const String table = 'Platform-System';

  static const String platformField = PlatformEntityData.relationField;
  static const String systemField = SystemEntityData.relationField;
}
