import 'package:equatable/equatable.dart';

import 'package:backend/query/query.dart';
import 'package:backend/query/fields.dart';

import 'entity.dart';


class GameFinishEntityData {
  GameFinishEntityData._();

  static const String table = 'GameFinish';
  static const String readTable = 'Game-Finish';

  static const String _gameField = GameEntityData.relationField;
  static const String _dateField = 'Date';

  static Fields fields() {

    final Fields fields = Fields();
    fields.add(_gameField, int);
    fields.add(_dateField, DateTime);

    return fields;

  }

  static Query idQuery(int gameId, DateTime date) {

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

  static GameFinishEntity _fromDynamicMap(Map<String, dynamic> map) {

    return GameFinishEntity(
      dateTime: map[GameFinishEntityData._dateField] as DateTime,
    );

  }

  static List<GameFinishEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameFinishEntity> finishList = <GameFinishEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final GameFinishEntity date = GameFinishEntity._fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, GameFinishEntityData.table) );

      finishList.add(date);
    });

    return finishList;

  }

  Map<String, dynamic> createDynamicMap(int gameId) {

    final Map<String, dynamic> createMap = <String, dynamic>{
      GameFinishEntityData._gameField : gameId,
      GameFinishEntityData._dateField : dateTime,
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
        '{$GameFinishEntityData._dateTimeField}: $dateTime'
        ' }';

  }
}