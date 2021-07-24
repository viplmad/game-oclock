import 'collection_item.dart' show Item, ItemImage;


class GameTimeLog extends Item implements Comparable<GameTimeLog> {
  const GameTimeLog({
    required this.dateTime,
    required this.time,
  }) : this.uniqueId = 'GT$dateTime';

  final DateTime dateTime;
  final Duration time;

  @override
  final String uniqueId;

  @override
  final bool hasImage = false;
  @override
  final ItemImage image = const ItemImage(null, null);
  @override
  final String queryableTerms = '';

  @override
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