import 'model.dart' show ItemFinish;

class GameFinish extends ItemFinish {
  const GameFinish({
    required DateTime dateTime,
  }) : super(
          dateTime: dateTime,
          uniqueId: 'GF$dateTime',
        );

  @override
  GameFinish copyWith({
    DateTime? dateTime,
  }) {
    return GameFinish(
      dateTime: dateTime ?? this.dateTime,
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
