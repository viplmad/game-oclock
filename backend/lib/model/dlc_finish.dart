import 'model.dart' show ItemFinish, ItemImage;


class DLCFinish extends ItemFinish {
  const DLCFinish({
    required DateTime dateTime,
  }) :
    this.uniqueId = 'DF$dateTime',
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
  DLCFinish copyWith({
    DateTime? dateTime,
  }) {

    return DLCFinish(
      dateTime: dateTime?? this.dateTime,
    );

  }

  @override
  List<Object> get props => <Object>[
    dateTime,
  ];

  @override
  String toString() {

    return 'DLCFinish { '
        'DateTime: $dateTime'
        ' }';

  }
}