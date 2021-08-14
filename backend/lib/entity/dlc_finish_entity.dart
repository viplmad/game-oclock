import 'entity.dart' show ItemEntity, DLCEntityData, DLCID;


class DLCFinishEntityData {
  DLCFinishEntityData._();

  static const String table = 'DLCFinish';

  static const String dlcField = DLCEntityData.relationField;
  static const String dateField = 'Date';
}

class DLCFinishID {
  DLCFinishID(this.dlcId, this.dateTime);

  final DLCID dlcId;
  final DateTime dateTime;

  @override
  String toString() => dlcId.toString();
}

class DLCFinishEntity extends ItemEntity {
  const DLCFinishEntity({
    required this.dlcId,
    required this.dateTime,
  });

  final int dlcId;
  final DateTime dateTime;

  static DLCFinishEntity fromMap(Map<String, Object?> map) {

    return DLCFinishEntity(
      dlcId: map[DLCFinishEntityData.dlcField] as int,
      dateTime: map[DLCFinishEntityData.dateField] as DateTime,
    );

  }

  static DLCFinishID idFromMap(Map<String, Object?> map) {

    return DLCFinishID(DLCID(map[DLCFinishEntityData.dlcField] as int), map[DLCFinishEntityData.dateField] as DateTime);

  }

  DLCFinishID createId() {

    return DLCFinishID(DLCID(dlcId), dateTime);

  }

  Map<String, Object?> createMap() {

    final Map<String, Object?> createMap = <String, Object?>{
      DLCFinishEntityData.dlcField : dlcId,
      DLCFinishEntityData.dateField : dateTime,
    };

    return createMap;

  }

  Map<String, Object?> updateMap(DLCFinishEntity updatedEntity) {

    final Map<String, Object?> updateMap = <String, Object?>{};

    putUpdateMapValue(updateMap, DLCFinishEntityData.dateField, dateTime, updatedEntity.dateTime);

    return updateMap;

  }

  @override
  List<Object> get props => <Object>[
    dateTime,
  ];

  @override
  String toString() {

    return '${DLCFinishEntityData.table}Entity { '
        '${DLCFinishEntityData.dlcField}: $dlcId, '
        '${DLCFinishEntityData.dateField}: $dateTime'
        ' }';

  }
}