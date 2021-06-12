import 'package:equatable/equatable.dart';

import 'package:backend/utils/query.dart';
import 'package:backend/utils/fields.dart';

import 'entity.dart';


class GameTimeLogEntityData {
  GameTimeLogEntityData._();

  static const String table = 'GameLog';
  static const String readTable = 'Game-Log';

  static const String _gameField = GameEntityData.relationField;
  static const String dateTimeField = 'DateTime';
  static const String _timeField = 'Time';

  static Fields fields() {

    final Fields fields = Fields();
    fields.add(_gameField, int);
    fields.add(dateTimeField, DateTime);
    fields.add(_timeField, Duration);

    return fields;

  }

  static Query idQuery(int gameId, DateTime dateTime) {

    final Query idQuery = Query();
    idQuery.addAnd(_gameField, gameId);
    idQuery.addAnd(dateTimeField, dateTime);

    return idQuery;

  }
}

class GameTimeLogEntity extends Equatable {
  const GameTimeLogEntity({
    required this.dateTime,
    required this.time,
  });

  final DateTime dateTime;
  final Duration time;

  static GameTimeLogEntity fromDynamicMap(Map<String, dynamic> map) {

    return GameTimeLogEntity(
      dateTime: map[GameTimeLogEntityData.dateTimeField] as DateTime,
      time: Duration(seconds: map[GameTimeLogEntityData._timeField] as int),
    );

  }

  static List<GameTimeLogEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameTimeLogEntity> timeLogsList = <GameTimeLogEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final GameTimeLogEntity log = GameTimeLogEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, GameTimeLogEntityData.table) );

      timeLogsList.add(log);
    });

    return timeLogsList;

  }

  Map<String, dynamic> createDynamicMap(int gameId) {

    final Map<String, dynamic> createMap = <String, dynamic>{
      GameTimeLogEntityData._gameField : gameId,
      GameTimeLogEntityData.dateTimeField : dateTime,
      GameTimeLogEntityData._timeField : time,
    };

    return createMap;

  }

  @override
  List<Object> get props => <Object>[
    dateTime,
    time,
  ];

  @override
  String toString() {

    return '{$GameTimeLogEntityData.table}Entity { '
        '{$GameTimeLogEntityData._dateTimeField}: $dateTime, '
        '{$GameTimeLogEntityData._timeField}: $time'
        ' }';

  }
}