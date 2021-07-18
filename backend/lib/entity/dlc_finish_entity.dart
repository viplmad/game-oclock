import 'package:equatable/equatable.dart';

import 'entity.dart';


class DLCFinishEntityData {
  DLCFinishEntityData._();

  static const String table = 'DLCFinish';

  static const String dlcField = DLCEntityData.relationField;
  static const String dateField = 'Date';
}

class DLCFinishEntity extends Equatable {
  const DLCFinishEntity({
    required this.dateTime,
  });

  final DateTime dateTime;

  static DLCFinishEntity _fromDynamicMap(Map<String, dynamic> map) {

    return DLCFinishEntity(
      dateTime: map[DLCFinishEntityData.dateField] as DateTime,
    );

  }

  static List<DLCFinishEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<DLCFinishEntity> finishList = <DLCFinishEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final DLCFinishEntity date = DLCFinishEntity._fromDynamicMap( ItemEntity.combineMaps(manyMap, GameFinishEntityData.table) );

      finishList.add(date);
    });

    return finishList;

  }

  Map<String, dynamic> createMap(int dlcId) {

    final Map<String, dynamic> createMap = <String, dynamic>{
      DLCFinishEntityData.dlcField : dlcId,
      DLCFinishEntityData.dateField : dateTime,
    };

    return createMap;

  }

  @override
  List<Object> get props => <Object>[
    dateTime,
  ];

  @override
  String toString() {

    return '{$DLCFinishEntityData.table}Entity { '
        '{$DLCFinishEntityData.dateTimeField}: $dateTime'
        ' }';

  }
}