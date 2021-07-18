import 'package:equatable/equatable.dart';

import 'entity.dart';


class GameFinishEntityData {
  GameFinishEntityData._();

  static const String table = 'GameFinish';

  static const String gameField = GameEntityData.relationField;
  static const String dateField = 'Date';
}

class GameFinishEntity extends Equatable {
  const GameFinishEntity({
    required this.dateTime,
  });

  final DateTime dateTime;

  static GameFinishEntity _fromDynamicMap(Map<String, dynamic> map) {

    return GameFinishEntity(
      dateTime: map[GameFinishEntityData.dateField] as DateTime,
    );

  }

  static List<GameFinishEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameFinishEntity> finishList = <GameFinishEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final GameFinishEntity date = GameFinishEntity._fromDynamicMap( ItemEntity.combineMaps(manyMap, GameFinishEntityData.table) );

      finishList.add(date);
    });

    return finishList;

  }

  Map<String, Object?> createMap(int gameId) {

    final Map<String, Object?> createMap = <String, Object?>{
      GameFinishEntityData.gameField : gameId,
      GameFinishEntityData.dateField : dateTime,
    };

    return createMap;

  }

  @override
  List<Object> get props => <Object>[
    dateTime,
  ];

  @override
  String toString() {

    return '{$GameFinishEntityData.table}Entity { '
        '{$GameFinishEntityData.dateTimeField}: $dateTime'
        ' }';

  }
}