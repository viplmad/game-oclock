import 'model.dart' show ItemFinish, ItemImage;


class GameFinish extends ItemFinish {
  const GameFinish({
    required DateTime dateTime,
  }) :
    this.uniqueId = 'GF$dateTime',
    super(dateTime: dateTime);

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