import 'package:equatable/equatable.dart';

import 'package:backend/query/query.dart';

import 'entity.dart';


class DLCFinishEntityData {
  DLCFinishEntityData._();

  static const String table = 'DLCFinish';
  static const String readTable = 'DLC-Finish';

  static const String _dlcField = DLCEntityData.relationField;
  static const String _dateField = 'Date';

  static const Map<String, Type> fields = <String, Type>{
    _dlcField : int,
    _dateField : DateTime,
  };

  static Query getIdQuery(int dlcId, DateTime date) {

    final Query idQuery = Query();
    idQuery.addAnd(_dlcField, dlcId);
    idQuery.addAnd(_dateField, date);

    return idQuery;

  }
}

class DLCFinishEntity extends Equatable {
  const DLCFinishEntity({
    required this.dateTime,
  });

  final DateTime dateTime;

  static DLCFinishEntity _fromDynamicMap(Map<String, dynamic> map) {

    return DLCFinishEntity(
      dateTime: map[DLCFinishEntityData._dateField] as DateTime,
    );

  }

  static List<DLCFinishEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<DLCFinishEntity> finishList = <DLCFinishEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final DLCFinishEntity date = DLCFinishEntity._fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, GameFinishEntityData.table) );

      finishList.add(date);
    });

    return finishList;

  }

  Map<String, dynamic> createDynamicMap(int dlcId) {

    final Map<String, dynamic> createMap = <String, dynamic>{
      DLCFinishEntityData._dlcField : dlcId,
      DLCFinishEntityData._dateField : dateTime,
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
        '{$DLCFinishEntityData._dateTimeField}: $dateTime'
        ' }';

  }
}