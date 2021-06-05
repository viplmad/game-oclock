import 'package:equatable/equatable.dart';

import 'package:backend/query/query.dart';

import 'entity.dart';


class GameFinishEntityData {
  GameFinishEntityData._();

  static const String table = 'GameFinish';
  static const String readTable = 'Game-Finish';

  static const String _gameField = GameEntityData.relationField;
  static const String _dateField = 'Date';

  static const Map<String, Type> fields = <String, Type>{
    _gameField : int,
    _dateField : DateTime,
  };

  static Query getIdQuery(int gameId, DateTime date) {

    final Query idQuery = Query();
    idQuery.addAnd(_gameField, gameId);
    idQuery.addAnd(_dateField, date);

    return idQuery;

  }
}

class GameFinishEntity extends Equatable {
  const GameFinishEntity({
    required this.dateTime,
  });

  final DateTime dateTime;

  static GameFinishEntity fromDynamicMap(Map<String, dynamic> map) {

    return GameFinishEntity(
      dateTime: map[GameFinishEntityData._dateField] as DateTime,
    );

  }

  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      GameFinishEntityData._dateField : dateTime,
    };

  }

  Map<String, dynamic> getCreateDynamicMap(int gameId) {

    final Map<String, dynamic> createMap = <String, dynamic>{
      GameFinishEntityData._gameField : gameId,
      GameFinishEntityData._dateField : dateTime,
    };

    return createMap;

  }

  static List<GameFinishEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameFinishEntity> finishList = <GameFinishEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final GameFinishEntity date = GameFinishEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, GameFinishEntityData.table) );

      finishList.add(date);
    });

    return finishList;

  }

  @override
  List<Object> get props => <Object>[
    dateTime,
  ];

  @override
  String toString() {

    return '{$GameFinishEntityData.table}Entity { '
        '{$GameFinishEntityData._dateTimeField}: $dateTime'
        ' }';

  }
}