import 'entity.dart' show ItemEntity, GameEntityData, GameEntity, GameID;


class GameFinishEntityData {
  GameFinishEntityData._();

  static const String table = 'GameFinish';

  static const String gameField = GameEntityData.relationField;
  static const String dateField = 'Date';
}

class GameFinishID {
  GameFinishID(this.gameId, this.dateTime);

  final GameID gameId;
  final DateTime dateTime;
}

class GameFinishEntity extends ItemEntity {
  const GameFinishEntity({
    required this.gameId,
    required this.dateTime,
  });

  final int gameId;
  final DateTime dateTime;

  static GameFinishEntity fromMap(Map<String, dynamic> map) {

    return GameFinishEntity(
      gameId: map[GameFinishEntityData.gameField] as int,
      dateTime: map[GameFinishEntityData.dateField] as DateTime,
    );

  }

  static GameFinishID idFromMap(Map<String, dynamic> map) {

    return GameFinishID(GameEntity.idFromMap(map), map[GameFinishEntityData.dateField] as DateTime);

  }

  GameFinishID createId() {

    return GameFinishID(GameID(gameId), dateTime);

  }

  Map<String, Object?> createMap() {

    final Map<String, Object?> createMap = <String, Object?>{
      GameFinishEntityData.gameField : gameId,
      GameFinishEntityData.dateField : dateTime,
    };

    return createMap;

  }

  Map<String, Object?> updateMap(GameFinishEntity updatedEntity) {

    final Map<String, Object?> updateMap = <String, Object?>{};

    putUpdateMapValue(updateMap, GameFinishEntityData.dateField, dateTime, updatedEntity.dateTime);

    return updateMap;

  }

  @override
  List<Object> get props => <Object>[
    dateTime,
  ];

  @override
  String toString() {

    return '${GameFinishEntityData.table}Entity { '
        '${GameFinishEntityData.gameField}: $gameId, '
        '${GameFinishEntityData.dateField}: $dateTime'
        ' }';

  }
}