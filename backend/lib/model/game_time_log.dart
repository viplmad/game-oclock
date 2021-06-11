import 'package:equatable/equatable.dart';


class GameTimeLog extends Equatable implements Comparable<GameTimeLog> {
  const GameTimeLog({
    required this.dateTime,
    required this.time,
  });

  final DateTime dateTime;
  final Duration time;

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