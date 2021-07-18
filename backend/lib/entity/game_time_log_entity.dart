import 'package:equatable/equatable.dart';

import 'entity.dart';


class GameTimeLogEntityData {
  GameTimeLogEntityData._();

  static const String table = 'GameLog';

  static const String gameField = GameEntityData.relationField;
  static const String dateTimeField = 'DateTime';
  static const String timeField = 'Time';
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
      time: Duration(seconds: map[GameTimeLogEntityData.timeField] as int),
    );

  }

  static List<GameTimeLogEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameTimeLogEntity> timeLogsList = <GameTimeLogEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final GameTimeLogEntity log = GameTimeLogEntity.fromDynamicMap( ItemEntity.combineMaps(manyMap, GameTimeLogEntityData.table) );

      timeLogsList.add(log);
    });

    return timeLogsList;

  }

  Map<String, Object?> createMap(int gameId) {

    final Map<String, Object?> createMap = <String, Object?>{
      GameTimeLogEntityData.gameField : gameId,
      GameTimeLogEntityData.dateTimeField : dateTime,
      GameTimeLogEntityData.timeField : time,
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
        '{$GameTimeLogEntityData.dateTimeField}: $dateTime, '
        '{$GameTimeLogEntityData.timeField}: $time'
        ' }';

  }
}