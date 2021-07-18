import 'model.dart';


class GameFinish extends Item {
  const GameFinish({
    required this.dateTime,
  }) : this.uniqueId = '$dateTime';

  final DateTime dateTime;

  @override
  final String uniqueId;

  @override
  final bool hasImage = false;
  @override
  final ItemImage image = const ItemImage(null, null);
  @override
  final String queryableTerms = '';

  @override
  GameFinish copyWith({
    DateTime? dateTime,
  }) {

    return GameFinish(
      dateTime: dateTime?? this.dateTime,
    );

  }

  @override
  List<Object> get props => <Object>[
    dateTime,
  ];

  @override
  String toString() {

    return 'GameFinish { '
        'DateTime: $dateTime'
        ' }';

  }
}