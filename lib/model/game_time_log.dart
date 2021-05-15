import 'package:equatable/equatable.dart';

import 'package:game_collection/entity/entity.dart';


class GameTimeLog extends Equatable implements Comparable<GameTimeLog> {
  const GameTimeLog({
    required this.dateTime,
    required this.time,
  });

  final DateTime dateTime;
  final Duration time;

  static GameTimeLog fromEntity(GameTimeLogEntity entity) {

    return GameTimeLog(
      dateTime: entity.dateTime,
      time: entity.time,
    );

  }

  GameTimeLogEntity toEntity() {

    return GameTimeLogEntity(
      dateTime: this.dateTime,
      time: this.time,
    );

  }

  GameTimeLog copyWith({
    DateTime? dateTime,
    Duration? time,
  }) {

    return GameTimeLog(
      dateTime: dateTime?? this.dateTime,
      time: time?? this.time,
    );

  }

  @override
  List<Object> get props => <Object>[
    dateTime,
    time,
  ];

  @override
  String toString() {

    return 'GameTimeLog { '
        'DateTime: $dateTime, '
        'Time: $time'
        ' }';

  }

  @override
  int compareTo(GameTimeLog other) => this.dateTime.compareTo(other.dateTime);
}