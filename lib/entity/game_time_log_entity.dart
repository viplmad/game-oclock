import 'package:equatable/equatable.dart';

import 'entity.dart';


class GameTimeLogEntityData {
  GameTimeLogEntityData._();

  static const String table = 'GameLog';
  static const String readTable = 'Game-Log';
  
  static const String _gameField = GameEntityData.relationField;
  static const String _dateTimeField = 'DateTime';
  static const String _timeField = 'Time';

  static const Map<String, Type> fields = <String, Type>{
    _gameField : int,
    _dateTimeField : DateTime,
    _timeField : Duration,
  };
  
  static Map<String, dynamic> getIdMap(int gameId, DateTime dateTime) {

    return <String, dynamic>{
      _gameField : gameId,
      _dateTimeField : dateTime,
    };

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
      dateTime: map[GameTimeLogEntityData._dateTimeField] as DateTime,
      time: map[GameTimeLogEntityData._timeField] as Duration,
    );

  }

  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      GameTimeLogEntityData._dateTimeField : dateTime,
      GameTimeLogEntityData._timeField : time,
    };

  }

  Map<String, dynamic> getCreateDynamicMap(int gameId) {

    final Map<String, dynamic> createMap = <String, dynamic>{
      GameTimeLogEntityData._gameField : gameId,
      GameTimeLogEntityData._dateTimeField : dateTime,
      GameTimeLogEntityData._timeField : time,
    };

    return createMap;

  }

  static List<GameTimeLogEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameTimeLogEntity> timeLogsList = <GameTimeLogEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final GameTimeLogEntity log = GameTimeLogEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, GameTimeLogEntityData.table) );

      timeLogsList.add(log);
    });

    return timeLogsList;

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