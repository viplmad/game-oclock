import 'entity.dart' show ItemEntity, GameEntityData, GameID;

class GameTimeLogEntityData {
  GameTimeLogEntityData._();

  static const String table = 'GameLog';

  static const String gameField = GameEntityData.relationField;
  static const String dateTimeField = 'DateTime';
  static const String timeField = 'Time';
}

class GameTimeLogID {
  GameTimeLogID(this.gameId, this.dateTime);

  final GameID gameId;
  final DateTime dateTime;

  @override
  String toString() => gameId.toString();
}

class GameTimeLogEntity extends ItemEntity {
  const GameTimeLogEntity({
    required this.gameId,
    required this.dateTime,
    required this.time,
  });

  final int gameId;
  final DateTime dateTime;
  final Duration time;

  static GameTimeLogEntity fromMap(Map<String, Object?> map) {
    return GameTimeLogEntity(
      gameId: map[GameTimeLogEntityData.gameField] as int,
      dateTime: map[GameTimeLogEntityData.dateTimeField] as DateTime,
      time: map[GameTimeLogEntityData.timeField] as Duration,
    );
  }

  static GameTimeLogID idFromMap(Map<String, Object?> map) {
    return GameTimeLogID(
      GameID(map[GameTimeLogEntityData.gameField] as int),
      map[GameTimeLogEntityData.dateTimeField] as DateTime,
    );
  }

  GameTimeLogID createId() {
    return GameTimeLogID(GameID(gameId), dateTime);
  }

  Map<String, Object?> createMap() {
    final Map<String, Object?> createMap = <String, Object?>{
      GameTimeLogEntityData.gameField: gameId,
      GameTimeLogEntityData.dateTimeField: dateTime,
      GameTimeLogEntityData.timeField: time,
    };

    return createMap;
  }

  Map<String, Object?> updateMap(GameTimeLogEntity updatedEntity) {
    final Map<String, Object?> updateMap = <String, Object?>{};

    putUpdateMapValue(
      updateMap,
      GameTimeLogEntityData.dateTimeField,
      dateTime,
      updatedEntity.dateTime,
    );
    putUpdateMapValue(
      updateMap,
      GameTimeLogEntityData.timeField,
      time,
      updatedEntity.time,
    );

    return updateMap;
  }

  @override
  List<Object> get props => <Object>[
        dateTime,
        time,
      ];

  @override
  String toString() {
    return '${GameTimeLogEntityData.table}Entity { '
        '${GameTimeLogEntityData.gameField}: $gameId, '
        '${GameTimeLogEntityData.dateTimeField}: $dateTime, '
        '${GameTimeLogEntityData.timeField}: $time'
        ' }';
  }
}
