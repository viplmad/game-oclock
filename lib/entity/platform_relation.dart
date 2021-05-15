import 'entity.dart';


class PlatformSystemRelationData {
  PlatformSystemRelationData._();

  static const String table = 'Platform-System';

  static const String _platformField = PlatformEntityData.relationField;
  static const String _systemField = SystemEntityData.relationField;

  static const Map<String, Type> fields = <String, Type>{
    _platformField : int,
    _systemField : int,
  };

  static Map<String, dynamic> getIdMap(int platformId, int systemId) {

    return <String, dynamic>{
      _platformField : platformId,
      _systemField : systemId,
    };

  }
}