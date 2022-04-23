import 'model.dart' show Item, ItemImage;

class GameTimeLog extends Item implements Comparable<GameTimeLog> {
  const GameTimeLog({
    required this.dateTime,
    required this.time,
  }) : super(
          uniqueId: 'GT$dateTime',
          hasImage: false,
          queryableTerms: '',
        );

  final DateTime dateTime;
  final Duration time;

  DateTime get endDateTime => dateTime.add(time);

  @override
  final ItemImage image = const ItemImage(null, null);

  @override
  GameTimeLog copyWith({
    DateTime? dateTime,
    Duration? totalTime,
  }) {
    return GameTimeLog(
      dateTime: dateTime ?? this.dateTime,
      time: totalTime ?? time,
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
  int compareTo(GameTimeLog other) =>
      dateTime.compareTo(other.dateTime); // Earlier dates first
}
